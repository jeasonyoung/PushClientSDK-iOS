//
//  RequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushRequestModel.h"

NSString * const PUSH_PARAMS_DEVICE_ID = @"deviceId";

//实现
@implementation PushRequestModel

#pragma mark -- 初始化对象。
-(instancetype)initWithMessageType:(PushSocketMessageType)type{
    if(self = [super init]){
        _messageType = type;
    }
    return self;
}

@end
