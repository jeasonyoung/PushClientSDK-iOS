//
//  PingResponseModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushPingResponseModel.h"

static NSString * const PUSH_PARAMS_HEART_RATE = @"heartRate";
static NSString * const PUSH_PARAMS_AFTER_CONNECT = @"afterConnect";
//实现。
@implementation PushPingResponseModel

#pragma mark -- 初始化
-(instancetype)initWithData:(NSDictionary *)data{
    if((self = [super init]) && data && data.count){
        //1
        _heartRate = [data[PUSH_PARAMS_HEART_RATE] integerValue];
        //2
        _afterConnect = [data[PUSH_PARAMS_AFTER_CONNECT] integerValue];
    }
    return self;
}

#pragma mark -- 静态构建
+(instancetype)pingResponseWithJSON:(NSString *)json{
    if(!json || json.length) return nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&err];
    if(!dict || err){
        NSLog(@"pingResponseWithJSON-异常:%@=>\n%@", err, json);
    }
    return [[PushPingResponseModel alloc] initWithData:dict];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{\"%@\":%zd,\"%@\":%zd}",
            PUSH_PARAMS_HEART_RATE,self.heartRate,PUSH_PARAMS_AFTER_CONNECT,self.afterConnect];
}

@end
