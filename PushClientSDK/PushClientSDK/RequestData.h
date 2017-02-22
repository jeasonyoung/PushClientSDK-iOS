//
//  RequestData.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
#import "AccessData.h"

/**
 * @brief 请求数据基础类。
 **/
@interface RequestData : BaseModel

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
