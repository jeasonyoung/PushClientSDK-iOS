//
//  PublishModel.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/2/21.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushPublishModel.h"
#import "PushLogWrapper.h"

#pragma mark -- 推送弹出消息数据
static NSString * const PUSH_PUBLISH_APS_ALERT_TITLE = @"title";
static NSString * const PUSH_PUBLISH_APS_ALERT_BODY = @"body";
static NSString * const PUSH_PUBLISH_APS_ALERT_ACTION_LOC_KEY = @"action-loc-key";
static NSString * const PUSH_PUBLISH_APS_ALERT_LOC_KEY = @"loc-key";
static NSString * const PUSH_PUBLISH_APS_ALERT_LAUNCH_IMAGE = @"launch-image";
static NSString * const PUSH_PUBLISH_APS_ALERT_LOC_ARGS = @"loc-args";

@implementation PushPublishApsAlertModel
//初始化
-(instancetype)initWithApsAlertData:(NSDictionary *)alert{
    if((self = [super init]) && alert && alert.count){
        id obj = nil;
        //title
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_TITLE])){
            _title = obj;//1
        }
        //body
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_BODY])){
            _body = obj;//2
        }
        //action loc key
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_ACTION_LOC_KEY])){
            _actionLocKey = obj;//3
        }
        //aps alert loc
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_LOC_KEY])){
            _locKey = obj;//4
        }
        //image
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_LAUNCH_IMAGE])){
            _launchImage = obj;//5
        }
        //lock args
        if((obj = [alert objectForKey:PUSH_PUBLISH_APS_ALERT_LOC_ARGS])){
            _locArgs = obj;//6
        }
    }
    return self;
}
@end

#pragma mark -- Apns消息格式
static NSString * const PUSH_PUBLISH_APS_BADGE = @"badge";
static NSString * const PUSH_PUBLISH_APS_SOUND = @"sound";
static NSString * const PUSH_PUBLISH_APS_CONTENT_AVAILABLE = @"content-available";
static NSString * const PUSH_PUBLISH_APS_ALERT = @"alert";
//
@implementation PushPublishApsModel
//初始化
-(instancetype)initWithApsData:(NSDictionary *)aps{
    if((self = [super init]) && aps && aps.count){
        id obj = nil;
        //badge
        if((obj = [aps objectForKey:PUSH_PUBLISH_APS_BADGE])){
            _badge = [obj integerValue];//1
        }
        //sound
        if((obj = [aps objectForKey:PUSH_PUBLISH_APS_SOUND])){
            _sound = obj;//2
        }
        //content Available
        if((obj = [aps objectForKey:PUSH_PUBLISH_APS_CONTENT_AVAILABLE])){
            _contentAvailable = [obj integerValue];//3
        }
        //alert
        id alert = nil;
        if((alert = [aps objectForKey:PUSH_PUBLISH_APS_ALERT])){
            if([alert isKindOfClass:[NSDictionary class]]){
                _alert = [[PushPublishApsAlertModel alloc] initWithApsAlertData:alert];//4
            }else if([alert isKindOfClass:[NSString class]]){
                _alert = (NSString *)alert;
            }else{
                _alert = nil;
            }
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
        id obj = nil;
        //推送ID
        if((obj = [data objectForKey:PUSH_PUBLISH_PUSH_ID])){
            _pushId = obj;//1
        }
        //推送内容ID
        if((obj = [data objectForKey:PUSH_PUBLISH_CONTENT_ID])){
            _contentId = obj;//2
        }
        //推送消息内容
        id content = nil;
        if((content = [data objectForKey:PUSH_PUBLISH_CONTENT])){//3
            if([content isKindOfClass:[NSString class]]){
                _content = content;
            }else if([content isKindOfClass:[NSDictionary class]]){
                NSError *err = nil;
                NSData *bytes = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:&err];
                if(bytes && bytes.length){
                    _content = [[NSString alloc] initWithData:bytes encoding:NSUTF8StringEncoding];
                }
            }
        }
        //aps是否存在 4
        if((obj = [data objectForKey:PUSH_PUBLISH_APS])){
            _aps = [[PushPublishApsModel alloc] initWithApsData:obj];
        }
    }
    return self;
}

//静态初始化
+(instancetype)publishWithJSON:(NSString *)json{
    LogD(@"publishWithJSON=>%@", json);
    if(!json || !json.length) return nil;
    //
    NSError *err = nil;
    NSData *objData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:objData
                                                         options:kNilOptions
                                                           error:&err];
    if(err) LogE(@"publishWithJSON:-异常(\n%@\n)=>\n%@", json, err);
    //
    return [[PushPublishModel alloc] initWithData:dict];
}

@end
