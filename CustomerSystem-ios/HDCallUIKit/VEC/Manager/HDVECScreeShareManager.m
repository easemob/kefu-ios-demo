//
//  HDScreeShareManager.m
//  AgentSDKDemo
//
//  Created by easemob on 2023/3/8.
//  Copyright © 2023 环信. All rights reserved.
//

#import "HDVECScreeShareManager.h"
#import "MBProgressHUD+Add.h"
#import <AgoraReplayKitExtension/AgoraReplayKitExt.h>
#define kScreenShareExtensionBundleId @"com.easemob.kf.demo.customer.shareWindow"
static NSString * _Nonnull kUserDefaultState = @"KEY_BXL_DEFAULT_STATE"; // 接收屏幕共享(开始/结束 状态)监听的Key
static NSString * _Nonnull kAppGroup = @"group.com.easemob.kf.demo.customer";

static void *KVOContext = &KVOContext;

@interface HDVECScreeShareManager()<AgoraReplayKitExtDelegate,RPScreenRecorderDelegate>

@end

@implementation HDVECScreeShareManager
static HDVECScreeShareManager *shareManager = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HDVECScreeShareManager alloc] init];
    });
    return shareManager;
}
#pragma mark ---------------------屏幕共享  应用内 start----------------------
-(BOOL)isAvailable{
    
    
    return [RPScreenRecorder sharedRecorder].available;
    
}

- (BOOL)isRecording{
    
    return [RPScreenRecorder sharedRecorder].recording;
    
}

- (void)vec_app_startScreenCaptureCompletionHandler:(void (^)(NSError * _Nullable))completionHandler{
    
    if ([self isRecording]) {
        
        [self vec_app_stopScreenCapture];
        
    }else{
    
    // 设置录屏代理
    [RPScreenRecorder sharedRecorder].delegate = self;
        if (@available(iOS 11.0, *)) {
    [[RPScreenRecorder sharedRecorder]  startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
        
        [[AgoraReplayKitExt shareInstance] pushSampleBuffer:sampleBuffer withType:bufferType];
            
    
    } completionHandler:^(NSError * _Nullable error) {
        
        if (error == nil) {
            [[AgoraReplayKitExt shareInstance] start:self];
            
            [self vec_startAgoraScreenCapture];
        }else{
           
            [self vec_app_stopScreenCapture];
            
        }
        
        if (completionHandler) {
            completionHandler(error);
        }
    }];
    }
    }
}

- (void)vec_app_stopScreenCapture{
    if (@available(iOS 11.0, *)) {
        
        [[AgoraReplayKitExt shareInstance] stop];
        
        [[RPScreenRecorder sharedRecorder] stopCaptureWithHandler:^(NSError * _Nullable error) {
            
        }];
        //
        [self vec_stopAgoraScreenCapture];
            
    } else {
        // Fallback on earlier versions
    }
   
   
    
}
- (void)broadcastFinished:(AgoraReplayKitExt * _Nonnull)broadcast reason:(AgoraReplayKitExtReason)reason  API_AVAILABLE(ios(11.0)){
    
    switch (reason) {
        case AgoraReplayKitExtReasonInitiativeStop:
            {
                NSLog(@"AgoraReplayKitExtReasonInitiativeStop");
            }
            break;
        case AgoraReplayKitExtReasonConnectFail:
            {
                NSLog(@"AgoraReplayKitExReasonConnectFail");
            }
            break;

        case AgoraReplayKitExtReasonDisconnect:
            {

                NSLog(@"AgoraReplayKitExReasonDisconnect");
            }
            break;
        default:
            break;
    }
}


#pragma mark ---------------------屏幕共享  应用内 end----------------------
/// 初始化屏幕分享view
- (void)vec_initBroadPickerView{
    if (@available(iOS 12.0, *)) {
        _broadPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadPickerView.preferredExtension = kScreenShareExtensionBundleId;
        _broadPickerView.showsMicrophoneButton = NO;
        _broadPickerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        // 设置appgroup 相关 保证app进程间正常通信
        [self vec_setupUserDefaults];
        for (UIView *view in _broadPickerView.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
                //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
                [(UIButton*)view sendActionsForControlEvents:UIControlEventAllTouchEvents];
            }
        }
      
    } else {
        // Fallback on earlier versions
//        [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.screenShareExtension", "video.screenShareExtension")  withWindow:self.alertWindow];
    }
}
- (void)vec_startAgoraScreenCapture{
    
    //在加入频道后调用 startScreenCapture，然后调用 updateChannelWithMediaOptions 更新频道媒体选项并设置 publishScreenCaptureVideo 为 true，即可开始屏幕共享。
    int success=  [[HDVECAgoraCallManager shareInstance].agoraKit startScreenCapture:[HDVECAgoraCallManager shareInstance].screenCaptureParams];
    NSLog(@"====success=%d",success);
    AgoraRtcChannelMediaOptions * option = [AgoraRtcChannelMediaOptions new];
    option.publishScreenCaptureVideo = YES;
    //这个属性必须设置 要不 屏幕共享的流推不出去
    option.publishCameraTrack = NO;
   
    int updateSuccess=  [[HDVECAgoraCallManager shareInstance].agoraKit updateChannelWithMediaOptions:option];
    NSLog(@"====updateSuccess=%d",updateSuccess);
    // 发送通知 屏幕共享开始了
    [[NSNotificationCenter defaultCenter] postNotificationName:HDVEC_SCREENSHARE_STATRT object:nil];
}

- (void)vec_stopAgoraScreenCapture{

    int success=  [[HDVECAgoraCallManager shareInstance].agoraKit stopScreenCapture];
    NSLog(@"====stopScreenCapture=%d",success);
    AgoraRtcChannelMediaOptions * option = [AgoraRtcChannelMediaOptions new];
    option.publishScreenCaptureVideo = NO;
    //这个属性必须设置 要不 屏幕共享的流推不出去
    option.publishCameraTrack = YES;

    int updateSuccess=  [[HDVECAgoraCallManager shareInstance].agoraKit updateChannelWithMediaOptions:option];

    NSLog(@"====updateChannelWithMediaOptions=%d",updateSuccess);
    
    // 发送通知 屏幕共享停止了
    [[NSNotificationCenter defaultCenter] postNotificationName:HDVEC_SCREENSHARE_STOP object:nil];
    
}

#pragma mark - 进程间通信-CFNotificationCenterGetDarwinNotifyCenter 使用之前，需要为container app与extension app设置 App Group，这样才能接收到彼此发送的进程间通知。
// 录屏直播 主App和宿主App数据共享，通信功能实现 如果我们要将开始、暂停、结束这些事件以消息的形式发送到宿主App中，需要使用CFNotificationCenterGetDarwinNotifyCenter。
- (void)vec_setupUserDefaults{

    // 如果需要app 内 设置监听 
    if (self.isApp) {
        [self setupNotifiers];
    }

    self.userDefaults =[[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
    // 通过UserDefaults建立数据通道，接收Extension传递来的视频帧
    [self.userDefaults setObject:@{@"state":@"x"} forKey:kUserDefaultState];//给状态一个默认值
    [self.userDefaults addObserver:self forKeyPath:kUserDefaultState options:NSKeyValueObservingOptionNew context:KVOContext];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kUserDefaultState]) {
        NSDictionary *string = change[NSKeyValueChangeNewKey];
        if ([string[@"state"] isEqual:@"broadcastStarted"]) {
            self.shareStatus = YES;
            //开启 RTC：外部视频输入通道，开始推送屏幕流（configLocalScreenPublish）
            NSLog(@"== 屏幕分享开始=====%@",string);
            // 开启屏幕共享
            [self vec_startAgoraScreenCapture];
        }
        if ([string[@"state"] isEqual:@"broadcastFinished"]) {
            self.shareStatus = NO;
            //关闭 RTC：外部视频输入通道，停止推送屏幕流
            NSLog(@"== 屏幕分享停止=====%@",string);
            [self vec_stopAgoraScreenCapture];
        }
        return;
    }
}
// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    // 进入后台
    NSLog(@"=========appDidEnterBackgroundNotif==============");
    if (self.shareStatus&& self.isApp) {
    if (@available(iOS 11.0, *)) {
        [[AgoraReplayKitExt shareInstance] stop];
    } else {
        // Fallback on earlier versions
    }
        [self vec_stopAgoraScreenCapture];
    }
   
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    // 进入前台
    NSLog(@"=========appDidBecomeActiveNotif==============");
    if (self.shareStatus && self.isApp) {

        [self vec_startAgoraScreenCapture];
    }
    
}



@end
