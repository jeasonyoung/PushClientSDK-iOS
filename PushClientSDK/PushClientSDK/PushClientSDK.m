//
//  PushClientSDK.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/8.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushClientSDK.h"

#import "AFNetworking.h"


#import "AccessData.h"
#import "RequestData.h"

#define DISPATCH_QUEUE_NAME "com.csblank.push"

static NSString * const PUSH_SRV_URL_PREFIX = @"http";
static NSString * const PUSH_SRV_URL_SUFFIX = @"/push-http-connect/v1/callback/connect.do";

//构造函数
@interface PushClientSDK (){
    dispatch_queue_t _queue;//dispatch队列
    AccessData *_accessData;
}
//推送服务是否运行中
@property(assign,atomic)BOOL isRuning;
@end

//实现
@implementation PushClientSDK

#pragma mark -- 单例
+(instancetype)sharedInstance{
    static PushClientSDK *instance = nil;
    //
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[PushClientSDK alloc] init];
    });
    return instance;
}

//初始化函数
-(instancetype)init{
    if(self = [super init]){
        _queue = dispatch_queue_create(DISPATCH_QUEUE_NAME, NULL);
        self.isRuning = NO;//运行状态
        _accessData = [AccessData sharedAccess];//初始化访问数据
    }
    return self;
}

#pragma mark -- 启动推送
-(void)startHost:(NSString *)host
      andAccount:(NSString *)account
     andPassword:(NSString *)pwd
 withDeviceToken:(NSData *)token{
    //检查host
    if(!host || !host.length){
        @throw [NSException exceptionWithName:@"host" reason:@"服务器(host)不能为空!" userInfo:nil];
    }
    //
    NSMutableString *url = [NSMutableString string];
    //检查前部
    if(![host hasPrefix:PUSH_SRV_URL_PREFIX]){
        [url appendFormat:@"%@://", PUSH_SRV_URL_PREFIX];
    }
    //检查尾部
    NSRange range = [host rangeOfString:PUSH_SRV_URL_SUFFIX];
    if(range.location != NSNotFound){
        @throw [NSException exceptionWithName:@"host" reason:@"服务器(host)不需要包含子路径!" userInfo:nil];
    }
    if([host hasSuffix:@"/"]){
        [url appendString:[host substringToIndex:(host.length - 1)]];
    }else{
        [url appendString:host];
    }
    [url appendString:PUSH_SRV_URL_SUFFIX];
    NSLog(@"url:%@", url);
    //检查接入帐号
    if(!account || !account.length) @throw [NSException exceptionWithName:@"account" reason:@"接入帐号(account)不能为空!" userInfo:nil];
    //检查接入密码
    if(!pwd || !pwd.length) @throw [NSException exceptionWithName:@"pwd" reason:@"接入密钥(password)不能为空!" userInfo:nil];
    //检查设备令牌
    if(!token || !token.length) @throw [NSException exceptionWithName:@"token" reason:@"设备令牌(token)不能为空!" userInfo:nil];
    //初始化数据
    [_accessData initialWithURL:url andAccount:account andPassword:pwd andDeviceToken:token];
    //访问HTTP服务器
    [self accessHttpServer];
}

#pragma mark -- 访问HTTP服务器获取配置
-(void)accessHttpServer{
    //构建参数集合
    NSDictionary *params = [[[RequestData alloc] initWithAccess:_accessData] toSignParameters];
    //网络请求处理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:_accessData.url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取推送socket服务器数据成功:%@", responseObject);
        NSInteger result  = [responseObject[@"result"] integerValue];
        if(result == 0){//获取Socket服务器配置成功
            NSDictionary *dict = responseObject[@"setting"];
            NSLog(@"socket-settings=>%@", dict);
            [_accessData addOrUpdateConfigWithSocket:dict];
            [self startSocketClient];
        }else{
            NSString *message = responseObject[@"message"];
            [self sendErrorWithType:PushClientSDKErrorTypeSrvConf message:[NSString stringWithFormat:@"%ld-%@", result, message]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"网络异常=>%@", error);
        [self sendErrorWithType:PushClientSDKErrorTypeConnect message:error.localizedDescription];
    }];
}

#pragma mark -- 添加或更改用户标签
-(void)addOrChangedTag:(NSString *)tag{
    NSLog(@"addOrChangedTag=>%@", tag);
    if(!tag || !tag.length) return;
    [_accessData addOrUpdateDeviceUserWithTag:tag];
}

#pragma mark -- 清除用户标签
-(void)clearTag{
    NSLog(@"clear...");
    [_accessData addOrUpdateDeviceUserWithTag:nil];
}

#pragma mark -- 关闭推送客户端
-(void)close{
    NSLog(@"close...");
    
}

#pragma mark -- 启动socket客户端
-(void)startSocketClient{
    ///TODO:启动
}

#pragma mark -- 关闭socket客户端
-(void)stopSocketClient{
    ///TODO:关闭
}

#pragma mark -- 发送错误消息处理
-(void)sendErrorWithType:(PushClientSDKErrorType)type message:(NSString *)msg{
    NSLog(@"发生错误异常(%ld):%@", type, msg);
    if(self.delegate && [self.delegate respondsToSelector:@selector(pushClientSDK:withErrorType:andMessageDesc:)]){
        [self.delegate pushClientSDK:self withErrorType:type andMessageDesc:msg];
    }
}


@end
