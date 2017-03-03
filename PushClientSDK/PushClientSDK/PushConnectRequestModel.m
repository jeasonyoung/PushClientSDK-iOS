//
//  ConnectRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushConnectRequestModel.h"

/**
 * @brief 设备类型(1-iOS,2-Android)
 **/
static NSUInteger const PUSH_CURRENT_DEVICE_TYPE_VALUE = 1;

static NSString * const PUSH_PARAMS_DEVICE_NAME = @"deviceName";//2.设备用户(tag)
static NSString * const PUSH_PARAMS_DEVICE_TYPE = @"deviceType";//3.设备类型
static NSString * const PUSH_PARAMS_DEVICE_ACCOUNT = @"deviceAccount";//4.设备用户

//实现
@implementation PushConnectRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    if(self = [super initWithMessageType:PushSocketMessageTypeConnect]){
        _deviceType = PUSH_CURRENT_DEVICE_TYPE_VALUE;
    }
    return self;
}

#pragma mark -- 重载签名数据
-(NSDictionary *)toSign{
    _params = @{ PUSH_PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PUSH_PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @""),
                 PUSH_PARAMS_DEVICE_NAME : (_deviceName ? _deviceName : @""),
                 PUSH_PARAMS_DEVICE_TYPE : [NSNumber numberWithUnsignedInteger:_deviceType],
                 PUSH_PARAMS_DEVICE_ACCOUNT : (_deviceAccount ? _deviceAccount : @"")};
    return [super toSign];
}

@end
