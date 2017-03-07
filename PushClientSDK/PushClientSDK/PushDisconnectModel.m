//
//  DisconnectModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/27.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushDisconnectModel.h"

//实现
@implementation PushDisconnectModel

#pragma mark -- 初始化。
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypeDisconnect];
}

#pragma mark -- 参数签名
-(NSDictionary *)toSign{
    _params = @{PUSH_PARAMS_ACCOUNT : (self.account ? self.account : @""),
                PUSH_PARAMS_DEVICE_ID : (self.deviceId ? self.deviceId : @"")};
    
    return [super toSign];
}

@end
