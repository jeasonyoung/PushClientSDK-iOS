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
 * @brief 重启连接处理。
 **/
-(void)restartConnectHandler;

/**
 * @brief 开启心跳处理。
 **/
-(void)startPingHandler;


@end
