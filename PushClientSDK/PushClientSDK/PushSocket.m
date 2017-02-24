//
//  PushSocket.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/19.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocket.h"
#import "GCDAsyncSocket.h"

#import "ConnectRequestModel.h"

#import "CodecEncoder.h"

#define DISPATCH_QUEUE_DQ_NAME "com.csblank.push.dq"

//成员变量
@interface PushSocket ()<GCDAsyncSocketDelegate>{
    GCDAsyncSocket *_socket;
    AccessData *_config;
    CodecEncoder *_encoder;
}
/**
 * @brief 是否已启动socket。
 **/
@property(assign,atomic)BOOL isStart;
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
    }
    return self;
}

#pragma mark -- GCD Async Socket Delegate
#pragma mark -- 连接成功调用
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socket(%@:%d)连接服务器成功!", host, port);
    if(!_isRun)_isRun = YES;//连接成功
    if(!_config){
        [self throwErrWithMessageType:PushSocketMessageTypeConnect throwsMessage:@"获取配置数据失败!"];
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
    if(_isStart){
        ///TODO:准备启动重新连接定时器。
    }
}
#pragma mark -- 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"开始读取socket反馈数据处理...");
    if(!data || !data.length) return;
    
}
#pragma mark -- 写入数据
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

#pragma mark -- 公开方法实现
#pragma mark -- 启动
-(void)start{
    if(!_isStart)_isStart = YES;//设置启动。
    if(self.isRun){//判断是否已经启动。
        NSLog(@"socket已启动!");
        return;
    }
    NSLog(@"准备启动socket...");
    //获取配置
    AccessData *conf = nil;
    if(![self loadWithConfig:&conf]){
        [self throwErrWithMessageType:PushSocketMessageTypeConnect throwsMessage:@"获取配置失败!"];
        return;
    }
    //验证socket配置。
    if(!conf || !conf.socket){
        [self throwErrWithMessageType:PushSocketMessageTypeConnect throwsMessage:@"获取socket配置失败!"];
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
            [self throwErrWithMessageType:PushSocketMessageTypeConnect throwsErr:err];
            return;
        }
    }
}
#pragma mark -- 添加或更改用户标签处理。
-(void)addOrChangedTagHandler{
    //获取配置
    AccessData *conf = nil;
    if(![self loadWithConfig:&conf]){
        [self throwErrWithMessageType:PushSocketMessageTypeSubscribe throwsMessage:@"获取配置失败!"];
        return;
    }
    //验证配置
    if(!conf || !conf.tag || !conf.tag.length){
        [self throwErrWithMessageType:PushSocketMessageTypeSubscribe throwsMessage:@"获取用户tag数据失败!"];
        return;
    }
    //TODO:
    
}
#pragma mark -- 清除用户标签处理
-(void)clearTagHandler{
    ///TODO:
    
}
#pragma mark -- 停止
-(void)stop{
    if(_isStart) _isStart = NO;//停止关闭
    
    ///TODO:
}

#pragma mark -- 内部方法

#pragma mark -- 发送请求数据
-(void)sendRequestWithData:(NSData *)data{
    if(!data || !data.length || !_socket)return;
    [_socket writeData:data withTimeout:-1 tag:0];
    [_socket readDataWithTimeout:-1 tag:0];
}

#pragma mark -- 获取配置
-(BOOL)loadWithConfig:(AccessData **)cfg{
    if(!self.delegate) return NO;
    if([self.delegate respondsToSelector:@selector(pushSocket:withAccessConfig:)]){
        [self.delegate pushSocket:self withAccessConfig:&(*cfg)];
        return YES;
    }
    return NO;
}

#pragma mark -- 抛出错误消息处理
-(void)throwErrWithMessageType:(PushSocketMessageType)type throwsMessage:(NSString *)error{
    NSError *err = [NSError errorWithDomain:@"pushSocket" code:-1 userInfo:@{NSLocalizedDescriptionKey:error}];
    [self throwErrWithMessageType:type throwsErr:err];
}

#pragma mark -- 抛出错误消息处理
-(void)throwErrWithMessageType:(PushSocketMessageType)type throwsErr:(NSError *)error{
    if(!self.delegate) return;
    if([self.delegate respondsToSelector:@selector(pushSocket:withMessageType:throwsError:)]){
        [self.delegate pushSocket:self withMessageType:type throwsError:error];
    }
}

@end
