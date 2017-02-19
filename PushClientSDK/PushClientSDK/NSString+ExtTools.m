//
//  NSString+ExtTools.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "NSString+ExtTools.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (ExtTools)

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

@end
