//
//  HCallManager.m
//  CustomerSystem-ios
//
//  Created by afanda on 3/20/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HCallManager.h"
#import "HCallViewController.h"

@interface HCallManager ()<HCallManagerDelegate>

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) HCallSession *currentSession;

@property(nonatomic,strong) HCallViewController *currentCallVC;

@end

@implementation HCallManager

static HCallManager *_manager = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HCallManager alloc] init];
    });
    return _manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initManager];
    }
    
    return self;
}
- (void)initManager
{
    _currentSession = nil;
    _currentCallVC = nil;
    [[HChatClient sharedClient].call addDelegate:self delegateQueue:nil];
}


#pragma mark - HCallManagerDelegate

//收到一个视频通话请求
- (void)callDidReceive:(HCallSession *)aSession {
    NSLog(@"接到一个视频通话请求");
    if (!aSession || [aSession.callId length] == 0) {
        return ;
    }
    if ([HDSDKHelper shareHelper].isShowingimagePicker) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideImagePicker" object:nil];
    }
    if(self.currentSession && self.currentSession.status != HCallSessionStatusDisconnected){
        [[HChatClient sharedClient].call endCall:aSession.callId reason:HCallEndReasonBusy];
        return;
    }
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    [self playSoundAndVibration];
    if (!isAppActivity) {
        [self showLocalNoti];
    }
    @synchronized (self) {
        self.currentSession = aSession;
        self.currentCallVC = [[HCallViewController alloc] initWithCallSession:self.currentSession];
        self.currentCallVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        
    }
    
}

//通话通道建立完成
- (void)callDidConnect:(HCallSession *)aSession {
    NSLog(@"视频通话通道建立完成");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.currentCallVC stateToConnected];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.currentCallVC) {
                [self.mainViewController presentViewController:self.currentCallVC animated:NO completion:nil];
            }
        });
    }
}

//视频通话已经结束
- (void)callDidEnd:(HCallSession *)aSession reason:(HCallEndReason)aReason error:(HError *)aError {
    NSLog(@"视频通话已经结束");
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        @synchronized (self) {
            self.currentSession = nil;
            [self clearCurrentCallViewAndData];
        }
        
        if (aReason != HCallEndReasonHangup) {
            NSString *reasonStr = @"end";
            switch (aReason) {
                case HCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"the_other_party_no_response", @"The other party no response");
                }
                    break;
                case HCallEndReasonDecline:
                {
                    reasonStr = NSLocalizedString(@"the_other_party_refuses_to", @"The other party refuses to");
                }
                    break;
                case HCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"the_other_is_busy", @"The other is busy...");
                }
                    break;
                case HCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"the_connection_fails", @"The connection fails");
                }
                    break;
                case HCallEndReasonUnsupported:
                {
                    reasonStr = NSLocalizedString(@"the_function_is_not_supported", @"The function is not supported");
                }
                    break;
                case HCallEndReasonRemoteOffline:
                {
                    reasonStr = NSLocalizedString(@"each_other_offline", @"Each other offline");
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

//视频通话,对方数据流状态改变
- (void)callStateDidChange:(HCallSession *)aSession type:(HCallStreamingStatus)aType {
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
                [self.currentCallVC setStatusWithStatus:aType];
            }
}

//视频通话,自己网络状态发生变化
- (void)callNetworkDidChange:(HCallSession *)aSession status:(HCallNetworkStatus)aStatus {
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.currentCallVC setNetworkWithNetworkStatus:aStatus];
    }
}

- (void)clearCurrentCallViewAndData
{
    @synchronized (self) {
        self.currentSession = nil;
        
        self.currentCallVC.isDismissing = YES;
        [self.currentCallVC clearData];
        [self.currentCallVC dismissViewControllerAnimated:NO completion:nil];
        self.currentCallVC = nil;
    }
}

- (void)answerCall:(NSString *)aCallId
{
    if (!self.currentSession || ![self.currentSession.callId isEqualToString:aCallId]) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HError *error = [[HChatClient sharedClient].call answerIncomingCall:weakSelf.currentSession.callId];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == HErrorNetworkUnavailable) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"the_network_is_not_available", @"The network is not available") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"Ok") otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else{
                    [weakSelf hangupCallWithReason:HCallEndReasonFailed];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.currentCallVC didConnected];
            });
        }
    });
}



- (void)hangupCallWithReason:(HCallEndReason)aReason
{
    
    if (self.currentSession) {
        [[HChatClient sharedClient].call endCall:self.currentSession.callId reason:aReason];
    }
    [self clearCurrentCallViewAndData];
}

- (void)showLocalNoti {
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = @"您有一个新的视频请求";
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
}

- (void)playSoundAndVibration
{

    // 收到消息时，播放音频
    [[HDCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[HDCDDeviceManager sharedInstance] playVibration];
}

@end




