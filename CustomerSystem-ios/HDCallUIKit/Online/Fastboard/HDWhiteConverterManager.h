//
//  HDWhiteConverter.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Whiteboard/Whiteboard.h>
NS_ASSUME_NONNULL_BEGIN


/**
 V5版本的转码查询工具
 不再提供转码提交功能，只提供转码进度轮询功能
 */
@interface HDWhiteConverterManager : NSObject

/** 默认初始的轮询时间为15S */
- (instancetype)init;

/** 指定轮询时间 */
- (instancetype)initWithPollingTimeinterval:(NSTimeInterval)interval;

/** 启动轮询 */
- (void)startPolling;

/** 暂停轮询*/
- (void)pausePolling;

/** 停止轮询并且删除所有轮询任务 */
- (void)endPolling;

/**
 取消特定的一个轮询任务
 @param taskUUID 任务id
 */
- (void)cancelPollingTaskWithTaskUUID:(NSString *)taskUUID;

/**
 插入一个任务查询的轮询任务
 该任务会在转码失败或者成功之后被移出轮询队列
 
 @param taskUUID 转码id
 @param token 转码token
 @param region 转码Region
 @param type 转码类型, WhiteConvertTypeDynamic或者WhiteConvertTypeStatic
 @param progress 进度回调
 @param result 转码成功或者失败回调
 @return 任务id
 */
- (NSString *)insertPollingTaskWithTaskUUID:(NSString *)taskUUID
                                      token:(NSString *)token
                                     region:(WhiteRegionKey)region
                                   taskType:(WhiteConvertTypeV5)type
                                   progress:(_Nullable ConvertProgressHandlerV5)progress
                                     result:(_Nullable ConvertCompletionHandlerV5)result;
/**
 单次查询一个特定的转码任务进度
 @param taskUUID 转码id
 @param token 转码token
 @param region 转码Region
 @param type 转码类型, WhiteConvertTypeDynamic或者WhiteConvertTypeStatic
 @param result 转码进度回调
 */
+ (void)checkProgressWithTaskUUID:(NSString *)taskUUID
                                          token:(NSString *)token
                                         region:(WhiteRegionKey)region
                                       taskType:(WhiteConvertTypeV5)type
                                         result:(void (^)(WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error))result;
@end

NS_ASSUME_NONNULL_END
