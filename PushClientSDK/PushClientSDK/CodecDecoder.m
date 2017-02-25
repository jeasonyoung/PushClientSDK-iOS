//
//  CodecDecoder.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/24.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "CodecDecoder.h"
#import "AckModel.h"
#import "PublishModel.h"
#import "PingResponseModel.h"

//成员变量。
@interface CodecDecoder (){
    FixedHeader *_header;
    NSMutableData *_buffer;
}
@end

/**
 * @brief 消息头最小数据长度。
 **/
static NSUInteger const HEAD_DATA_MIN_LEN = 5;

//解码器实现。
@implementation CodecDecoder

#pragma mark -- 初始化。
-(instancetype)init{
    if(self = [super init]){
        _header = nil;
        _buffer = [NSMutableData data];
    }
    return self;
}

#pragma mark -- 添加解码源数据。
-(void)decoderWithAppendData:(NSData *)source{
    if(!source || !source.length) return;
    if(!_header){//消息头处理
        if(source.length < HEAD_DATA_MIN_LEN){
            NSLog(@"decoderWithAppendData-数据最小长度应大于%ld!", HEAD_DATA_MIN_LEN);
            return;
        }
        NSUInteger index = 0;
        _header = [self decoderHeaderWithData:source withOutIndex:&index];
        if(!_header){
            NSLog(@"解析消息头失败!");
            return;
        }
        //剩余的消息长度
        NSUInteger available = source.length - index;
        if(available > 0){
            NSData *data = [source subdataWithRange:NSMakeRange(index + 1, available)];
            if(_header.remainingLength > 0){//有消息体，递归处理
                [self decoderWithAppendData:data];
                return;
            }
            //无消息体
            [self decoderMessageWithHeader:_header andPayload:nil];
            _header = nil;
            [self decoderWithAppendData:data];
            return;
        }
        //无剩余长度,无消息体
        if(_header.remainingLength == 0){
            [self decoderMessageWithHeader:_header andPayload:nil];
            _header = nil;
        }
    }else{//消息体处理
        //缓存如果不存在,则初始化
        if(!_buffer) _buffer = [NSMutableData data];
        [_buffer appendData:source];
        //检查缓存数据是否满足消息体长度
        if(_buffer.length >= _header.remainingLength){
            //消息体长度
            NSUInteger payloadLength = _header.remainingLength;
            //截取消息体长度数据
            NSData *payload = [_buffer subdataWithRange:NSMakeRange(0, payloadLength)];
            //解析消息体
            [self decoderMessageWithHeader:_header andPayload:payload];
            _header = nil;
            //剩余数据
            NSInteger len = 0;
            if((len = _buffer.length - payloadLength) > 0){
                //截取剩余长度
                NSData *buf = [_buffer subdataWithRange:NSMakeRange(payloadLength, len)];
                _buffer = nil;//清空缓存
                [self decoderWithAppendData:buf];
            }else{//清空缓存
                _buffer = nil;
            }
        }
    }
}

#pragma mark -- 解析消息体
-(void)decoderMessageWithHeader:(FixedHeader *)header andPayload:(NSData *)payload{
    if(!header){
        NSLog(@"消息头为空，无法解析消息体!");
        return;
    }
    NSString *json = nil;
    if(payload && payload.length){
        //转换为JSON字符串。
        json = [[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding];
        NSLog(@"decoder=>\n%@", json);
    }
    //解析消息体
    switch (header.type) {
        case PushSocketMessageTypeNone://未知消息
            NSLog(@"decoderMessageWithHeader:andPayload-未知消息类型=>%ld", header.type);
            break;
        case PushSocketMessageTypeConnack://连接请求应答
        case PushSocketMessageTypePubrel://推送消息达到请求应答
        case PushSocketMessageTypeSuback://用户登录请求应答
        case PushSocketMessageTypeUnsuback://用户注销请求应答
        {
            AckModel *model = [AckModel ackWithType:header.type andAckJson:json];
            [self sendReviceMessageWithType:model.type andReviceMessageModel:model];
            break;
        }
        case PushSocketMessageTypePublish:{//推送消息下行
            PublishModel *model = [PublishModel publishWithJSON:json];
            [self sendReviceMessageWithType:PushSocketMessageTypePublish andReviceMessageModel:model];
            break;
        }
        case PushSocketMessageTypePingresp:{//心跳请求应答
            PingResponseModel *model = [PingResponseModel pingResponseWithJSON:json];
            [self sendReviceMessageWithType:PushSocketMessageTypePingresp andReviceMessageModel:model];
            break;
        }
        default:{
            NSLog(@"decoderMessageWithHeader:andPayload-消息类型不在处理范围内(%ld)!", header.type);
            break;
        }
    }
}

#pragma mark -- 发送接收到的消息到委托
-(void)sendReviceMessageWithType:(PushSocketMessageType)type andReviceMessageModel:(id)model{
    if(!model || !self.delegate)return;
    if([self.delegate respondsToSelector:@selector(decoderWithType:andAckModel:)]){
        [self.delegate decoderWithType:type andAckModel:model];
    }
}

@end
