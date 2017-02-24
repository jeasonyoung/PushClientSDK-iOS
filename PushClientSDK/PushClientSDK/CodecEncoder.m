//
//  CodecEncoder.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "CodecEncoder.h"

//实现
@implementation CodecEncoder

#pragma mark -- 连接请求编码处理。
-(void)encoderConnectWithConfig:(AccessData *)config handler:(CodecEncoderBlock)block{
    NSLog(@"开始客户端发起[connect]请求处理...");
    if(!config){
        NSLog(@"获取配置数据失败!");
        return;
    }
    //创建消息数据
    ConnectRequestModel *model = [[ConnectRequestModel alloc] init];
    model.account = config.account;//1.接入帐号
    model.token = config.password;//2.接入密钥。
    model.deviceId = config.deviceToken;//3.设备ID
    model.deviceAccount = config.tag;//4.设备用户帐号
    model.deviceName = config.deviceName;//5.设备名称
    //消息编码
    [self encoderWithReqModel:model withIsAck:YES handler:block];
}

#pragma mark -- 请求数据模型编码处理
-(void)encoderWithReqModel:(RequestModel *)model withIsAck:(BOOL)ack handler:(CodecEncoderBlock)block{
    if(!model || !block) return;
    FixedHeader *header = [FixedHeader headerWithType:model.messageType withIsAck:ack];
    NSData *data = [self encodeWithHeader:header andPayload:[model toSignJson]];
    if(data && data.length){
        block(data);
    }
}

@end
