//
//  BaseModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 请求参数-接入帐号字段
 **/
FOUNDATION_EXPORT NSString * const PARAMS_ACCOUNT;
/**
 * @brief 请求参数-参数签名字段
 **/
FOUNDATION_EXPORT NSString * const PARAMS_SIGN;

/**
 * @brief 数据模型基础类。
 **/
@interface BaseModel : NSObject{
    /**
     * @brief  参数集合。
     **/
    @protected NSDictionary *_params;
}

/**
 * @brief 获取或设置接入帐号。
 **/
@property(copy,nonatomic)NSString *account;

/**
 * @brief 获取或设置接入密钥。
 **/
@property(copy,nonatomic)NSString *token;

/**
 * @brief 参数签名。
 * @return 签名后的参数集合。
 **/
-(NSDictionary *)toSign;

/**
 * @brief 参数签名并将参数转换为Json字符串。。
 * @return json字符串。
 **/

-(NSString *)toSignJson;

@end
