//
//  PushSocket.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/19.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocket.h"
#import "PushSocket+MessageHandler.h"
#import "PushSocket+Timer.h"

#import "GCDAsyncSocket.h"
#import "CodecDecoder.h"

#define DISPATCH_QUEUE_DQ_NAME "com.csblank.push.dq"

//成员变量
@interface PushSocket ()<GCDAsyncSocketDelegate,CodecDecoderDelegate>{
    /**
     * @brief socket通讯对象。
     **/
    GCDAsyncSocket *_socket;
    /**
     * @brief 消息解码器。
     **/
    CodecDecoder *_decoder;
}

@end

//实现。
@implementation PushSocket

#pragma mark -- 静态化处理
+(instancetype)shareSocket{
    static PushSocket *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PushSocket alloc] init];
    });
    return _instance;
}

#pragma mark -- 初始化
-(instancetype)init{
    if(self = [super init]){
        _isRun = _isStart = NO;
        //1.异步socket委托处理线程队列
        dispatch_queue_t dq = dispatch_queue_create(DISPATCH_QUEUE_DQ_NAME, NULL);
        //2.socket异步处理初始化
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dq];
        //3.消息编码
        _encoder = [[CodecEncoder alloc] init];
        //4.消息解码
        _decoder = [[CodecDecoder alloc] init];
        
        _decoder.delegate = self;
    }
    return self;
}

#pragma mark -- GCD Async Socket Delegate
#pragma mark -- 连接成功调用
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socket(%@:%d)连接服务器成功!", host, port);
    if(!_isRun)_isRun = YES;//连接成功
    if(!_config){
        [self throwsErrorWithMessageType:PushSocketMessageTypeConnect andMessage:@"获取配置数据失败!"];
        return;
    }
    //发送连接请求
    __weak typeof(self) wSelf = self;
    [_encoder encoderConnectWithConfig:_config handler:^(NSData *data) {
        NSLog(@"socket发送connectRequest请求...");
        //发送消息
        [wSelf sendRequestWithData:data];
    }];
}
#pragma mark -- 连接失败或断开连接调用
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    _isRun = NO;
    //是否已关闭服务
    if(self.isStart){
        //准备启动重新连接定时器。
        [self restartConnectHandler];
    }
}
#pragma mark -- 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"开始读取socket反馈数据处理...");
    if(!data || !data.length) return;
    //设置时间戳
    _lastIdleTime = [NSDate date].timeIntervalSince1970;
    //解码处理
    [_decoder decoderWithAppendData:data];
}
#pragma mark -- 写入数据
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"socket发送数据完成!");
    //设置时间戳
    _lastIdleTime = [NSDate date].timeIntervalSince1970;
}

#pragma mark -- CodecDecoderDelegate
-(void)decoderWithType:(PushSocketMessageType)type andAckModel:(id)model{
    NSLog(@"decoderWithType(%ld)andAckModel=>%@",type,model);
    switch (type) {
        case PushSocketMessageTypePingresp:{//心跳请求应答:
            [self receivePingAckHandler:model];
            break;
        }
        case PushSocketMessageTypeConnack://连接请求应答
        case PushSocketMessageTypePubrel://推送消息达到请求应答
        case PushSocketMessageTypeSuback://用户登录请求应答
        case PushSocketMessageTypeUnsuback://用户注销请求应答
        {
            [self receiveAckHandler:model];
            break;
        }
        case PushSocketMessageTypePublish:{//推送消息下发
            [self receivePublishHandler:model];
            break;
        }
        default:break;
    }
}

#pragma mark -- 公开方法实现
#pragma mark -- 启动
-(void)start{
    NSLog(@"PushSocket-start...");
    if(self.isRun){//判断是否已经启动。
        NSLog(@"socket已启动!");
        return;
    }
    _isStart = YES;//设置启动。
    NSLog(@"准备启动socket...");
    //获取配置
    AccessData *conf = nil;
    if(![self loadWithConfig:&conf]){
        [self throwsErrorWithMessageType:PushSocketMessageTypeConnect andMessage:@"获取配置失败!"];
        return;
    }
    //验证socket配置。
    if(!conf || !conf.socket){
        [self throwsErrorWithMessageType:PushSocketMessageTypeConnect andMessage:@"获取socket配置失败!"];
        return;
    }
    //重置
    _config = conf;
    //开始连接socket服务器
    if([_socket isDisconnected]){
        _isRun = YES;//设置已启动
        //连接服务器
        NSError *err = nil;
        SocketConfigData *cfg = conf.socket;
        if(!(_isRun = [_socket connectToHost:cfg.server onPort:cfg.port error:&err])){
            [self throwsErrorWithMessageType:PushSocketMessageTypeConnect andError:err];
            return;
        }
    }
}
#pragma mark -- 添加或更改用户标签处理。
-(void)addOrChangedTagHandler{
    NSLog(@"PushSocket-addOrChangedTagHandler...");
    //获取配置
    AccessData *conf = nil;
    if(![self loadWithConfig:&conf]){
        [self throwsErrorWithMessageType:PushSocketMessageTypeSubscribe andMessage:@"获取配置失败!"];
        return;
    }
    //验证配置
    if(!conf || !conf.tag || !conf.tag.length){
        [self throwsErrorWithMessageType:PushSocketMessageTypeSubscribe andMessage:@"获取用户tag数据失败!"];
        return;
    }
    _config = conf;//替换
    //发起请求消息
    __weak typeof(self) wSelf = self;
    [_encoder encoderSubscribeWithConfig:_config handler:^(NSData *buf) {
        [wSelf sendRequestWithData:buf];
    }];
}
#pragma mark -- 清除用户标签处理
-(void)clearTagHandler{
    NSLog(@"PushSocket-clearTagHandler...");
    //获取配置
    AccessData *conf = nil;
    if(![self loadWithConfig:&conf]){
        [self throwsErrorWithMessageType:PushSocketMessageTypeSubscribe andMessage:@"获取配置失败!"];
        return;
    }
    //验证配置
    if(!conf || !conf.tag){
        [self throwsErrorWithMessageType:PushSocketMessageTypeSubscribe andMessage:@"获取用户tag数据失败!"];
        return;
    }
    _config = conf;//替换
    //发起请求消息
    __weak typeof(self) wSelf = self;
    [_encoder encoderUnsubscribeWithConfig:_config handler:^(NSData *buf) {
        [wSelf sendRequestWithData:buf];
    }];
}
#pragma mark -- 停止
-(void)stop{
    NSLog(@"PushSocket-stop...");
    _isStart = NO;//停止关闭
    if(!_config){
        [self throwsErrorWithMessageType:PushSocketMessageTypeSubscribe andMessage:@"获取配置失败!"];
        return;
    }
    //发起请求消息
    __weak typeof(self) wSelf = self;
    [_encoder encoderDisconnectWithConfig:_config handler:^(NSData * buf){
        [wSelf sendRequestWithData:buf];
    }];
}

#pragma mark -- 发送请求数据。
-(void)sendRequestWithData:(NSData *)data{
    if(!data || !data.length || !_socket)return;
    NSLog(@"socket开始发送请求数据(%ld)....", data.length);
    [_socket writeData:data withTimeout:-1 tag:0];
    if(self.isStart){
        [_socket readDataWithTimeout:-1 tag:0];
    }
}

#pragma mark -- 异常消息处理
-(void)throwsErrorWithMessageType:(PushSocketMessageType)type andMessage:(NSString *)message{
    NSError *err = [NSError errorWithDomain:@"pushSocket" code:-1 userInfo:@{NSLocalizedDescriptionKey:message}];
    [self throwsErrorWithMessageType:type andError:err];
}

#pragma mark -- 异常消息处理
-(void)throwsErrorWithMessageType:(PushSocketMessageType)type andError:(NSError *)error{
    if(!self.delegate) return;
    if([self.delegate respondsToSelector:@selector(pushSocket:withMessageType:throwsError:)]){
        [self.delegate pushSocket:self withMessageType:type throwsError:error];
    }
}

#pragma mark -- 内部方法

#pragma mark -- 获取配置
-(BOOL)loadWithConfig:(AccessData **)cfg{
    if(!self.delegate) return NO;
    if([self.delegate respondsToSelector:@selector(pushSocket:withAccessConfig:)]){
        [self.delegate pushSocket:self withAccessConfig:&(*cfg)];
        return YES;
    }
    return NO;
}


@end
