//
//  CodecDecoder.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/24.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "CodecDecoder.h"

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
    if(!_header){//消息头不存在，新数据
        if(source.length < HEAD_DATA_MIN_LEN){
            NSLog(@"decoderWithAppendData-数据最小长度应大于%ld!", HEAD_DATA_MIN_LEN);
            return;
        }
        //[source getBytes:<#(nonnull void *)#> length:<#(NSUInteger)#>]
        
        
    }else{//
        
    }
    
    
}

@end
