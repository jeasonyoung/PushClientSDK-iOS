//
//  RequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "RequestModel.h"

NSString * const PARAMS_DEVICEID = @"deviceId";

//实现
@implementation RequestModel

#pragma mark -- 初始化对象。
-(instancetype)initWithMessageType:(PushSocketMessageType)type{
    if(self = [super init]){
        _messageType = type;
    }
    return self;
}

@end
