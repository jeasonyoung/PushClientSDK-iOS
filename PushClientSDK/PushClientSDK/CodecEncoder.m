//
//  CodecEncoder.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "CodecEncoder.h"
#import "ConnectRequestModel.h"
#import "PubAckRequestModel.h"
#import "SubscribeRequestModel.h"
#import "UnsubscribeRequestModel.h"
#import "PingRequestModel.h"
#import "DisconnectModel.h"

//实现
@implementation CodecEncoder

#pragma mark -- 连接请求编码处理。
-(void)encoderConnectWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[connect]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    //创建消息数据
    ConnectRequestModel *model = [[ConnectRequestModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    model.deviceAccount = config.tag;//1.设备用户帐号
    model.deviceName = config.deviceName;//2.设备名称
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 推送消息到达请求数据编码处理
-(void)encoderPublishAckRequestWithConfig:(AccessData *)config andPushId:(NSString *)pushId handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[publish-request]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    if(!pushId || !pushId.length){
        NSLog(@"推送ID不存在!");
        return;
    }
    //创建消息达到请求数据
    PubAckRequestModel *model = [[PubAckRequestModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    model.pushId = pushId;//1.推送ID
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 用户登录请求消息编码处理。
-(void)encoderSubscribeWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[Subscribe-request]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    if(!config.tag || !config.tag.length){
        NSLog(@"获取设备标签(tag)不存在!");
        return;
    }
    //创建用户登录请求消息数据
    SubscribeRequestModel *model = [[SubscribeRequestModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    model.deviceAccount = config.tag;//1.设备帐号用户。
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 用户注销请求消息编码处理。
-(void)encoderUnsubscribeWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[Unsubscribe-request]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    //创建用户注销请求消息数据
    UnsubscribeRequestModel *model = [[UnsubscribeRequestModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 心跳请求数据消息编码处理
-(void)encoderPingRequestWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[Ping-request]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    //创建心跳请求消息数据
    PingRequestModel *model = [[PingRequestModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 断开连接请求消息编码处理。
-(void)encoderDisconnectWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[Disconnect-request]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    //创建断开连接请求消息数据
    DisconnectModel *model = [[DisconnectModel alloc] init];
    [self buildCommonParamsWithConfig:config withModel:model];
    //消息编码
    [self encoderWithReqModel:model withIsAck:NO handler:block];
}

#pragma mark -- 内置函数

#pragma mark -- 构建请求数据通用参数
-(void)buildCommonParamsWithConfig:(AccessData *)config  withModel:(RequestModel *)model{
    if(!model || !config) return;
    model.account = config.account;//1.接入帐号
    model.token = config.password;//2.接入密钥
    model.deviceId = config.deviceToken;//3.设备ID
}

#pragma mark -- 请求数据模型编码处理
-(void)encoderWithReqModel:(RequestModel *)model withIsAck:(BOOL)ack handler:(CodecEncoderBlock)block{
    if(!model || !block) return;
    FixedHeader *header = [FixedHeader headerWithType:model.messageType withIsAck:ack];
    NSData *data = [self encodeWithHeader:header andPayload:[model toSignJson]];
    if(data && data.length){
        block(data);
    }
}

@end
