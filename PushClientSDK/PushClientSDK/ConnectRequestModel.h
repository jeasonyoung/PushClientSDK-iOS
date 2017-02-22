//
//  ConnectRequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

/**
 * @brief 连接请求。
 **/
@interface ConnectRequestModel : RequestModel

/**
 * @brief 获取或设置设备名称。
 **/
@property(copy, nonatomic)NSString *deviceName;

/**
 * @brief 获取或设置设备类型。
 **/
@property(assign, nonatomic, readonly)NSUInteger deviceType;

/**
 * @brief 获取或设置设备用户(tag)。
 **/
@property(copy, nonatomic)NSString *deviceAccount;

@end
