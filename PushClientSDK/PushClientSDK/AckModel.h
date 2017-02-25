//
//  AckModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/20.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushSocketMessageType.h"

/**
 * @brief 应答数据模型状态枚举。
 **/
typedef NS_ENUM(NSInteger, AckModelResult){
    /**
     * @brief 成功。
     **/
    AckModelResultSuccess = 0,
    /**
     * @brief 接入帐号不存在。
     **/
    AckModelResultAccountError = -1,
    /**
     * @brief 校验码错误。
     **/
    AckModelResultSignError = -2,
    /**
     * @brief 参数错误。
     **/
    AckModelResultParamError = -3
};

/**
 * @brief 应答数据模型。
 **/
@interface AckModel : NSObject

/**
 * @brief 获取反馈消息类型。
 **/
@property(assign, nonatomic, readonly)PushSocketMessageType type;

/**
 * @brief 获取状态枚举。
 **/
@property(assign, nonatomic, readonly)AckModelResult result;

/**
 * @brief 获取消息内容。
 **/
@property(copy, nonatomic, readonly)NSString *msg;

/**
 * @brief 初始化对象。
 * @param type 反馈消息类型。
 * @param ack 反馈的数据集合。
 * @return 反馈对象实例。
 **/
-(instancetype)initWithType:(PushSocketMessageType)type andAck:(NSDictionary *)ack;

/**
 * @brief 静态初始化对象。
 * @param type 反馈消息类型。
 * @param json 反馈的JSON数据。
 * @return 反馈对象实例。
 **/
+(instancetype)ackWithType:(PushSocketMessageType)type andAckJson:(NSString *)json;

@end
