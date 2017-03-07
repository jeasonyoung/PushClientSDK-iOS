//
//  SubscribeRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSubscribeRequestModel.h"

static NSString * const PUSH_PARAMS_DEVICE_ACCOUNT = @"deviceAccount";

//实现
@implementation PushSubscribeRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypeSubscribe];
}

#pragma mark -- 签名。
-(NSDictionary *)toSign{
    _params = @{ PUSH_PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PUSH_PARAMS_DEVICE_ID : (self.deviceId ? self.deviceId : @""),
                 PUSH_PARAMS_DEVICE_ACCOUNT : (_deviceAccount ? _deviceAccount : @"")
                };
    return [super toSign];
}

@end
