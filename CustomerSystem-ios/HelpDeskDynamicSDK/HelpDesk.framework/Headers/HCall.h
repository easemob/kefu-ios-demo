//
//  HCall.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCallLocalView.h"
#import "HCallRemoteView.h"
#import <HyphenateLite/EMOptions.h>
#import "HError.h"
#import "HCallOptions.h"
#import "HCallEnum.h"
#import "HCallLocalView.h"
#import "HCallManagerDelegate.h"
#import "HCallRemoteView.h"
#import "HCallEntities.h"

#import "HCall.h"

@interface HCall : NSObject

+ (instancetype)shareInstance;

#pragma mark - Options

/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 *
 *  @param aOptions  Setting options
 */
- (void)setCallOptions:(HCallOptions *)aOptions;

/*!
 *  \~chinese
 *  获取设置项
 *
 *  @result 设置项
 *
 *  \~english
 *  Get setting options
 *
 *  @result Setting options
 */
- (HCallOptions *)getCallOptions;


#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<HCallManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<HCallManagerDelegate>)aDelegate;

#pragma mark - answer and end session

/**
 接受视频会话

 @param completion 完成回调
 */
- (void)acceptCallCompletion:(void(^)(id obj,HError *error))completion;


/**
 接受视频会话

 @param nickname 传递自己的昵称到对方
 @param completion 完成回调
 */
- (void)acceptCallWithNickname:(NSString *)nickname completion:(void (^)(id, HError *))completion;

/**
 结束视频会话
 */
- (void)endCall;


/**
 订阅视频
 */
- (void)subscribeStreamId:(NSString *)streamId view:(HCallRemoteView *)view completion:(void(^)(id obj,HError *error))completion;


- (void)unSubscribeStreamId:(NSString *)streamId completion:(void(^)(id obj,HError *error))completion;
#pragma mark - Control Camera


- (void)switchCameraPosition:(BOOL)aIsFrontCamera __attribute__((deprecated("已过期, 请使用switchCamera")));

/**
    切换摄像头
 */
- (void)switchCamera;

#pragma mark - Control Stream

/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  \~english
 *  Suspend voice data transmission
 */
- (void)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Resume voice data transmission
 *
 *  @result Error
 */
- (void)resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  \~english
 * Suspend video data transmission
 */
- (void)pauseVideo;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)resumeVideo;


/**
 * 发送自定义消息
 */
- (void) sendCustomWithRemoteMemberId:(NSString*)remoteMemeberId
            message:(NSString*)message
             onDone:(void(^)(id obj, HError * error))block;

/**
 * 发送自定义消息
 */
- (void) sendCustomWithRemoteStreamId:(NSString*)remoteStreamId
            message:(NSString*)message
             onDone:(void(^)(id obj, HError * error))block;

/**
 * 共享桌面 其中为rootView
 */
- (void)publishWindow:(UIView *)view completion:(void (^)(id, HError *))completion;
/**
 *  取消共享桌面
 */
-(void)unPublishWindowWithCompletion:(void (^)(id, HError *))completion;
    
@end







