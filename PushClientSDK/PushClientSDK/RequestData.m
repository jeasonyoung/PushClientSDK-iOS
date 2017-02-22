//
//  RequestData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "RequestData.h"

//实现
@implementation RequestData

#pragma mark -- 构造函数
-(instancetype)initWithAccess:(const AccessData *)access{
    if(self = [super init]){
        //接入帐号
        self.account = access.account;
        //接入密钥
        self.token = access.password;
        //参数设置
        _params = @{ PARAMS_ACCOUNT : access.account };
    }
    return self;
}

#pragma mark -- 参数签名
-(NSDictionary *)toSignParameters{
    return [self toSign];
}

@end
