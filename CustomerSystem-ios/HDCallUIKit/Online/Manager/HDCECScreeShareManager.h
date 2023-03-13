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
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
+ (instancetype _Nullable )shareInstance;

/// 初始化屏幕分享view
- (void)initBroadPickerView;

/// 开启屏幕共享
- (void)startScreenCapture;

/// 关闭屏幕共享
- (void)stopScreenCapture;

@end

NS_ASSUME_NONNULL_END
