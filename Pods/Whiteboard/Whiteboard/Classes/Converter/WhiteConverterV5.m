//
//  WhiteConverterV5.m
//  Whiteboard
//
//  Created by xuyunshi on 2022/2/22.
//

#import "WhiteConverterV5.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteConverterTaskV5 : NSObject

@property (nonatomic, copy) NSString *taskUUID;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) WhiteRegionKey region;
@property (nonatomic, copy) WhiteConvertTypeV5 type;
@property (nonatomic, weak, nullable) NSURLSessionTask *urlTask;
@property (nonatomic, copy) ConvertProgressHandlerV5 progressHandler;
@property (nonatomic, copy) ConvertCompletionHandlerV5 completionHandler;

- (instancetype)initWithTaskUUID:(NSString *)taskUUID
                           token:(NSString *)token
                          region:(WhiteRegionKey)region
                            type:(WhiteConvertTypeV5)type
                 progressHandler:(ConvertProgressHandlerV5)progressHandler
               completionHandler:(ConvertCompletionHandlerV5)completionHandler;

@end

@implementation WhiteConverterTaskV5

- (instancetype)initWithTaskUUID:(NSString *)taskUUID
                           token:(NSString *)token
                          region:(WhiteRegionKey)region
                            type:(WhiteConvertTypeV5)type
                 progressHandler:(ConvertProgressHandlerV5)progressHandler
               completionHandler:(ConvertCompletionHandlerV5)completionHandler
{
    if (self = [super init]) {
        self.taskUUID = taskUUID;
        self.token = token;
        self.region = region;
        self.type = type;
        self.progressHandler = progressHandler;
        self.completionHandler = completionHandler;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END


static NSURLSession* querySession() {
    static NSURLSession* session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                delegate:nil
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    return session;
}

static NSString * const ConverterApiOriginV5 = @"https://api.netless.link/v5";

static NSString * const kHttpCode = @"httpCode";
static NSString * const kErrorCode = @"errorCode";
static NSString * const kErrorDomain = @"errorDomain";

@interface WhiteConverterV5 ()

@property (nonatomic, assign) NSTimeInterval pollingInterval;
@property (nonatomic, copy) NSMutableDictionary *pollingTasks;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WhiteConverterV5

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
    [self.pollingTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, WhiteConverterTaskV5 * _Nonnull obj, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf;
        NSURLSessionTask *task = [WhiteConverterV5 checkProgressWithTaskUUID:obj.taskUUID
                                                                       token:obj.token
                                                                      region:obj.region
                                                                    taskType:obj.type
                                                                      result:^(WhiteConversionInfoV5 *info, NSError *error) {
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
        obj.urlTask = task;
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
    [self.pollingTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, WhiteConverterTaskV5 * _Nonnull task, BOOL * _Nonnull stop) {
        [self cancelPollingTaskWithTaskUUID:key];
    }];
    [self endTimer];
}

- (void)cancelPollingTaskWithTaskUUID:(NSString *)taskUUID
{
    WhiteConverterTaskV5 *task = self.pollingTasks[taskUUID];
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
                                   progress:(ConvertProgressHandlerV5)progress
                                     result:(ConvertCompletionHandlerV5)result
{
    WhiteConverterTaskV5 *task = self.pollingTasks[taskUUID];
    if (!task) {
        WhiteConverterTaskV5 *newTask = [[WhiteConverterTaskV5 alloc] initWithTaskUUID:taskUUID
                                                                              token:token
                                                                             region:region
                                                                               type:type
                                                                    progressHandler:progress
                                                                  completionHandler:result];
        self.pollingTasks[taskUUID] = newTask;
    } else {
        task.token = token;
        task.region = region;
        task.type = type;
        task.progressHandler = progress;
        task.completionHandler = result;
    }
    if (!self.timer) {
        [self startPolling];
    }
    return taskUUID;
}

+ (NSURLSessionTask *)checkProgressWithTaskUUID:(NSString *)taskUUID
                            token:(NSString *)token
                           region:(WhiteRegionKey)region
                         taskType:(WhiteConvertTypeV5)type
                           result:(void (^)(WhiteConversionInfoV5 * _Nullable info, NSError  * _Nullable error ))result
{
    NSLog(@"enter task in thread %@", [NSThread currentThread]);
    NSString *questUrl = [ConverterApiOriginV5 stringByAppendingString:[NSString stringWithFormat:@"/services/conversion/tasks/%@?type=%@", taskUUID, type]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:questUrl]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:region forHTTPHeaderField:@"region"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionTask *task = [querySession() dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Task canceled
        if ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == -999)) {
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error && result) {
            NSMutableDictionary *mutableDict = [(error.userInfo ? : @{}) mutableCopy];
            mutableDict[kErrorDomain] = error.domain;
            mutableDict[kErrorCode] = @(error.code);
            NSError *error = [NSError errorWithDomain:WhiteConstConvertDomain code:ConverterErrorCodeV5CheckFail userInfo:mutableDict];
            result(nil, error);
        } else if (httpResponse.statusCode == 200) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            WhiteConversionInfoV5 *info = [WhiteConversionInfoV5 modelWithJSON:responseObject];
            !result ? : result(info, nil);
        } else {
            NSMutableDictionary *responseObject = [([NSJSONSerialization JSONObjectWithData:data options:0 error:nil] ? : @{}) mutableCopy];
            responseObject[kHttpCode] = @(httpResponse.statusCode);
            NSError *error = [NSError errorWithDomain:WhiteConstConvertDomain code:ConverterErrorCodeV5CheckFail userInfo:responseObject];
            !result ? : result(nil, error);
        }
    }];
    [task resume];
    return task;
}

@end
