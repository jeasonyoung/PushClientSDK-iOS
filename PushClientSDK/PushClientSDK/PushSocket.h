//
//  PushSocket.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/19.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PushAccessData.h"
#import "PushSocketMessageType.h"
#import "PushCodecEncoder.h"

#import "PushPublishModel.h"

@class PushSocket;
/**
 * @brief 推送socket处理委托。
 **/
@protocol PushSocketHandlerDelegate <NSObject>

/**
 * @brief 加载Socket配置数据。
 * @param socket PushSocket实例。
 * @param config 配置数据。
 **/
-(void)pushSocket:(PushSocket *)socket withAccessConfig:(PushAccessData **)config;

/**
 * @brief socket异常处理。
 * @param socket pushSocket实例。
 * @param type 消息类型。
 * @param error 错误详情。
 **/
-(void)pushSocket:(PushSocket *)socket withMessageType:(PushSocketMessageType)type throwsError:(NSError *)error;

/**
 * @brief 推送消息。
 * @param socket pushSocket实例。
 * @param publish 推送消息。
 **/
-(void)pushSocket:(PushSocket *)socket withPublish:(PushPublishModel *)publish;

/**
 * @brief 启动重连。
 * @param socket pushSocket实例。
 * @param reconnect 是否启动重连。
 **/
-(void)pushSocket:(PushSocket *)socket withStartReconnect:(BOOL)reconnect;

@end

/**
 * @brief 推送socket处理。
 **/
@interface PushSocket : NSObject
/**
 * @brief 是否在运行中。
 **/
@property(assign,atomic,readonly)BOOL isRun;

/**
 * @brief 获取或设置是否已启动socket。
 **/
@property(assign,atomic,readonly)BOOL isStart;

/**
 * @brief 获取或设置上一次消息活动时间。
 **/
@property(assign,atomic,readonly)NSTimeInterval lastIdleTime;

/**
 * @brief 获取配置。
 **/
@property(retain,atomic,readonly, getter=getConfig)PushAccessData *config;

/**
 * @brief 获取消息编码器。
 **/
@property(retain,atomic,readonly, getter=getEncoder)PushCodecEncoder *encoder;

/**
 * @brief 获取推送消息ID缓存。
 **/
@property(retain,atomic,readonly, getter=getPushIdCache)NSMutableArray *pushIdCache;

/**
 * @brief 代理属性。
 **/
@property(assign,nonatomic)id<PushSocketHandlerDelegate> delegate;

/**
 * @brief 单例对象。
 **/
+(instancetype)shareSocket;

/**
 * @brief 启动连接socket服务器。
 **/
-(void)start;

/**
 * @brief 添加或更改用户标签处理。
 **/
-(void)addOrChangedTagHandler;

/**
 * @brief 清除用户标签处理。
 **/
-(void)clearTagHandler;

/**
 * @brief 关闭连接socket服务器
 **/
-(void)stop;

/**
 * @brief 向服务器发送请求数据。
 * @param data 请求数据。
 **/
-(void)sendRequestWithData:(NSData *)data;

/**
 * @brief 抛出异常错误消息处理。
 * @param type 抛出异常的消息类型。
 * @param message 异常错误消息内容。
 **/
-(void)throwsErrorWithMessageType:(PushSocketMessageType)type andMessage:(NSString *)message;

/**
 * @brief 抛出异常错误消息处理。
 * @param type 抛出异常的消息类型。
 * @param error 异常错误。
 **/
-(void)throwsErrorWithMessageType:(PushSocketMessageType)type andError:(NSError *)error;
@end
