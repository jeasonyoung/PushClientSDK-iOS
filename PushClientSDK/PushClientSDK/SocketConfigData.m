//
//  SocketConfigData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/17.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "SocketConfigData.h"
#import "NSString+ExtTools.h"

//实现
@implementation SocketConfigData

#pragma mark -- 初始化数据
-(void)initialConfigWithDict:(NSDictionary *)dict{
    if(!dict || !dict.count) return;
    _server = [dict objectForKey:@"serverIP"];//1.socket服务器IP
    _port = [[dict objectForKey:@"port"] integerValue];//2.socket服务器端口
    _rate = [[dict objectForKey:@"rate"] integerValue];//3.socket心跳间隔(秒)
    _times = [[dict objectForKey:@"times"] integerValue];//4.socket丢失心跳间隔次数
    _reconnect = [[dict objectForKey:@"reconnect"] integerValue];//5.socket重连间隔
}

@end
