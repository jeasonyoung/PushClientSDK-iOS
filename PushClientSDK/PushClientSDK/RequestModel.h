//
//  RequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "PushSocketMessageType.h"

/**
 * @brief 请求参数-设备ID字段名。
 **/
FOUNDATION_EXPORT NSString * const PARAMS_DEVICEID;

/**
 * @brief 请求模型。
 **/
@interface RequestModel : BaseModel

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
