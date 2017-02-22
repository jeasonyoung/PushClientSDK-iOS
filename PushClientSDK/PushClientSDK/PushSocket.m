//
//  PushSocket.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/19.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocket.h"
#import "GCDAsyncSocket.h"

#define DISPATCH_QUEUE_DQ_NAME "com.csblank.push_dq"

//成员变量
@interface PushSocket ()<GCDAsyncSocketDelegate>{
    GCDAsyncSocket *_socket;
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
        _isRun = NO;
        dispatch_queue_t dq = dispatch_queue_create(DISPATCH_QUEUE_DQ_NAME, NULL);
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dq];
    }
    return self;
}

#pragma mark -- GCD Async Socket Delegate
#pragma mark -- 连接成功调用
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
}
#pragma mark -- 连接失败或断开连接调用
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
}
#pragma mark -- 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
#pragma mark -- 写入数据
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}


#pragma mark -- 启动
-(void)start{
    
}
#pragma mark -- 添加或更改用户标签处理。
-(void)addOrChangedTagHandler{
    
}
#pragma mark -- 清除用户标签处理
-(void)clearTagHandler{
    
}
#pragma mark -- 停止
-(void)stop{
    
}
@end
