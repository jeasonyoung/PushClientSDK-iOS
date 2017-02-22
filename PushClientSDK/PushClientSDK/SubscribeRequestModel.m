//
//  SubscribeRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "SubscribeRequestModel.h"

static NSString * const PARAMS_DEVICEACCOUNT = @"deviceAccount";

//实现
@implementation SubscribeRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypeSubscribe];
}

#pragma mark -- 签名。
-(NSDictionary *)toSign{
    _params = @{ PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @""),
                 PARAMS_DEVICEACCOUNT : (_deviceAccount ? _deviceAccount : @"")
                };
    return [super toSign];
}

@end
