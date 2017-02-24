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

#import "ConnectRequestModel.h"

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

@end
