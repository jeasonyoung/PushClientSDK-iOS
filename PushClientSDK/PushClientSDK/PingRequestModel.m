//
//  PingRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PingRequestModel.h"

//实现
@implementation PingRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    return [super initWithMessageType:PushSocketMessageTypePingreq];
}

#pragma mark -- 参数签名
-(NSDictionary *)toSign{
    _params = @{PARAMS_ACCOUNT : (self.account ? self.account : @""),
                PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @"")};
    
    return [super toSign];
}

@end
