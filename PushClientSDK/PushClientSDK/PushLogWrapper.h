//
//  Log.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/3/27.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LogD(fmt,...) [[PushLogWrapper sharedInstance] debugWithFormat:(@"[文件名:%s][函数名:%s][行号:%d]\n" fmt),__FILE__,__FUNCTION__,__LINE__,##__VA_ARGS__]
#define LogI(fmt,...) [[PushLogWrapper sharedInstance] infoWithFormat:(@"[文件名:%s][函数名:%s][行号:%d]\n" fmt),__FILE__,__FUNCTION__,__LINE__,##__VA_ARGS__]
#define LogW(fmt,...) [[PushLogWrapper sharedInstance] warnWithFormat:(@"[文件名:%s][函数名:%s][行号:%d]\n" fmt),__FILE__,__FUNCTION__,__LINE__,##__VA_ARGS__]
#define LogE(fmt,...) [[PushLogWrapper sharedInstance] errorWithFormat:(@"[文件名:%s][函数名:%s][行号:%d]\n" fmt),__FILE__,__FUNCTION__,__LINE__,##__VA_ARGS__]


/**
 * @brief 日志管理
 **/
@interface PushLogWrapper : NSObject

/**
 * @brief 单例实例。
 **/
+(instancetype)sharedInstance;

/**
 * @brief 输出debug日志。
 * @param format 日志格式。
 * @param ... 日志参数。
 **/
-(void)debugWithFormat:(NSString *)format,... NS_FORMAT_FUNCTION(1, 2);

/**
 * @brief 输出info日志。
 * @param format 日志格式。
 * @param ... 日志参数。
 **/
-(void)infoWithFormat:(NSString *)format,... NS_FORMAT_FUNCTION(1, 2);

/**
 * @brief 输出warn日志。
 * @param format 日志格式。
 * @param ... 日志参数。
 **/
-(void)warnWithFormat:(NSString *)format,... NS_FORMAT_FUNCTION(1, 2);

/**
 * @brief 输出error日志。
 * @param format 日志格式。
 * @param ... 日志参数。
 **/
-(void)errorWithFormat:(NSString *)format,... NS_FORMAT_FUNCTION(1, 2);

@end
