//
//  RequestData.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/9.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushRequestData.h"

//实现
@implementation PushRequestData

#pragma mark -- 构造函数
-(instancetype)initWithAccess:(const PushAccessData *)access{
    if(self = [super init]){
        //接入帐号
        self.account = access.account;
        //接入密钥
        self.token = access.password;
        //参数设置
        _params = @{ PUSH_PARAMS_ACCOUNT : access.account };
    }
    return self;
}

#pragma mark -- 参数签名
-(NSDictionary *)toSignParameters{
    return [self toSign];
}

@end
