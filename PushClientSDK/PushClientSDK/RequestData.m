//
//  RequestData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "RequestData.h"
#import "NSString+ExtTools.h"

NSString * const REQ_PARAMS_ACCOUNT = @"account";
NSString * const REQ_PARAMS_SIGN    = @"sign";

@implementation RequestData

#pragma mark -- 构造函数
-(instancetype)initWithAccess:(const AccessData *)access{
    if(self = [super init]){
        _accessData = access;
        _parameters = @{REQ_PARAMS_ACCOUNT:_accessData.account };
    }
    return self;
}

#pragma mark -- 参数签名
-(NSDictionary *)toSignParameters{
    if(!self.parameters || !self.parameters.count) return nil;
    NSDictionary *dict = [self.parameters copy];
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare:key2];
    }];
    NSMutableString *str  = [NSMutableString string];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        id val = [dict objectForKey:key];
        if(!val) return;//1.排除对象为null
        if([val isKindOfClass:[NSNull class]]) return;//2.排除为null对象
        if([val isKindOfClass:[NSString class]] && [((NSString *)val) trim].length == 0) return;//3.空字符串
        if([val isKindOfClass:[NSNumber class]] && ((NSNumber *)val).doubleValue == 0) return;//4.数字为0
        //添加到字符串
        [str appendFormat:@"%@=%@&", key, val];
    }];
    if(str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    NSLog(@"md5前字符串-1=>%@", str);
    //添加
    [str appendString:_accessData.password];
    NSString *sign = [str md5];
    NSLog(@"md5前字符串-2(sign:%@)=>%@", sign, str);
    NSMutableDictionary *signParams = [NSMutableDictionary dictionaryWithDictionary:[self.parameters copy]];
    [signParams setObject:sign forKey:REQ_PARAMS_SIGN];
    return signParams;
}

@end
