//
//  CodecEncoder.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Codec.h"
#import "AccessData.h"

/**
 * @brief 编码结果处理block。
 **/
typedef void (^CodecEncoderBlock)(NSData *);

/**
 * @brief socket消息编码器。
 **/
@interface CodecEncoder : Codec

/**
 * @brief 连接请求编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderConnectWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block;

/**
 * @brief 推送消息到达请求编码处理。
 * @param config 配置数据。
 * @param pushId 推送ID。
 * @param block 编码处理block.
 **/
-(void)encoderPublishAckRequestWithConfig:(AccessData *)config andPushId:(NSString *)pushId handler:(CodecEncoderBlock)block;

/**
 * @brief 用户登录请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderSubscribeWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block;

/**
 * @brief 用户注销请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderUnsubscribeWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block;

/**
 * @brief 心跳请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderPingRequestWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block;

/**
 * @brief 断开连接请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderDisconnectWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block;

@end
