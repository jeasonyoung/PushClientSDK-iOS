//
//  RequestData.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AccessData.h"

/**
 * @brief 请求参数-接入帐号字段
 **/
FOUNDATION_EXPORT NSString * const REQ_PARAMS_ACCOUNT;
/**
 * @brief 请求参数-参数签名字段
 **/
FOUNDATION_EXPORT NSString * const REQ_PARAMS_SIGN;

/**
 * @brief 请求数据基础类。
 **/
@interface RequestData : NSObject{
    /**
     * @brief 接入访问数据。
     **/
    @protected const AccessData *_accessData;
}

/**
 * @brief 获取参数集合。
 **/
@property(strong,nonatomic,readonly)NSDictionary *parameters;

/**
 * @brief 初始化。
 * @param access 访问数据。
 **/
-(instancetype)initWithAccess:(const AccessData *)access;

/**
 * @brief 转换为签名后的参数集合。
 * @return 签名后的参数集合。
 **/
-(NSDictionary *)toSignParameters;

@end
