//
//  SocketConfigData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/17.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocketConfigData.h"
#import "NSString+PushExtTools.h"

#import "PushLogWrapper.h"

static NSString * const PUSH_PARAMS_SERVER = @"serverIP";
static NSString * const PUSH_PARAMS_PORT   = @"port";
static NSString * const PUSH_PARAMS_RATE   = @"rate";
static NSString * const PUSH_PARAMS_TIMES  = @"times";
static NSString * const PUSH_PARAMS_RECONNECT = @"reconnect";

//实现
@implementation PushSocketConfigData

#pragma mark -- 初始化数据
-(void)initialConfigWithDict:(NSDictionary *)dict{
    if(!dict || !dict.count) return;
    _server = dict[PUSH_PARAMS_SERVER];//1.socket服务器IP
    _port = [dict[PUSH_PARAMS_PORT] unsignedIntegerValue];//2.socket服务器端口
    _rate = [dict[PUSH_PARAMS_RATE] unsignedIntegerValue];//3.socket心跳间隔(秒)
    _times = [dict[PUSH_PARAMS_TIMES] unsignedIntegerValue];//4.socket丢失心跳间隔次数
    _reconnect = [dict[PUSH_PARAMS_RECONNECT] unsignedIntegerValue];//5.socket重连间隔(秒)
}

#pragma mark -- 设置心跳时间间隔(秒)
-(void)setRate:(NSUInteger)rate{
    if(_rate != rate && rate > 0){
        LogD(@"重置心跳时间间隔(%zd)=>%zd", _rate, rate);
        _rate = rate;
    }
}

#pragma mark -- 设置重连时间间隔(秒)
-(void)setReconnect:(NSUInteger)reconnect{
    if(_reconnect != reconnect && reconnect > 0){
        LogD(@"重置重连时间(%zd)=>%zd", _reconnect, reconnect);
        _reconnect = reconnect;
    }
}

@end
