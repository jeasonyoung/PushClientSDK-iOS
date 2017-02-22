//
//  PubAckRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PubAckRequestModel.h"

static NSString * const PARAMS_PUSHID = @"pushId";

//实现
@implementation PubAckRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypePuback];
}

#pragma mark -- 签名
-(NSDictionary *)toSign{
    _params = @{ PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @""),
                 PARAMS_PUSHID : (_pushId ? _pushId : @"")};
    return [super toSign];
}

@end
