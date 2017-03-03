//
//  AccessData.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PushSocketConfigData.h"

/**
 * @brief 接入数据。
 **/
@interface PushAccessData : NSObject

/**
 * @brief 获取服务器地址。
 **/
@property(strong, nonatomic,readonly)NSString *url;

/**
 * @brief 获取接入帐号。
 **/
@property(strong,nonatomic,readonly)NSString *account;

/**
 * @brief 获取接入密钥。
 **/
@property(strong,nonatomic,readonly)NSString *password;

/**
 * @brief 获取设备令牌。
 **/
@property(strong,nonatomic,readonly)NSString *deviceToken;

/**
 * @brief 获取设备名称。
 **/
@property(strong,nonatomic,readonly)NSString *deviceName;

/**
 * @brief 获取用户标签(应与服务端发送目标一致)。
 **/
@property(strong,nonatomic,readonly)NSString *tag;

/**
 * @brief 获取socket配置数据。
 **/
@property(strong,nonatomic,readonly)PushSocketConfigData *socket;

/**
 * @brief 静态单例子。
 **/
+(instancetype)sharedAccess;

/**
 * @brief 初始化数据。
 * @param url 接入URL地址。
 * @param account 接入帐号。
 * @param pwd 接入密钥。
 * @param token 设备令牌。
 **/
-(void)initialWithURL:(NSString *)url andAccount:(NSString *)account andPassword:(NSString *)pwd andDeviceToken:(NSData *)token;

/**
 * @brief 重置设备用户标签。
 * @param tag 用户标签。
 * @return 重置成功。
 **/
-(BOOL)addOrUpdateDeviceUserWithTag:(NSString *)tag;

/**
 * @brief 添加或更新Socket配置。
 * @param config socket配置。
 * @return 结果状态。
 **/
-(BOOL)addOrUpdateConfigWithSocket:(NSDictionary *)config;

@end
