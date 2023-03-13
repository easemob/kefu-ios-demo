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
#define HDVEC_SCREENSHARE_STATRT @"VEC_ScreeShare_Start"
#define HDVEC_SCREENSHARE_STOP   @"VEC_ScreeShare_Stop"
@interface HDVECScreeShareManager : NSObject
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
+ (instancetype _Nullable )shareInstance;

/// 初始化屏幕分享view
- (void)vec_initBroadPickerView;

/// 开启屏幕共享
- (void)vec_startScreenCapture;

/// 关闭屏幕共享
- (void)vec_stopScreenCapture;

@end

NS_ASSUME_NONNULL_END
