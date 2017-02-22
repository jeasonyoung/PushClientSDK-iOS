//
//  SubscribeRequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

/**
 * @brief 用户登录请求数据。
 **/
@interface SubscribeRequestModel : RequestModel

/**
 * @brief 获取或设置设备用户名(tag)。
 **/
@property(copy, nonatomic)NSString *deviceAccount;

@end
