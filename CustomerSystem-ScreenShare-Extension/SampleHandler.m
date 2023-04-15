//
//  SampleHandler.m
//  AgentSDKDemoShareExtension
//
//  Created by houli on 2022/7/4.
//  Copyright © 2022 环信. All rights reserved.
//
#import "SampleHandler.h"
#import <AgoraReplayKitExtension/AgoraReplayKitExt.h>
 #import <sys/time.h>
static NSString * _Nonnull kAppGroup = @"group.com.easemob.kf.demo.customer";
static NSString * _Nonnull kUserDefaultState = @"KEY_BXL_DEFAULT_STATE"; // 接收屏幕共享(开始/结束 状态)监听的Key
static NSString * _Nonnull kUserDefaultState_endCall = @"KEY_BXL_DEFAULT_STATE_ENDCALL"; // 接收屏幕共享(开始/结束 状态)监听的Key

static void *VECKVOContext = &VECKVOContext;

 @interface SampleHandler ()<AgoraReplayKitExtDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
 @end


@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    
    self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];

    [self.userDefaults setObject:@{@"state":@"broadcastStarted"} forKey:kUserDefaultState];//结束字段
    [self.userDefaults setObject:@{@"encCall":@"x"} forKey:kUserDefaultState_endCall];//给状态一个默认值
    [self.userDefaults addObserver:self forKeyPath:kUserDefaultState_endCall options:NSKeyValueObservingOptionNew context:VECKVOContext];
    [[AgoraReplayKitExt shareInstance] start:self];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kUserDefaultState_endCall]) {
        NSDictionary *string = change[NSKeyValueChangeNewKey];
        if ([string[@"encCall"] isEqual:@"encCall"]) {
            
            //开启 RTC：外部视频输入通道，开始推送屏幕流（configLocalScreenPublish）
            NSLog(@"== 屏幕分享开始=====%@",string);
            // 开启屏幕共享
            
            
        }
        if ([string[@"encCall"] isEqual:@"encCall1"]) {
            
            //关闭 RTC：外部视频输入通道，停止推送屏幕流
            NSLog(@"== 屏幕分享停止=====%@",string);
            
        }
        return;
    }
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    NSLog(@"broadcastPaused");
    [self.userDefaults setObject:@{@"state":@"broadcastPaused"} forKey:kUserDefaultState];
    [[AgoraReplayKitExt shareInstance] pause];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    NSLog(@"broadcastResumed");
    [self.userDefaults setObject:@{@"state":@"broadcastResumed"} forKey:kUserDefaultState];
    [[AgoraReplayKitExt shareInstance] resume];

}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    NSLog(@"broadcastFinished");
    [[AgoraReplayKitExt shareInstance] stop];
    [self.userDefaults setObject:@{@"state":@"broadcastFinished"} forKey:kUserDefaultState];//结束字段
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    
//    NSLog(@"========");
    
    [[AgoraReplayKitExt shareInstance] pushSampleBuffer:sampleBuffer withType:sampleBufferType];
}

#pragma mark - AgoraReplayKitExtDelegate

- (void)broadcastFinished:(AgoraReplayKitExt *_Nonnull)broadcast reason:(AgoraReplayKitExtReason)reason {
    switch (reason) {
        case AgoraReplayKitExtReasonInitiativeStop:
            {
//                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Host app stop srceen capture"};
//                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
//                [self finishBroadcastWithError:error];
                NSLog(@"AgoraReplayKitExtReasonInitiativeStop");
                
                [self broadcastFinished];
            }
            break;
        case AgoraReplayKitExtReasonConnectFail:
            {
                NSLog(@"AgoraReplayKitExReasonConnectFail");
                [self broadcastFinished];
            }
            break;

        case AgoraReplayKitExtReasonDisconnect:
            {

                NSLog(@"AgoraReplayKitExReasonDisconnect");
                [self broadcastFinished];
            }
            break;
        default:
            break;
    }
}


@end
