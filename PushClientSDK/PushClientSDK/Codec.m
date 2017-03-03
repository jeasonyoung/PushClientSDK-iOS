//
//  Codec.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/22.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "Codec.h"

#pragma mark -- 消息头实现
@implementation FixedHeader

#pragma mark -- 初始化
-(instancetype)initWithType:(PushSocketMessageType)type
                  withIsAck:(BOOL)ack
        withRemainingLength:(NSUInteger)length{
    if(self = [super init]){
        _type = type;//1.消息类型
        _isDup = NO;
        _qos = ack ? SocketMessageQosAck : SocketMessageQosNone;
        _isRetain = NO;
        _remainingLength = length;
    }
    return self;
}

#pragma mark -- 初始化
-(instancetype)initWithType:(PushSocketMessageType)type withIsAck:(BOOL)ack{
    return [self initWithType:type withIsAck:ack withRemainingLength:0];
}

#pragma mark -- 静态初始化。
+(instancetype)headerWithType:(PushSocketMessageType)type withIsAck:(BOOL)ack{
    return [[FixedHeader alloc] initWithType:type withIsAck:ack];
}

#pragma mark -- 重载消息体长度设置
-(void)setRemainingLength:(NSUInteger)remainingLength{
    if(_remainingLength != remainingLength){
        _remainingLength = remainingLength;
    }
}

@end

#pragma mark -- 编码实现
@implementation Codec

#pragma mark -- 消息编码
-(NSData *)encodeWithHeader:(FixedHeader *)header andPayload:(NSString *)json{
    if(!header) return nil;
    NSLog(@"发送[%zd]请求消息=>\n%@", header.type, json);
    //消息体JSON转换
    NSData *body = nil;
    if(json && json.length){
        //json转换为byte
        body = [json dataUsingEncoding:NSUTF8StringEncoding];
        //设置消息体长度。
        header.remainingLength = body.length;
    }else{
        header.remainingLength = 0;
    }
    NSInteger size = [self calcHeaderSizeWithPayload:(header.remainingLength)];
    if(size == -1){
        NSLog(@"encodeWithHeader:andPayload:-消息长度超过规定的字节长度!=>\n%@",json);
        return nil;
    }
    //初始化消息数据对象
    NSMutableData *data = [NSMutableData dataWithCapacity:(size + 1)];
    //编码消息头
    [self writeHeadeWithData:&data withHeader:header];
    //编码消息体
    if(body && body.length){
        [data appendData:body];
    }
    //返回数据
    return data;
}

#pragma mark -- 计算消息长度所占字节长度
-(NSInteger)calcHeaderSizeWithPayload:(NSUInteger)length{
    NSInteger size = 1, len =  length >> 7;
    while(len > 0){
        len = len >> 7;
        size++;
    };
    if(size > 4) return -1;
    return size;
}

#pragma mark -- 写入消息头
-(void)writeHeadeWithData:(NSMutableData **)data withHeader:(FixedHeader *)header{
    //第一个字节
    unsigned short ret = 0;
    //高四位
    ret |= header.type << 4;
    //dup
    if(header.isDup) ret |= 0x08;
    //qos
    ret |= header.qos << 1;
    //retain
    if(header.isRetain) ret |= 0x01;
    ret &= 0xFF;
    //写入第一个字节
    [(*data) appendBytes:(&ret) length:1];
    //消息体长度处理
    NSUInteger num = header.remainingLength;
    if(num == 0){
        unsigned short zero = 0;
        [(*data) appendBytes:(&zero) length:1];
        return;
    }
    do{
        unsigned short digit = (num & 0x7f);
        num = num >> 7;
        if(num > 0){
            digit |= 0x80;
        }
        digit &= 0xFF;
        [(*data) appendBytes:(&digit) length:1];
    }while(num > 0);
}

#pragma mark -- 解码消息头
-(FixedHeader *)decodeHeaderWithData:(NSData *)data withOutIndex:(NSUInteger *)index{
    //读取第一字节。
    unsigned char b1 = 0;
    [data getBytes:&b1 range:NSMakeRange(*index, 1)];
    if(b1 == 0){
        NSLog(@"读取消息头数据不符合通讯协议!");
        return nil;
    }
    //消息类型
    PushSocketMessageType type = b1 >> 4;
    //qos
    SocketMessageQos qos = (b1 & 0x06) >> 1;
    if(qos < SocketMessageQosNone || qos > SocketMessageQosAck){
        NSLog(@"读取的头数据不符合通讯协议的定义!");
        return nil;
    }
    //读取消息体长度
    NSUInteger remainingLength = 0,multiplier = 1,loops = 0;
    short digit;
    do{
        //读取后续字节
        [data getBytes:&digit range:NSMakeRange((++(*index)), 1)];
        if(digit <= -1){
            NSLog(@"读取到无意义的长度字节数据(%d)!", digit);
            return nil;
        }
        //转换为十进制
        remainingLength += (digit & 0x7f) * multiplier;
        multiplier *= 128;
        //计数，最多4个字节表示长度
        loops++;
    }while(((digit & 0x80) != 0) && loops < 4);
    if(loops >= 4 && (digit & 0x80) != 0){
        NSLog(@"消息长度大于4个字节，不符合通讯协议!");
        return nil;
    }
    //生成消息头
    return [[FixedHeader alloc] initWithType:type withIsAck:(qos == SocketMessageQosAck) withRemainingLength:remainingLength];
}

@end
