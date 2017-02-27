//
//  PingResponseModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PingResponseModel.h"

static NSString * const PARAMS_HEARTRATE = @"heartRate";
static NSString * const PARAMS_AFTERCONNECT = @"afterConnect";
//实现。
@implementation PingResponseModel

#pragma mark -- 初始化
-(instancetype)initWithData:(NSDictionary *)data{
    if((self = [super init]) && data && data.count){
        //1
        _heartRate = [data[PARAMS_HEARTRATE] integerValue];
        //2
        _afterConnect = [data[PARAMS_AFTERCONNECT] integerValue];
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
    return [[PingResponseModel alloc] initWithData:dict];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"{\"%@\":%ld,\"%@\":%ld}",
            PARAMS_HEARTRATE,self.heartRate,PARAMS_AFTERCONNECT,self.afterConnect];
}

@end
