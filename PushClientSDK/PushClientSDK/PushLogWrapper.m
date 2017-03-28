//
//  Log.m
//  PushClientSDK
//
//  Created by jeasonyoung on 2017/3/27.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "PushLogWrapper.h"

/**
 * @brief 推送日志级别枚举。
 **/
typedef NS_ENUM(NSInteger,PushLogWrapperLevel){
    /**
     * @brief DEBUG
     **/
    PushLogWrapperLevelDebug = 1,
    /**
     * @brief INFO
     **/
    PushLogWrapperLevelInfo = 2,
    /**
     * @brief WARN
     **/
    PushLogWrapperLevelWarn = 3,
    /**
     * @brief ERROR
     **/
    PushLogWrapperLevelError = 4
};

#define PUSH_LOG_WRAPPER_QUEUE "push_log_wrapper_queue"
#define PUSH_LOG_DIR @"PushClientSDKLogs"
#define PUSH_LOG_FILE_PREFIX @"pushSDK"


#define DLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);

//成员变量
@interface PushLogWrapper (){
    //日志写队列
    dispatch_queue_t _queue;
}

/**
 * @brief 日志文件存储根目录。
 **/
@property(copy, atomic, readonly, getter=getRootDir)NSString *rootDir;

@end

//实现体
@implementation PushLogWrapper

+(instancetype)sharedInstance{
    static PushLogWrapper *_instance;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PushLogWrapper alloc] init];
    });
    return _instance;
}

-(instancetype)init{
    if(self = [super init]){
        //创建异步处理线程队列
        _queue = dispatch_queue_create(PUSH_LOG_WRAPPER_QUEUE, DISPATCH_QUEUE_SERIAL);
        //创建日志保存根目录
        _rootDir = [self createLogSaveRoot];
    }
    return self;
}

//创建日志保存根目录
-(NSString *)createLogSaveRoot{
    //获取document文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    //获取日志存储目标名称
    NSString *logDir = [docDir stringByAppendingString:PUSH_LOG_DIR];
    //获取文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileMgr fileExistsAtPath:logDir isDirectory:&isDir];
    if(!(isDirExist && isDir)){//检查目录是否存在
        BOOL isCreateDir = [fileMgr createDirectoryAtPath:logDir
                              withIntermediateDirectories:YES
                                               attributes:@{NSFileProtectionKey : NSFileProtectionNone}
                                                    error:nil];
        DLog(@"createLogSaveRoot-创建日志保存目录[%zd]:\n%@", isCreateDir,logDir);
    }
    DLog(@"createLogSaveRoot-日志保存目录:\n%@", logDir);
    return logDir;
}


-(void)debugWithFormat:(NSString *)format, ...{
    if(!format) return;
    //解析变长参数
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    //写入日志
    [self writeLogFileWithLevel:PushLogWrapperLevelDebug andLog:str];
}

-(void)infoWithFormat:(NSString *)format, ...{
    if(!format) return;
    //解析变长参数
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    //写入日志
    [self writeLogFileWithLevel:PushLogWrapperLevelInfo andLog:str];
}

-(void)warnWithFormat:(NSString *)format, ...{
    if(!format) return;
    //解析变长参数
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    //写入日志
    [self writeLogFileWithLevel:PushLogWrapperLevelWarn andLog:str];
}

-(void)errorWithFormat:(NSString *)format, ...{
    if(!format) return;
    //解析变长参数
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    //写入日志
    [self writeLogFileWithLevel:PushLogWrapperLevelError andLog:str];
}

-(void)writeLogFileWithLevel:(PushLogWrapperLevel)level andLog:(NSString *)log{
    if(!log || log.length == 0) return;
    NSString *strLevel = @"none";
    switch (level) {
        case PushLogWrapperLevelDebug:
            strLevel = @"debug";
            break;
        case PushLogWrapperLevelInfo:
            strLevel = @"info";
            break;
        case PushLogWrapperLevelWarn:
            strLevel = @"warn";
            break;
        case PushLogWrapperLevelError:
            strLevel = @"error";
            break;
        default: break;
    }

//#ifdef DEBUG
    DLog(@"[%@]%@", strLevel, log);
//#endif
    
    //日志写入文件处理
    dispatch_async(_queue, ^{
        @try {
            //创建日志文件
            NSString *path = [self createLogFilePathWithLevel:level];
            if(!path) return;
            //获取文件句柄
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
            //跳到文件的末尾
            [fileHandle seekToEndOfFile];
            //日期格式化
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *date = [dateFormatter stringFromDate:[NSDate date]];
            //日志内容
            NSString *content = [NSString stringWithFormat:@"[%@][%@]%@\n", date, strLevel, log];
            //数据编码
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            //追加写入文件
            [fileHandle writeData:data];
        } @catch (NSException *exception) {
            DLog(@"写入日志文件异常:%@", exception);
        }
    });
}

-(NSString *)createLogFilePathWithLevel:(PushLogWrapperLevel)level{
    //日期格式处理
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyyMMddHH"];//日志按小时保存
    NSString *date = [formatter stringFromDate:[NSDate date]];
    //创建日志文件名
    NSString *logFileName = [NSString stringWithFormat:@"%@-%zd-%@.log",PUSH_LOG_FILE_PREFIX, level, date];
    NSString *logFilePath = [self.getRootDir stringByAppendingPathComponent:logFileName];
    //文件管理器
    NSFileManager *fileMgr  = [NSFileManager defaultManager];
    //检查日志文件是否存在
    if(![fileMgr fileExistsAtPath:logFilePath]){
        //初始化日志文件头
        NSString *initContent = @"-------------------------------------\n push sdk log \n-------------------------------------\n";
        NSData *data = [initContent dataUsingEncoding:NSUTF8StringEncoding];
        //创建日志文件
        BOOL isCreateFile = [fileMgr createFileAtPath:logFilePath contents:data attributes:nil];
        DLog(@"createLogFilePathWithLevel[%zd]-创建日志文件[%zd]:%@", level, isCreateFile, logFilePath);
    }
    //DLog(@"createLogFilePathWithLevel[%zd]-日志文件:%@", level, logFilePath);
    return logFilePath;
}


@end
