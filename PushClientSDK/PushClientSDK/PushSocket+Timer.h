//
//  PushSocket+Timer.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/27.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushSocket.h"

/**
 * 定时任务处理。
 **/
@interface PushSocket (Timer)

/**
 * @brief 自动重连处理。
 **/
-(void)reconnectHandler;

/**
 * @brief 重启连接处理(按协议延时重连)。
 **/
-(void)restartHandler;

/**
 * @brief 开启心跳处理。
 **/
-(void)startPingHandler;

@end
