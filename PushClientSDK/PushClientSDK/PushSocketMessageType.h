//
//  PushSocketMessageType.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#ifndef PushSocketMessageType_h
#define PushSocketMessageType_h

#import <Foundation/Foundation.h>

/**
 * @brief 推送Socket消息类型。
 **/
typedef NS_ENUM(NSInteger,PushSocketMessageType){
    /**
     * @brief 未知消息类型。
     **/
    PushSocketMessageTypeNone = 0,
    /**
     * @brief 连接请求。
     **/
    PushSocketMessageTypeConnect = 1,
    /**
     * @brief 连接请求应答。
     **/
    PushSocketMessageTypeConnack = 2,
    /**
     * @brief 推送消息下行。
     **/
    PushSocketMessageTypePublish = 3,
    /**
     * @brief 推送消息到达请求。
     **/
    PushSocketMessageTypePuback  = 4,
    /**
     * @brief 推送消息到达请求应答。
     **/
    PushSocketMessageTypePubrel  = 6,
    /**
     * @brief 用户登录请求。
     **/
    PushSocketMessageTypeSubscribe = 8,
    /**
     * @brief 用户登录请求应答。
     **/
    PushSocketMessageTypeSuback    = 9,
    /**
     * @brief 用户注销请求。
     **/
    PushSocketMessageTypeUnsubscribe = 10,
    /**
     * @brief 用户注销请求应答。
     **/
    PushSocketMessageTypeUnsuback    = 11,
    /**
     * @brief 心跳请求。
     **/
    PushSocketMessageTypePingreq     = 12,
    /**
     * @brief 心跳应答。
     **/
    PushSocketMessageTypePingresp    = 13,
    /**
     * @brief 断开请求。
     **/
    PushSocketMessageTypeDisconnect  = 14
};


#endif /* PushSocketMessageType_h */
