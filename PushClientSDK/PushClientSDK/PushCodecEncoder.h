//
//  CodecEncoder.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushCodec.h"
#import "PushAccessData.h"

/**
 * @brief 编码结果处理block。
 **/
typedef void (^PushCodecEncoderBlock)(NSData *);

/**
 * @brief socket消息编码器。
 **/
@interface PushCodecEncoder : PushCodec

/**
 * @brief 连接请求编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderConnectWithConfig:(PushAccessData *)config
                        handler:(PushCodecEncoderBlock)block;

/**
 * @brief 推送消息到达请求编码处理。
 * @param config 配置数据。
 * @param pushId 推送ID。
 * @param block 编码处理block.
 **/
-(void)encoderPublishAckRequestWithConfig:(PushAccessData *)config
                                andPushId:(NSString *)pushId
                                  handler:(PushCodecEncoderBlock)block;

/**
 * @brief 用户登录请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderSubscribeWithConfig:(PushAccessData *)config
                          handler:(PushCodecEncoderBlock)block;

/**
 * @brief 用户注销请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderUnsubscribeWithConfig:(PushAccessData *)config
                            handler:(PushCodecEncoderBlock)block;

/**
 * @brief 心跳请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderPingRequestWithConfig:(PushAccessData *)config
                            handler:(PushCodecEncoderBlock)block;

/**
 * @brief 断开连接请求消息编码处理。
 * @param config 配置数据。
 * @param block 编码处理block。
 **/
-(void)encoderDisconnectWithConfig:(PushAccessData *)config
                           handler:(PushCodecEncoderBlock)block;

@end
