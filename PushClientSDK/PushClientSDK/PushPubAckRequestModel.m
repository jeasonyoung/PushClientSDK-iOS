//
//  PubAckRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushPubAckRequestModel.h"

static NSString * const PUSH_PARAMS_PUSHID = @"pushId";

//实现
@implementation PushPubAckRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypePuback];
}

#pragma mark -- 签名
-(NSDictionary *)toSign{
    _params = @{ PUSH_PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PUSH_PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @""),
                 PUSH_PARAMS_PUSHID : (_pushId ? _pushId : @"")};
    return [super toSign];
}

@end
