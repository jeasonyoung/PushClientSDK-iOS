//
//  PingResponseModel.h
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 心跳反馈数据。
 **/
@interface PushPingResponseModel : NSObject

/**
 * @brief 心跳间隔改变。
 **/
@property(assign,nonatomic,readonly)NSInteger heartRate;

/**
 * @brief 断开重连间隔。
 **/
@property(assign,nonatomic,readonly)NSInteger afterConnect;

/**
 * @brief 初始化。
 * @param data 数据集。
 * @return 对象实例。
 **/
-(instancetype)initWithData:(NSDictionary *)data;

/**
 * @brief 静态构建。
 * @param json 反馈JSON字符串。
 * @return 实例对象。
 **/
+(instancetype)pingResponseWithJSON:(NSString *)json;

@end
