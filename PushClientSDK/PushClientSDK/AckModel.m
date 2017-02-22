//
//  AckModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "AckModel.h"

static NSString * const MODEL_RESULT = @"result";
static NSString * const MODEL_MSG    = @"msg";

//实现。
@implementation AckModel

#pragma mark -- 静态创建对象。
+(instancetype)ackWithType:(PushSocketMessageType)type andAckResult:(NSDictionary *)ack{
    if(!ack || !ack.count){
        @throw [NSException exceptionWithName:@"data" reason:@"数据不能为空!" userInfo:nil];
    }
    //
    return [[AckModel alloc] initWithType:type
                               withResult:[[ack objectForKey:MODEL_RESULT] integerValue]
                              withMessage:(NSString *)[ack objectForKey:MODEL_MSG]];
}

#pragma mark -- 构造函数。
-(instancetype)initWithType:(PushSocketMessageType)type withResult:(NSInteger)result withMessage:(NSString *)msg{
    if(self = [super init]){
        //反馈类型
        _type = type;
        //状态
        _result = (AckModelResult)result;
        //消息
        _msg = (msg ? msg : @"");
    }
    return self;
}

@end
