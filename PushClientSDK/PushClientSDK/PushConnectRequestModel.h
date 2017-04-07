//
//  ConnectRequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushRequestModel.h"

/**
 * 设备类型值
 **/
FOUNDATION_EXPORT NSUInteger const PUSH_CURRENT_DEVICE_TYPE_VALUE;

/**
 * @brief 连接请求。
 **/
@interface PushConnectRequestModel : PushRequestModel

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
