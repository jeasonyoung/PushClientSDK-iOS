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

#pragma mark -- 初始化
-(instancetype)initWithType:(PushSocketMessageType)type andAck:(NSDictionary *)ack{
    if((self = [super init]) && ack && ack.count){
        //1.反馈消息类型
        _type = type;
        //2.反馈状态
        _result = (AckModelResult)[ack[MODEL_RESULT] integerValue];
        //3.反馈消息
        _msg = ack[MODEL_MSG];
    }
    return self;
}

#pragma mark -- 静态初始化
+(instancetype)ackWithType:(PushSocketMessageType)type andAckJson:(NSString *)json{
    NSDictionary *dict = nil;
    if(json && json.length){
        NSError *err = nil;
        NSData *obj = [json dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:obj
                                               options:kNilOptions
                                                 error:&err];
        if(err) NSLog(@"ackWithType:andAckJson:-异常(\n%@\n)=>\n%@", json, err);
    }
    //
    return [[AckModel alloc] initWithType:type andAck:dict];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"type:%ld,result:%ld,msg:%@", self.type, self.result, self.msg];
}


@end
