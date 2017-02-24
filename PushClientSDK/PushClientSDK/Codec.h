//
//  Codec.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushSocketMessageType.h"

/**
 * @brief socket消息Qos枚举。
 **/
typedef NS_ENUM(NSInteger,SocketMessageQos){
    /**
     * @brief 无应答。
     **/
    SocketMessageQosNone = 0,
    /**
     * @brief 不处置。
     **/
    SocketMessageQosNot = 1,
    /**
     * @brief 必须应答。
     **/
    SocketMessageQosAck = 2
};

/**
 * @brief 固定消息头部。
 **/
@interface FixedHeader : NSObject
/**
 * @brief 消息类型。
 **/
@property(assign, nonatomic, readonly)PushSocketMessageType type;
/**
 * @brief 重复标示。
 **/
@property(assign, nonatomic, readonly)BOOL isDup;
/**
 * @brief 保持标示。
 **/
@property(assign, nonatomic, readonly)BOOL isRetain;
/**
 * @brief 传输质量类型。
 **/
@property(assign, nonatomic, readonly)SocketMessageQos qos;
/**
 * @brief 有效消息体长度。
 **/
@property(assign, nonatomic, readwrite)NSUInteger remainingLength;

/**
 * @brief 初始化实例。
 * @param type 消息类型。
 * @param ack 是否必须应答。
 * @param length 消息体长度。
 * @return 实例对象。
 **/
-(instancetype)initWithType:(PushSocketMessageType)type withIsAck:(BOOL)ack withRemainingLength:(NSUInteger)length;

/**
 * @brief 初始化实例。
 * @param type 消息类型。
 * @param ack 是否必须应答。
 * @return 实例对象。
 **/
-(instancetype)initWithType:(PushSocketMessageType)type withIsAck:(BOOL)ack;

/**
 * @brief 静态初始化。
 * @param type 消息类型。
 * @param ack 是否必须应答。
 * @return 实例对象。
 **/
+(instancetype)headerWithType:(PushSocketMessageType)type withIsAck:(BOOL)ack;

@end


/**
 * @brief socket编码/解码器。
 **/
@interface Codec : NSObject

/**
 * @brief 消息编码。
 * @param header 消息头。
 * @param json JSON消息体。
 * @return 编码后的消息。
 **/
-(NSData *)encodeWithHeader:(FixedHeader *)header andPayload:(NSString *)json;

/**
 * @brief 解码消息头。
 * @param data 需解码数据。
 * @param index 输出的数据索引。
 * @return 消息头对象。
 **/
-(FixedHeader *)decoderHeaderWithData:(NSData *)data withOutIndex:(NSUInteger *)index;

@end
