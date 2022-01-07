//
//  AgoraViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/5.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "AgoraViewController.h"
#import <HelpDesk/HelpDesk.h>

@interface AgoraViewController ()<HDAgoraCallManagerDelegate>
{
    
    NSUInteger _remoteuid;
    
}
// 定义 localView 变量
@property (nonatomic, strong) UIView *localView;
// 定义 remoteView 变量
@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) UIView *remoteView1;
@end

@implementation AgoraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    // 调用初始化视频窗口函数
       [self initViews];
    [self initializeAgoraEngine];
    [self setupLocalVideo];
    [self joinChannel];
   
}
- (void)initializeAgoraEngine {
    
    // 设置音视频 options
    HDAgoraCallOptions *options = [[HDAgoraCallOptions alloc] init];
    options.videoOff = NO; // 这个值要和按钮状态统一。
    options.mute = NO; // 这个值要和按钮状态统一。
//    options.previewView = (HDCallLocalView *)item.camView; // 设置自己视频时使用的view
    options.localView = self.localView;
    options.remoteView = self.remoteView;
    
    [[HDClient sharedClient].agoraCallManager setCallOptions:options];

    [[HDClient sharedClient].agoraCallManager loadAgoraInit];
}
- (void)setupLocalVideo {
    HDAgoraRtcVideoCanvas *videoCanvas = [[HDAgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 12334444444;
    videoCanvas.view = self.localView;
    [[HDClient sharedClient].agoraCallManager setupLocalVideo:videoCanvas];
    // Bind local video stream to view
    [[HDClient sharedClient].agoraCallManager startPreview];
}

- (void)joinChannel {
    [[HDClient sharedClient].agoraCallManager hdjoinChannelByToken:nil channelId:nil info:nil uid:0 joinSuccess:nil];
    [[HDClient sharedClient].agoraCallManager setEnableSpeakerphone:YES];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
// 设置视频窗口布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
}
- (void)initViews {
    // 初始化远端视频窗口
    self.remoteView = [[UIView alloc] init];
    [self.view addSubview:self.remoteView];
    // 初始化本地视频窗口
    self.localView = [[UIView alloc] init];
    [self.view addSubview:self.localView];
    self.remoteView.frame = self.view.bounds;
    self.localView.frame = CGRectMake(self.view.bounds.size.width - 90, 0, 90, 160);
    self.remoteView1 = [[UIView alloc] init];
    self.remoteView1.frame = CGRectMake(self.view.bounds.size.width - 90, 180, 90, 160);
    [self.view addSubview:self.remoteView1];
    [[HDClient sharedClient].agoraCallManager addDelegate:self delegateQueue:nil];
    [self setupButtons];
}
- (void)setupButtons {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, self.view.size.height - 148, 88, 88);
    [btn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(88 +20, self.view.size.height - 148, 88, 88);
    [btn1 setImage:[UIImage imageNamed:@"video on.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pauseVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(88 +20 + 88, self.view.size.height - 148, 88, 88);
    [btn2 setImage:[UIImage imageNamed:@"mac on.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(pauseVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(88 +20 + 88 + 88, self.view.size.height - 148, 88, 88);
    [btn3 setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(endCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(88 +20 + 88 + 88 + 88, self.view.size.height - 148, 88, 88);
    [btn4 setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(speakerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

/// 切换摄像头
- (void)switchCamera{
    [[HDClient sharedClient].agoraCallManager switchCamera];
}

/// 关闭本地视频
- (void)pauseVideo:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.localView.hidden = YES;
        [[HDClient sharedClient].agoraCallManager pauseVideo];
    } else {
        [[HDClient sharedClient].agoraCallManager resumeVideo];
        self.localView.hidden = NO;
    }
}

/// 关闭音频
- (void)pauseVoice:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDClient sharedClient].agoraCallManager pauseVoice];
    } else {
        [[HDClient sharedClient].agoraCallManager resumeVoice];
    }
}
/// 扬声器事件
- (void)speakerBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    [[HDClient sharedClient].agoraCallManager setEnableSpeakerphone:btn.selected];
}

///  Leave the channel and handle UI change when it is done.
- (void) endCall{
    [[HDClient sharedClient].agoraCallManager  endCall];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.remoteView removeFromSuperview];
    [self.localView removeFromSuperview];
}

#pragma mark - HDAgoraCallManagerDelegate

- (void)hd_rtcEngine:(HDAgoraCallManager *)agoraCallManager didOccurError:(HDError *)error{
    
    NSLog(@"Occur error%d",error.code);
}

-(void)hd_rtcEngine:(HDAgoraCallManager *)agoraCallManager didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{

    if (self.remoteView.hidden) {
        self.remoteView.hidden = NO;
    }
    
    if (_remoteuid > 0 ) {
        HDAgoraRtcVideoCanvas *videoCanvas = [[HDAgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = uid;
        videoCanvas.view = self.remoteView;
        [[HDClient sharedClient].agoraCallManager setupRemoteVideo:videoCanvas];
        // Bind local video stream to view
        [[HDClient sharedClient].agoraCallManager startPreview];
    }else{
        _remoteuid = uid;
        
        HDAgoraRtcVideoCanvas *videoCanvas = [[HDAgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = uid;
        videoCanvas.view = self.remoteView1;
        [[HDClient sharedClient].agoraCallManager setupRemoteVideo:videoCanvas];
        // Bind local video stream to view
        [[HDClient sharedClient].agoraCallManager startPreview];
    }
    
    NSLog(@"远端视频进来了uid = %lu",(unsigned long)uid);
    
}
- (void)hd_rtcEngine:(HDAgoraCallManager *)agoraCallManager didOfflineOfUid:(NSUInteger)uid reason:(HDAgoraUserOfflineReason)reason{
    
    self.remoteView.hidden = YES;
    
}



@end
