//
//  PubAckRequestModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

/**
 * @brief 推送消息收到反馈请求数据。
 **/
@interface PubAckRequestModel : RequestModel

/**
 * @brief 推送消息ID。
 **/
@property(copy,nonatomic)NSString *pushId;

@end
