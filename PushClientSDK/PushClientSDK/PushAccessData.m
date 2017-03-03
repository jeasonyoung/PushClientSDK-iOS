//
//  AccessData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushAccessData.h"
#import <UIKit/UIKit.h>

#import "NSString+PushExtTools.h"

//实现
@implementation PushAccessData

#pragma mark -- 静态单例
+(instancetype)sharedAccess{
    static PushAccessData * _instance = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PushAccessData alloc] init];
    });
    return _instance;
}

#pragma mark -- 初始化
-(instancetype)init{
    if(self = [super init]){
        UIDevice *device = [UIDevice currentDevice];
        _deviceName = [NSString stringWithFormat:@"%@-%@(%@)", device.systemName, device.systemVersion, device.name];
    }
    return self;
}

#pragma mark -- 初始化数据
-(void)initialWithURL:(NSString *)url andAccount:(NSString *)account andPassword:(NSString *)pwd andDeviceToken:(NSData *)token{
    //1.服务器地址URL
    _url = url ? [url trim] : @"";
    //2.接入帐号
    _account = account ? [account trim] : @"";
    //3.接入密码
    _password = pwd ? [pwd trim] : @"";
    //4.设备令牌
    if(token && token.length){
        _deviceToken = [[NSString alloc] initWithData:token encoding:NSUTF8StringEncoding];
    }else{
        _deviceToken = nil;
    }
}

#pragma mark -- 新增或更新设备用户标签
-(BOOL)addOrUpdateDeviceUserWithTag:(NSString *)tag{
    if(!tag || !tag.length){
        _tag = @"";
    }else{
        _tag = [tag trim];
    }
    return YES;
}

#pragma mark -- 新增或更新Socket配置
-(BOOL)addOrUpdateConfigWithSocket:(NSDictionary *)config{
    if(!config || !config.count) return NO;
    //初始化socket配置数据对象
    if(!_socket){
        _socket = [[PushSocketConfigData alloc] init];
    }
    //
    [_socket initialConfigWithDict:config];
    return YES;
}

@end
