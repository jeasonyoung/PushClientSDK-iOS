//
//  UnsubscribeRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushUnsubscribeRequestModel.h"

//实现
@implementation PushUnsubscribeRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypeUnsubscribe];
}

#pragma mark -- 签名
-(NSDictionary *)toSign{
    _params = @{PUSH_PARAMS_ACCOUNT : (self.account ? self.account : @""),
                PUSH_PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @"")};
    return [super toSign];
}

@end
