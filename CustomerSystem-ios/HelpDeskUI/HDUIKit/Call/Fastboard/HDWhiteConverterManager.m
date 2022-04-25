//
//  HDWhiteConverter.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDWhiteConverterManager.h"

#import "HDStorageItem.h"

@interface HDWhiteConverterManager ()

@property (nonatomic, assign) NSTimeInterval pollingInterval;
@property (nonatomic, copy) NSMutableDictionary *pollingTasks;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HDWhiteConverterManager
- (instancetype)init
{
    if (self = [super init]) {
        self.pollingInterval = 15;
    }
    return self;
}

- (instancetype)initWithPollingTimeinterval:(NSTimeInterval)interval
{
    if (self = [self init]) {
        if (interval < 0) {
            self.pollingInterval = 1;
        } else {
            self.pollingInterval = interval;
        }
    }
    return self;
}

- (void)onTimer
{
    [self.pollingTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HDStorageItem * _Nonnull obj, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf;
        
        [HDWhiteConverterManager checkProgressWithTaskUUID:obj.taskUUID token:obj.taskToken region:obj.region taskType:obj.taskType result:^(WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error) {
            if (error) {
                obj.completionHandler(NO, nil, error);
                [weakSelf cancelPollingTaskWithTaskUUID:key];
                return;
            }
            if ([info.status isEqualToString:WhiteConvertStatusV5Fail]) {
                obj.completionHandler(NO, info, error);
                [weakSelf cancelPollingTaskWithTaskUUID:key];
                return;
            }
            if ([info.status isEqualToString:WhiteConvertStatusV5Finished]) {
                obj.completionHandler(YES, info, nil);
                [weakSelf cancelPollingTaskWithTaskUUID:key];
                return;
            }
            obj.progressHandler(info.progress.convertedPercentage, info);
        }];
        
    }];
}

- (void)endTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (NSMutableDictionary *)pollingTasks
{
    if (!_pollingTasks) {
        _pollingTasks = [NSMutableDictionary dictionary];
    }
    return _pollingTasks;
}

- (void)startPolling
{
    if (self.timer) {
        
        [self endTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:self.pollingInterval target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [self onTimer];
}

- (void)pausePolling
{
    if (self.timer) {
        [self endTimer];
    }
}

- (void)endPolling
{
    [self.pollingTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HDStorageItem * _Nonnull task, BOOL * _Nonnull stop) {
        [self cancelPollingTaskWithTaskUUID:key];
    }];
    [self endTimer];
}

- (void)cancelPollingTaskWithTaskUUID:(NSString *)taskUUID
{
    HDStorageItem *task = self.pollingTasks[taskUUID];
    if (task) {
        if (task.urlTask) {
            [task.urlTask cancel];
        }
        [self.pollingTasks removeObjectForKey:taskUUID];
    }
    if (self.pollingTasks.count == 0) {
        [self endPolling];
    }
}
- (NSString *)insertPollingTaskWithTaskUUID:(NSString *)taskUUID
                                      token:(NSString *)token
                                     region:(WhiteRegionKey)region
                                   taskType:(WhiteConvertTypeV5)type
                                   progress:(HDConvertProgressHandlerV5)progress
                                     result:(HDConvertCompletionHandlerV5)result
{
    HDStorageItem *task = self.pollingTasks[taskUUID];
    if (!task) {
        HDStorageItem *newTask = [[HDStorageItem alloc] initWithTaskUUID:taskUUID
                                                                              token:token
                                                                             region:region
                                                                               type:type
                                                                    progressHandler:progress
                                                                  completionHandler:result];
        self.pollingTasks[taskUUID] = newTask;
    } else {
        task.taskToken = token;
        task.region = region;
        task.taskType = type;
        task.progressHandler = progress;
        task.completionHandler = result;
    }
    if (!self.timer) {
        [self startPolling];
    }
    return taskUUID;
}

+ (void)checkProgressWithTaskUUID:(NSString *)taskUUID token:(NSString *)token region:(WhiteRegionKey)region taskType:(WhiteConvertTypeV5)type result:(void (^)(WhiteConversionInfoV5 *  _Nullable info, NSError * _Nullable  error ))result{
    
    //查询文档进度
    [[HDWhiteboardManager shareInstance] hd_wordConverterPptPageProgress:@"" type:type callId:nil taskId:taskUUID completion:^(id _Nonnull responseObject, HDError * _Nonnull error) {
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"=== %@",responseObject);
            NSDictionary * dic = responseObject;
            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                NSDictionary *itemDic = [responseObject valueForKey:@"entity"] ;
                WhiteConversionInfoV5 *info = [WhiteConversionInfoV5 modelWithJSON:itemDic];
                !result ? : result(info, nil);
            }
        }
        NSLog(@"=== %@",responseObject);
    }];
    
}

                       

@end
