//
//  NSString+ExtTools.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PushExtTools)

/**
 * @brief 清除字符串中的空格。
 * @return 清除前后空格后的字符串。
 **/
-(NSString *)trim;

/**
 * @brief 字符串进行MD5加密。
 * @return MD5加密后的Hex格式字符串。
 **/
-(NSString *)md5;

/**
 * @brief 将NSData转换为Hex格式
 **/
+(NSString *)dataToHex:(NSData *)data;

@end
