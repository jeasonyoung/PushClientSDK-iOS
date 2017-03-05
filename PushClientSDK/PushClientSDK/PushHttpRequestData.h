//
//  RequestData.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PushBaseModel.h"
#import "PushAccessData.h"

/**
 * @brief HTTP请求数据类。
 **/
@interface PushHttpRequestData : PushBaseModel

/**
 * @brief 初始化。
 * @param access 访问数据。
 **/
-(instancetype)initWithAccess:(const PushAccessData *)access;

/**
 * @brief 转换为签名后的参数集合。
 * @return 签名后的参数集合。
 **/
-(NSDictionary *)toSignParameters;

@end
