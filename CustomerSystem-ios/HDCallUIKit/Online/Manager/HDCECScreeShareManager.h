//
//  HDScreeShareManager.h
//  AgentSDKDemo
//
//  Created by easemob on 2023/3/8.
//  Copyright © 2023 环信. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "HDAgoraCallManager.h"
NS_ASSUME_NONNULL_BEGIN
#define HDCEC_SCREENSHARE_STATRT @"CEC_ScreeShare_Start"
#define HDCEC_SCREENSHARE_STOP   @"CEC_ScreeShare_Stop"
@interface HDCECScreeShareManager : NSObject
@property (nonatomic, assign) BOOL  isApp;
@property (nonatomic, assign) BOOL  shareStatus;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
// 录屏功能是否可用
@property (nonatomic, readonly, getter=isAvailable) BOOL cecAvailable;
// 是否正在录制中
@property (nonatomic, readonly, getter=isRecording) BOOL cecRecording;
+ (instancetype _Nullable )shareInstance;

/// 开启屏幕共享 app 内
- (void)cec_app_startScreenCaptureCompletionHandler:(void (^)(NSError *_Nullable error))completionHandler;

/// 关闭屏幕共享 app内
- (void)cec_app_stopScreenCapture;

/// 初始化屏幕分享view
- (void)cec_initBroadPickerView;

/// 开启屏幕共享 插件 方式
- (void)cec_startAgoraScreenCapture;

/// 关闭屏幕共享 插件 方式
- (void)cec_stopAgoraScreenCapture;

@end

NS_ASSUME_NONNULL_END
