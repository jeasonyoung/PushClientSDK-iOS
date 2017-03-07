//
//  RequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushBaseModel.h"
#import "PushSocketMessageType.h"

/**
 * @brief 请求参数-设备ID字段名。
 **/
FOUNDATION_EXPORT NSString * const PUSH_PARAMS_DEVICE_ID;

/**
 * @brief 请求模型。
 **/
@interface PushRequestModel : PushBaseModel

/**
 * @brief 获取消息类型。
 **/
@property(assign,nonatomic,readonly)PushSocketMessageType messageType;

/**
 * @brief 获取或设置设备唯一标示。
 **/
@property(copy, nonatomic)NSString *deviceId;

/**
 * @brief 初始化对象。
 * @param type 消息类型。
 * @return 返回构建对象。
 **/
-(instancetype)initWithMessageType:(PushSocketMessageType)type;

@end
