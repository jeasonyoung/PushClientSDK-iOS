//
//  NSString+ExtTools.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "NSString+PushExtTools.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (PushExtTools)

#pragma mark -- 清除前后空格
-(NSString *)trim{
    if([self length]){
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self;
}

#pragma mark -- md5加密后的hex字符串
-(NSString *)md5{
    if(![[self trim] length]) return nil;
    //
    const char *val = [self trim].UTF8String;
    unsigned char outputBuf[CC_MD5_DIGEST_LENGTH];
    CC_MD5(val, (unsigned)strlen(val), outputBuf);
    //
    NSMutableString *outputStr = [[NSMutableString alloc] initWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];
    for(NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [outputStr appendFormat:@"%02x", outputBuf[i]];
    }
    return outputStr;
}

#pragma mark -- 将NSData转换为Hex格式
+(NSString *)dataToHex:(NSData *)data{
    if(!data || data.length == 0) return nil;
    //
    NSMutableString *hexStr = [[NSMutableString alloc]  initWithCapacity:(data.length * 2)];
    const unsigned char *buf = data.bytes;
    for(NSInteger i = 0; i < data.length; i++){
        [hexStr appendFormat:@"%02x", buf[i]];
    }
    return hexStr;
}

@end
