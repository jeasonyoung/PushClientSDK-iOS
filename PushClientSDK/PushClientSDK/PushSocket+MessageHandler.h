//
//  PushSocket+MessageHandler.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/26.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocket.h"

#import "PushAckModel.h"
#import "PushPingResponseModel.h"
/**
 * 消息处理扩展
 **/
@interface PushSocket (MessageHandler)

/**
 * @brief 接收反馈数据处理。
 * @param ack 反馈数据模型对象。
 **/
-(void)receiveAckHandler:(PushAckModel *)ack;

/**
 * @brief 接收心跳应答数据处理。
 * @param pingAck 心跳应答数据。
 **/
-(void)receivePingAckHandler:(PushPingResponseModel *)pingAck;

/**
 * @brief 接收推送消息数据处理。
 * @param data 推送消息数据模型对象。
 **/
-(void)receivePublishHandler:(PushPublishModel *)data;

@end
