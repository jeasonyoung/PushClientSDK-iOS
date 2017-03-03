//
//  PubAckRequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushRequestModel.h"

/**
 * @brief 推送消息收到反馈请求数据。
 **/
@interface PushPubAckRequestModel : PushRequestModel

/**
 * @brief 推送消息ID。
 **/
@property(copy,nonatomic)NSString *pushId;

@end
