//
//  PushLogUpload.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/4/7.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushAccessData.h"

/**
 * @brief 日志上传
 **/
@interface PushLogUpload : NSObject

/**
 * @brief 单列对象。
 **/
+(instancetype)shareInstance;

/**
 * @brief 上传日志文件。
 * @param access 访问参数配置。
 **/
-(void)uploaderWithAccess:(PushAccessData*)access;

@end
