//
//  PublishModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushPublishModel.h"

#pragma mark -- 推送弹出消息数据
static NSString * const PUSH_PUBLISH_ALERT_BODY = @"body";
static NSString * const PUSH_PUBLISH_ALERT_ACTION_LOC_KEY = @"action-loc-key";
static NSString * const PUSH_PUBLISH_ALERT_LOC_KEY = @"loc-key";
static NSString * const PUSH_PUBLISH_ALERT_LAUNCH_IMAGE = @"launch-image";
static NSString * const PUSH_PUBLISH_ALERT_LOC_ARGS = @"loc-args";

@implementation PushPublishAlertModel
//初始化
-(instancetype)initWithAlertData:(NSDictionary *)alert{
    if((self = [super init]) && alert && alert.count){
        _body = alert[PUSH_PUBLISH_ALERT_BODY];//1
        _actionLocKey = alert[PUSH_PUBLISH_ALERT_ACTION_LOC_KEY];//2
        _locKey = alert[PUSH_PUBLISH_ALERT_LOC_KEY];//3
        _launchImage = alert[PUSH_PUBLISH_ALERT_LAUNCH_IMAGE];//4
        _locArgs = alert[PUSH_PUBLISH_ALERT_LOC_ARGS];
    }
    return self;
}
@end

#pragma mark -- Apns消息格式
static NSString * const PUSH_PUBLISH_APNS_BADGE = @"badge";
static NSString * const PUSH_PUBLISH_APNS_SOUND = @"sound";
static NSString * const PUSH_PUBLISH_APNS_CONTENTAVAILABLE = @"content-available";
static NSString * const PUSH_PUBLISH_APNS_ALERT = @"alert";
//
@implementation PushPublishApnsModel
//初始化
-(instancetype)initWithApnsData:(NSDictionary *)apns{
    if((self = [super init]) && apns && apns.count){
        _badge = [apns[PUSH_PUBLISH_APNS_BADGE] integerValue];//1
        _sound = apns[PUSH_PUBLISH_APNS_SOUND];//2
        _contentAvailable = [apns[PUSH_PUBLISH_APNS_CONTENTAVAILABLE] integerValue];//3
        id alert = apns[PUSH_PUBLISH_APNS_ALERT];
        if([alert isKindOfClass:[NSDictionary class]]){
            _alert = [[PushPublishAlertModel alloc] initWithAlertData:alert];//4
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
static NSString * const PUSH_PUBLISH_PUSH_ID = @"pushId";
static NSString * const PUSH_PUBLISH_CONTENT_ID = @"contentId";
static NSString * const PUSH_PUBLISH_CONTENT = @"content";
static NSString * const PUSH_PUBLISH_APS = @"aps";
//
@implementation PushPublishModel
//初始化对象。
-(instancetype)initWithData:(NSDictionary *)data{
    if((self = [super init]) && data && data.count){
        _pushId = data[PUSH_PUBLISH_PUSH_ID];//1
        _contentId = data[PUSH_PUBLISH_CONTENT_ID];//2
        id content = data[PUSH_PUBLISH_CONTENT];//3
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
        _apns = [[PushPublishApnsModel alloc] initWithApnsData:data[PUSH_PUBLISH_APS]];
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
    return [[PushPublishModel alloc] initWithData:dict];
}

@end
