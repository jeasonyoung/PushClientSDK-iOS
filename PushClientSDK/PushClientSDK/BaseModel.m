//
//  BaseModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "BaseModel.h"
#import "NSString+ExtTools.h"


NSString * const PARAMS_ACCOUNT = @"account";
NSString * const PARAMS_SIGN    = @"sign";

//实现
@implementation BaseModel


#pragma mark --参数签名。
-(NSDictionary *)toSign{
    if(!_params){
        @throw [NSException exceptionWithName:@"_params" reason:@"_params参数为空！" userInfo:nil];
    }
    if(!self.account || !self.account.length){
        @throw [NSException exceptionWithName:PARAMS_ACCOUNT reason:@"接入帐号不能为空" userInfo:nil];
    }
    if(!self.token || !self.token.length){
        @throw [NSException exceptionWithName:@"token" reason:@"接入密钥不能为空" userInfo:nil];
    }
    if(![self.account isEqualToString:(_params[PARAMS_ACCOUNT])]){
        @throw [NSException exceptionWithName:PARAMS_ACCOUNT reason:@"account未配置到参数集合中!" userInfo:nil];
    }
    NSMutableDictionary *signParams = [NSMutableDictionary dictionaryWithDictionary:_params];
    NSString *sign = [self toSignWithParams:signParams withToken:self.token];
    [signParams setObject:sign forKey:PARAMS_SIGN];
    NSLog(@"sign-params=>%@", signParams);
    return signParams;
}

#pragma mark -- 签名算法
-(NSString *)toSignJson{
    NSDictionary *dict = [self toSign];
    if(!dict || !dict.count){
        return nil;
    }
    //json
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    if(!jsonData || err != nil){
        @throw [NSException exceptionWithName:@"序列化为JSON失败!" reason:(err ? err.localizedDescription : @"") userInfo:nil];
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark -- 参数签名
-(NSString *)toSignWithParams:(NSDictionary *)params withToken:(NSString *)token {
    if(!params || !params.count) return nil;
    NSDictionary *dict = [params copy];
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare:key2];
    }];
    NSMutableString *str  = [NSMutableString string];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        if([key isEqualToString:PARAMS_SIGN]) return;//0.关键字为sign的排除
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
    [str appendString:token];
    NSString *sign = [str md5];
    NSLog(@"md5前字符串-2(sign:%@)=>%@", sign, str);
    return sign;
}


@end
