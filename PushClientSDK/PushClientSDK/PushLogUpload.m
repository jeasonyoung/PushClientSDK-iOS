//
//  PushLogUpload.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/4/7.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushLogUpload.h"
#import "PushLogWrapper.h"
#import "PushConnectRequestModel.h"
#import "NSString+PushExtTools.h"

#import "AFNetworking.h"

#import "PushAckModel.h"

#define PUSH_LOG_UPLOAD_QUEUE "push_logs_uploader_queue"

#define PUSH_UPLOADER_WAIT 2
#define PUSH_UPLOADER_INTERVAL 300000

@interface PushLogUpload (){
    NSDateFormatter *_logFileDateFormatter;
    dispatch_queue_t _queue;
    NSUInteger _lastUploadTime;
    PushLogWrapper *_logWrapper;
}

//是否在执行上传任务
@property(assign,atomic)BOOL isRun;

@end

@implementation PushLogUpload

#pragma mark -- init
-(instancetype)init{
    if(self = [super init]){
        //上传线程队列
        _queue = dispatch_queue_create(PUSH_LOG_UPLOAD_QUEUE, DISPATCH_QUEUE_SERIAL);
        //是否上传运行标识
        _isRun = NO;
        //日志文件保存的日期格式
        _logFileDateFormatter = [[NSDateFormatter alloc] init];
        [_logFileDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [_logFileDateFormatter setDateFormat:@"yyyyMMddHH"];//日志按小时保存
        //最近上传时间戳
        _lastUploadTime = 0;
        //日志实例
        _logWrapper = [PushLogWrapper sharedInstance];
    }
    return self;
}

#pragma mark -- instance
+(instancetype)shareInstance{
    static PushLogUpload *_instance;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PushLogUpload alloc] init];
        LogD(@"PushLogUpload-shareInstance...");
    });
    return _instance;
}


#pragma mark -- uploaders
-(void)uploaderWithAccess:(PushAccessData *)access{
    NSString *dir = _logWrapper.getRootDir;
    if(!dir ||!access){
        LogW(@"uploaderWithDir-参数为空(dir:%@,access:%@)!", dir, access);
        return;
    }
    if(!access.account || !access.deviceToken || !access.url){
        LogW(@"uploaderWithDir-接入帐号(%@)或设备ID(%@)或URL(%@)为空!", access.account, access.deviceToken, access.url);
        return;
    }
    if(self.isRun){
        LogW(@"uploaderWithDir-isRun:%zd", self.isRun);
        return;
    }
    //当前时间毫秒
    NSUInteger current = ([[NSDate date] timeIntervalSince1970]) * 1000;
    if(current - _lastUploadTime < PUSH_UPLOADER_INTERVAL){
        return;
    }
    //更新上次上传时间
    _lastUploadTime = current;
    self.isRun = YES;//上传附件服务开始标示。
    dispatch_async(_queue, ^{
        @try {
            //uploader url
            NSRange range = [access.url rangeOfString:PUSH_SRV_URL_SUFFIX];
            if(range.location == NSNotFound){
                self.isRun = NO;
                return;
            }
            //初始化上传URL
            NSMutableString *url = [NSMutableString stringWithString:[access.url substringWithRange:NSMakeRange(0, range.location)]];
            [url appendString:PUSH_UPLOADER_URL_SUFFIX];
            LogD(@"uploader-url:%@", url);
            //文件管理器
            NSFileManager *mgr = [NSFileManager defaultManager];
            //目录下的所有文件
            NSArray *logFiles = [mgr contentsOfDirectoryAtPath:dir error:nil];
            if(logFiles && logFiles.count > 0){
                //构建headers参数
                NSDictionary *preHeaders = @{@"PUSH_ACCOUNT": access.account,
                                             @"PUSH_DEVICE_TYPE": @(PUSH_CURRENT_DEVICE_TYPE_VALUE),
                                             @"PUSH_DEVICE_TOKEN": access.deviceToken,
                                             @"PUSH_DEVICE_TAG": (access.tag ? access.tag : @""),
                                             @"PUSH_RANDON_VALUE": @(current)};
                NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:preHeaders];
                [headers setObject:[self createSignWithParams:preHeaders withToken:access.password] forKey:@"PUSH_SIGN"];
                LogD(@"headers=>%@", headers);
                //当前记录时间
                NSString *current = [_logFileDateFormatter stringFromDate:[NSDate date]];
                //删除已上传文件集合
                NSMutableArray *uploadedPaths = [NSMutableArray arrayWithCapacity:logFiles.count];
                //循环文件集合
                for(NSString *fname in logFiles){
                    if(!fname || ([fname rangeOfString:current].location != NSNotFound)) continue;
                    @try {
                        //上传日志文件路径
                        NSString *path = [NSString stringWithString:dir];
                        [path stringByAppendingPathComponent:fname];
                        //上传日志文件
                        [self uploaderFileWithURL:url withHeaders:headers withFileManager:mgr withFileName:fname withPath:path complete:^(NSString *fPath) {
                            if(fPath && fPath.length > 0){
                                [uploadedPaths addObject:fPath];
                                LogI(@"上传日志文件成功=>%@", fPath);
                            }
                        }];
                    } @catch (NSException *e) {
                        LogW(@"上传日志文件[%@]-异常:%@", fname, e);
                    } @finally{
                        sleep(PUSH_UPLOADER_WAIT);//线程等待2‘
                    }
                }
                //删除已上传的文件
                if(uploadedPaths.count > 0){
                    NSError *err = nil;
                    for(NSString *path in uploadedPaths){
                        if(![mgr fileExistsAtPath:path]) continue;//文件不存在
                        //删除
                        if(![mgr removeItemAtPath:path error:&err]){
                            LogW(@"删除日志文件(%@)异常:%@", path, err);
                        }
                    }
                }
            }
        } @catch (NSException *ex) {
            LogE(@"uploaderWithDir(dir:%@)-上传日志文件异常:%@", dir, ex);
        } @finally {
            if(self.isRun) self.isRun = NO;
        }
    });
}

#pragma mark -- //创建参数签名处理
-(NSString *)createSignWithParams:(NSDictionary *)params withToken:(NSString *)token{
    if(!params || params.count == 0 || !token || token.length == 0) return @"";
    //参数值排序
    NSArray *sortedValues = [[params allValues] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *val1 = @"", *val2 = @"";
        //obj1
        if([obj1 isKindOfClass:[NSString class]]){
            val1 = obj1;
        }else if([obj1 isKindOfClass:[NSNumber class]]){
            val1 = [((NSNumber *)obj1) stringValue];
        }
        //obj2
        if([obj2 isKindOfClass:[NSString class]]){
            val2 = obj2;
        }else if([obj2 isKindOfClass:[NSNumber class]]){
            val2 = [((NSNumber *)obj2) stringValue];
        }
        //比较
        return [val1 compare:val2];
    }];
    //参数值拼接
    NSMutableString *str = [NSMutableString string];
    [sortedValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSNull class]]) return;
        if([obj isKindOfClass:[NSString class]]){
            [str appendFormat:@"%@$",obj];
        }else if([obj isKindOfClass:[NSNumber class]]){
            [str appendFormat:@"%zd$", [((NSNumber *)obj) integerValue]];
        }
    }];
    if(str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    [str appendString:token];
    LogD(@"签名前字符串:%@", str);
    //字符串签名
    return [str md5];
}

#pragma mark -- // 上传日志文件处理
-(void)uploaderFileWithURL:(NSString *)url
              withHeaders:(NSDictionary *)headers
           withFileManager:(NSFileManager *)fileMgr
              withFileName:(NSString *)fileName
                 withPath:(NSString *)path
                 complete:(void(^)(NSString *))success{
    //初始化HTTP
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求处理器
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    jsonResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/html",nil];
    manager.responseSerializer = jsonResponseSerializer;//反馈处理器
    //headers
    if(headers && headers.count > 0){
        for(NSString *key in headers){
            if(!key || key.length == 0) continue;
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //上传日志文件
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = [fileMgr contentsAtPath:path];
        if(data && data.length > 0){
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"text/plain"];
        }
    }
          success:^(NSURLSessionDataTask *task, id responseObject) {
              //解析反馈
              NSError *err = nil;
              id data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&err];
              if(err || !data || ![data isKindOfClass:[NSDictionary class]]){
                  NSString *resp = [[NSString alloc]  initWithData:responseObject encoding:NSUTF8StringEncoding];
                  LogE(@"上传文件[%@]反馈解析失败[code=%zd]!=>%@", fileName, err.code, resp);
                  return;
              }
              //解析反馈
              PushAckModel *ack = [[PushAckModel alloc] initWithType:PushSocketMessageTypeNone andAck:data];
              if(ack.result != PushAckModelResultSuccess){
                  LogE(@"上传文件[%@]失败!=>%@", fileName, ack.msg);
                  return;
              }
              //上传成功
              if(success){
                  success(path);
              }
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              //上传文件失败
              LogE(@"上传文件[%@]失败!=>%@", fileName, error);
          }];
}

@end
