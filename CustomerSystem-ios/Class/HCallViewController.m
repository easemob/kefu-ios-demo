//
//  HCallViewController.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 3/20/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HCallViewController.h"
#import "HCallManager.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, BottomMenuTag) {
    BottomMenuTagSwitchCamera = 100,
    BottomMenuTagSwitchMic,
    BottomMenuTagSwitchHorn,
    BottomMenuTagSwitchVideo
};

typedef NS_ENUM(NSUInteger, DeviceOrientation) {
    DeviceOrientationCustom=124,
    DeviceOrientationLR,
};

@interface HCallViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;    //客服昵称
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;      //给访客的提醒
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        //计时
@property (weak, nonatomic) IBOutlet UIButton *switchButton;    //镜头转换
@property (weak, nonatomic) IBOutlet UIButton *micButton;       //麦克开关
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;     //喇叭开关

@property (weak, nonatomic) IBOutlet UIButton *videoButton;     //视频开关
@property (weak, nonatomic) IBOutlet UIButton *hangupButton; //主动挂断

@property (weak, nonatomic) IBOutlet UIButton *rejectButton;    //拒绝请求
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;    //接受请求

@property (nonatomic) int timeLength;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (weak, nonatomic) IBOutlet UILabel *closeSelfVideoLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeSelfVideoBtn;

@end

@implementation HCallViewController
{
    HCall *_callManager;
    AppDelegate *_appDelegate;
    DeviceOrientation _currentOrientation;
}


- (instancetype)initWithCallSession:(HCallSession *)aCallSession {
    NSString *xibName = @"HCallViewController";
    self = [super initWithNibName:xibName bundle:nil];
    if (self) {
        _callManager = [HChatClient sharedClient].call;
        _callSession = aCallSession;
        _isDismissing = NO;
        _hangupButton.hidden = YES;
        _timeLabel.hidden = YES;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.callSession.remoteVideoView && self.closeSelfVideoBtn.hidden){
        
        if(self.nickNameLabel.hidden){
            self.nickNameLabel.hidden = NO;
            self.remindLabel.hidden = NO;
            self.timeLabel.hidden = NO;
            self.switchButton.hidden = NO;
            self.micButton.hidden = NO;
            self.voiceButton.hidden = NO;
            self.videoButton.hidden = NO;
            self.hangupButton.hidden = NO;
            [self.callSession.remoteVideoView setScaleMode:EMCallViewScaleModeAspectFit];
        }else{
            self.nickNameLabel.hidden = YES;
            self.remindLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            self.switchButton.hidden = YES;
            self.micButton.hidden = YES;
            self.voiceButton.hidden = YES;
            self.videoButton.hidden = YES;
            self.hangupButton.hidden = YES;
            [self.callSession.remoteVideoView setScaleMode:EMCallViewScaleModeAspectFill];
        }
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentOrientation = DeviceOrientationCustom;
    _appDelegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _appDelegate.allowRotation = YES;
    [self addNoti];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _appDelegate.allowRotation = NO;
    [self removeNoti];
}

- (void)addNoti {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeNoti {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isDismissing) {
        return;
    }
    HCallOptions * callOptions = [[HChatClient sharedClient].call getCallOptions];
    callOptions.videoResolution = HCallVideoResolution640_480;
    callOptions.isFixedVideoResolution = YES;
    callOptions.minVideoKbps = 200;
    [[HChatClient sharedClient].call setCallOptions:callOptions];
    
    [self setup];
}

- (void)setup {
    self.nickNameLabel.text = self.callSession.remoteName;
    switch (self.callSession.type) {
        case HCallTypeVoice: {
            self.videoButton.enabled = NO;
            break;
        }
        case HCallTypeVideo: {
            break;
        }
        default:
            break;
    }
    self.closeSelfVideoLabel.hidden = NO;
    self.closeSelfVideoBtn.hidden = NO;
    self.closeSelfVideoBtn.selected = YES;
    self.videoButton.selected = YES;
    
}

- (IBAction)CloseSelfVideoBtnClicked:(id)sender {
    if(self.closeSelfVideoBtn.selected){
        self.closeSelfVideoBtn.selected = NO;
        self.videoButton.selected = NO;
    }else{
        self.closeSelfVideoBtn.selected = YES;
        self.videoButton.selected = YES;
    }
}


//镜头转换、麦克风开关、喇叭开关、视频开关{tag:100、101、102、103}
- (IBAction)BottomMenuClicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    BottomMenuTag menuTag = btn.tag;
    switch (menuTag) {
        case BottomMenuTagSwitchCamera:{ //切换前后镜头
            [self.callSession switchCameraPosition:btn.isSelected];
            break;
        }
        case BottomMenuTagSwitchMic: { //开关麦克风
            if (self.micButton.selected) {
                [self.callSession pauseVoice];
            } else {
                [self.callSession resumeVoice];
            }
            break;
        }
        case BottomMenuTagSwitchHorn: { //开关喇叭
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if (self.voiceButton.selected) {
                [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            }else {
                [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            }
            [audioSession setActive:YES error:nil];
            break;
        }
        case BottomMenuTagSwitchVideo: { //开关视频
            if (self.videoButton.selected) {
                self.closeSelfVideoBtn.selected = NO;
                [self.callSession pauseVideo];
            } else {
                [self.callSession resumeVideo];
                self.closeSelfVideoBtn.selected = YES;
            }
            break;
        }
        default:
            break;
    }
    
}

//主动挂断视频通话
- (IBAction)hangupCilcked:(id)sender {
    [_callManager endCall:self.callSession.callId reason:HCallEndReasonHangup];
}

//拒绝客服视频请求
- (IBAction)rejectCallRequest:(id)sender {
    [_callManager endCall:self.callSession.callId reason:HCallEndReasonDecline];
}

//接受客服视频请求
- (IBAction)acceptCallRequest:(id)sender {
//    [[HCallManager sharedInstance] answerCall:self.callSession.callId];
    [[HCallManager sharedInstance] answerCall:self.callSession.callId enableVideo:(!self.closeSelfVideoBtn.selected)];
}

//通道已经建立
- (void)stateToConnected {
    [self remindVisitor:@"已连接"];
    [self setupRemoteVideoView];
    [self setupLocalVideoView];
}


//视频已经连通
- (void)didConnected {
    [self remindVisitor:@"可以说话了"];
    self.timeLabel.hidden = NO;
    if (self.callSession.type == HCallTypeVideo) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [audioSession setActive:YES error:nil];
    }
    self.timeLabel.hidden = NO;
    self.hangupButton.hidden = NO;
    self.rejectButton.hidden = YES;
    self.acceptButton.hidden = YES;
    
    self.closeSelfVideoLabel.hidden = YES;
    self.closeSelfVideoBtn.hidden = YES;
    
    
}


//设置客服视频窗口
- (void)setupRemoteVideoView
{
    if (self.timeLength <= 0) {
        [self startRecordTime];
    }
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (self.callSession.remoteVideoView != nil) {
        self.callSession.remoteVideoView.frame = frame;
    } else {
        self.callSession.remoteVideoView = [[HCallRemoteView alloc] initWithFrame:frame];
    }
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView.backgroundColor = [UIColor clearColor];
    self.callSession.remoteVideoView.scaleMode = HCallViewScaleModeAspectFill;
    [self.view addSubview:self.callSession.remoteVideoView];
    [self.view sendSubviewToBack:self.callSession.remoteVideoView];
    
    __weak HCallViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.callSession.remoteVideoView.hidden = NO;
    });
}

//设置本地视频窗口
- (void)setupLocalVideoView
{
    CGFloat w =  80;
    CGFloat h = kScreenHeight / kScreenWidth * w;
    CGRect frame = CGRectMake(kScreenWidth - w -20, 20, w, h);
    if (_currentOrientation == DeviceOrientationLR) {
        h = kScreenWidth/kScreenHeight * w;
        frame = CGRectMake(20, kScreenHeight - 20 - w, h, w);
    }
    if (self.callSession.localVideoView != nil) {
        self.callSession.localVideoView.frame = frame;
    } else {
        self.callSession.localVideoView = [[HCallLocalView alloc] initWithFrame:frame];
    }
    [self.view addSubview:self.callSession.localVideoView];
    [self.view bringSubviewToFront:self.callSession.localVideoView];
}

//开始计时
- (void)startRecordTime
{
    self.timeLength = 0;
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, m, s];
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
}



//数据传输状态改变
- (void)setStatusWithStatus:(HCallStreamingStatus)status {
    NSString *remind = @"";
    switch (status) {
        case HCallStreamStatusVoicePause: { //语音中断
            remind = @"客服语音已经中断...";
            break;
        }
        case HCallStreamStatusVoiceResume: { //语音重连
            remind = @"客服语音已经重连";
            break;
        }
        case HCallStreamStatusVideoPause: { //视频中断
            remind = @"客服视频已经中断...";
            break;
        }
        case HCallStreamStatusVideoResume: { //视频重连
            remind = @"客服视频已经重连";
            break;
        }
        default:
            break;
    }
    [self remindVisitor:remind];
}

//网络状态改变
- (void)setNetworkWithNetworkStatus:(HCallNetworkStatus)status {
    NSString *remind = @"";
    switch (status) {
        case HCallNetworkStatusNormal: { //网络正常
            remind = @"正在与客服进行视频通话";
            break;
        }
        case HCallNetworkStatusUnstable: { //网络不稳定
            remind = @"当前网络不稳定";
            break;
        }
        case HCallNetworkStatusNoData: { //网络连接中断
            remind = @"当前网络已经中断";
            break;
        }
        default:
            break;
    }
    [self remindVisitor:remind];
}

- (void)clearData {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView = nil;
    _callSession = nil;
    
    [self stopTimeTimer];
}


//private
- (void)remindVisitor:(NSString *)remind {
    self.remindLabel.text = remind;
}

- (void)stopTimeTimer
{
    if (self.timeTimer) {
        [self.timeTimer invalidate];
        self.timeTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changeOrientation {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation==UIDeviceOrientationFaceUp || orientation==UIDeviceOrientationFaceDown
       || orientation == UIDeviceOrientationPortraitUpsideDown)
        return;
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            _currentOrientation = DeviceOrientationLR;
            break;
        }
        default:
            _currentOrientation = DeviceOrientationCustom;
            break;
    }
    [self refreshVideoView];
}
- (void)refreshVideoView {
    [self setupRemoteVideoView];
    [self setupLocalVideoView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
