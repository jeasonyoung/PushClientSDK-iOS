//
//  SocketConfigData.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/17.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief socket配置数据。
 **/
@interface SocketConfigData : NSObject

/**
 * @brief 获取socket服务器地址。
 **/
@property(strong, nonatomic, readonly)NSString *server;

/**
 * @brief 获取socket服务器端口。
 **/
@property(assign, nonatomic, readonly)NSUInteger port;

/**
 * @brief 获取socket心跳间隔值(秒)。
 **/
@property(assign, nonatomic, readwrite)NSUInteger rate;

/**
 * @brief 获取socket心跳丢失次数。
 **/
@property(assign, nonatomic, readonly)NSUInteger times;

/**
 * @brief 获取socket重连时间(秒)。
 **/
@property(assign, nonatomic, readwrite)NSUInteger reconnect;

/**
 * @brief 初始化数据。
 * @param dict 字典数据。
 **/
-(void)initialConfigWithDict:(NSDictionary *)dict;

@end
