//
//  ConnectRequestModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "ConnectRequestModel.h"

/**
 * @brief 设备类型(1-iOS,2-Android)
 **/
static NSUInteger const current_device_type_value = 1;

static NSString * const params_device_name = @"deviceName";//2.设备用户(tag)
static NSString * const params_device_type = @"deviceType";//3.设备类型
static NSString * const params_device_account = @"deviceAccount";//4.设备用户

//实现
@implementation ConnectRequestModel

#pragma mark -- 初始化
-(instancetype)init{
    if(self = [super initWithMessageType:PushSocketMessageTypeConnect]){
        _deviceType = current_device_type_value;
    }
    return self;
}

#pragma mark -- 重载签名数据
-(NSDictionary *)toSign{
    _params = @{ PARAMS_ACCOUNT : (self.account ? self.account : @""),
                 PARAMS_DEVICEID : (self.deviceId ? self.deviceId : @""),
                 params_device_name : (_deviceName ? _deviceName : @""),
                 params_device_type : [NSNumber numberWithUnsignedInteger:_deviceType],
                 params_device_account : (_deviceAccount ? _deviceAccount : @"")};
    return [super toSign];
}

@end
