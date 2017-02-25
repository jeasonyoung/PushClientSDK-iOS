//
//  PublishModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PublishModel.h"

#pragma mark -- 推送弹出消息数据
static NSString * const PUBLISH_ALERT_BODY = @"body";
static NSString * const PUBLISH_ALERT_ACTION_LOC_KEY = @"action-loc-key";
static NSString * const PUBLISH_ALERT_LOC_KEY = @"loc-key";
static NSString * const PUBLISH_ALERT_LAUNCH_IMAGE = @"launch-image";
static NSString * const PUBLISH_ALERT_LOC_ARGS = @"loc-args";

@implementation PublishAlertModel
//初始化
-(instancetype)initWithAlertData:(NSDictionary *)alert{
    if((self = [super init]) && alert && alert.count){
        _body = alert[PUBLISH_ALERT_BODY];//1
        _actionLocKey = alert[PUBLISH_ALERT_ACTION_LOC_KEY];//2
        _locKey = alert[PUBLISH_ALERT_LOC_KEY];//3
        _launchImage = alert[PUBLISH_ALERT_LAUNCH_IMAGE];//4
        _locArgs = alert[PUBLISH_ALERT_LOC_ARGS];
    }
    return self;
}
@end

#pragma mark -- Apns消息格式
static NSString * const PUBLISH_APNS_BADGE = @"badge";
static NSString * const PUBLISH_APNS_SOUND = @"sound";
static NSString * const PUBLISH_APNS_CONTENTAVAILABLE = @"content-available";
static NSString * const PUBLISH_APNS_ALERT = @"alert";
//
@implementation PublishApnsModel
//初始化
-(instancetype)initWithApnsData:(NSDictionary *)apns{
    if((self = [super init]) && apns && apns.count){
        _badge = [apns[PUBLISH_APNS_BADGE] integerValue];//1
        _sound = apns[PUBLISH_APNS_SOUND];//2
        _contentAvailable = [apns[PUBLISH_APNS_CONTENTAVAILABLE] integerValue];//3
        id alert = apns[PUBLISH_APNS_ALERT];
        if([alert isKindOfClass:[NSDictionary class]]){
            _alert = [[PublishAlertModel alloc] initWithAlertData:alert];//4
        }else if([alert isKindOfClass:[NSString class]]){
            _alert = (NSString *)alert;
        }else{
            _alert = nil;
        }
    }
    return self;
}
@end

#pragma mark -- 推送消息实现
static NSString * const PUBLISH_PUSH_ID = @"pushId";
static NSString * const PUBLISH_CONTENT_ID = @"contentId";
static NSString * const PUBLISH_CONTENT = @"content";
static NSString * const PUBLISH_APS = @"aps";
//
@implementation PublishModel
//初始化对象。
-(instancetype)initWithData:(NSDictionary *)data{
    if((self = [super init]) && data && data.count){
        _pushId = data[PUBLISH_PUSH_ID];//1
        _contentId = data[PUBLISH_CONTENT_ID];//2
        id content = data[PUBLISH_CONTENT];//3
        if([content isKindOfClass:[NSString class]]){
            _content = content;
        }else if([content isKindOfClass:[NSDictionary class]]){
            NSError *err = nil;
            NSData *bytes = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:&err];
            if(bytes && bytes.length){
                _content = [[NSString alloc] initWithData:bytes encoding:NSUTF8StringEncoding];
            }
        }
        //4
        _apns = [[PublishApnsModel alloc] initWithApnsData:data[PUBLISH_APS]];
    }
    return self;
}

//静态初始化
+(instancetype)publishWithJSON:(NSString *)json{
    NSLog(@"publishWithJSON=>%@", json);
    if(!json || !json.length) return nil;
    //
    NSError *err = nil;
    NSData *objData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:objData
                                                         options:kNilOptions
                                                           error:&err];
    if(err) NSLog(@"publishWithJSON:-异常(\n%@\n)=>\n%@", json, err);
    //
    return [[PublishModel alloc] initWithData:dict];
}

@end
