//
//  PushClientSDK.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/8.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PushPublishModel.h"
/**
 * @brief 错误类型枚举。
 **/
typedef NS_ENUM(NSInteger, PushClientSDKErrorType){
    /**
     * @brief 获取服务器配置失败。
     **/
    PushClientSDKErrorTypeSrvConf = 0,
    /**
     * @brief 连接服务器失败。
     **/
    PushClientSDKErrorTypeConnect,
    /**
     * @brief 参数签名失败。
     **/
    PushClientSDKErrorTypeParamSign
};

@class PushClientSDK;
/**
 * @brief 推送客户端SDK委托协议。
 **/
@protocol PushClientSDKDelegate <NSObject>

@optional
/**
 * @brief 错误处理。
 * @param sdk SDK实例对象。
 * @param type 异常类型。
 * @param desc 异常消息描述。
 **/
-(void)pushClientSDK:(PushClientSDK *)sdk
       withErrorType:(PushClientSDKErrorType)type
      andMessageDesc:(NSString *)desc;

/**
 * @brief 接收推送消息。
 * @param sdk SDK实例对象。
 * @param isApns 是否为APNs消息。
 * @param title 接收推送消息标题。
 * @param content 推送消息内容。
 * @param data 完整的推送消息。
 **/
-(void)pushClientSDK:(PushClientSDK *)sdk
          withIsApns:(BOOL)isApns
receivePushMessageTitle:(NSString *)title
   andMessageContent:(NSString *)content
     withFullPublish:(PushPublishModel *)data;

@end

/**
 * @brief 推送客户端SDK。
 **/
@interface PushClientSDK : NSObject

/**
 * @brief 委托代理。
 **/
@property(assign,nonatomic)id<PushClientSDKDelegate> delegate;

/**
 * @brief 单例对象。
 **/
+(instancetype)sharedInstance;

/**
 * @brief 启动推送客户端。
 * @param host 服务器地址。
 * @param account 接入帐号。
 * @param pwd 接入密钥。
 * @param token 设备令牌。
 **/
-(void)startHost:(NSString *)host
      andAccount:(NSString *)account
     andPassword:(NSString *)pwd
 withDeviceToken:(NSData *)token;

/**
 * @brief 添加或更改用户标签。
 * @param tag 用户标签(与服务端须一致)。
 **/
-(void)addOrChangedTag:(NSString *)tag;

/**
 * @brief 清除用户标签。
 **/
-(void)clearTag;

/**
 * @brief 关闭推送客户端。
 **/
-(void)close;

/**
 * @brief 接收APNs远程推送消息。
 * @param userInfo 接收到的数据。
 **/
-(void)receiveRemoteNotification:(NSDictionary *)userInfo;

@end
