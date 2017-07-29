//
//  HDCallViewController.m
//  HRTCDemo
//
//  Created by afanda on 7/26/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDCallViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HDCallViewController ()<HDCallBackViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView; //背景图

//label
@property (weak, nonatomic) IBOutlet UILabel *inviterLabel; //邀请人
@property (weak, nonatomic) IBOutlet UILabel *promptLabel; //提示语
@property (weak, nonatomic) IBOutlet UILabel *timerLabel; //计时器

//menu
@property (weak, nonatomic) IBOutlet UIView *menuBackView;

@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;

//进入与否

@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangUpBtn;

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;


@end

@implementation HDCallViewController
{
    EMediaSession *_currentSession;
    
    HDCallBackView *_localBackView;
    EMCallLocalView *_localView;
    
    //计时
    NSTimer *_timer;
    int _timeLength;
}

- (instancetype)initWithSession:(EMediaSession *)session {
    NSString *xib = @"HDCallViewController";
    self = [super initWithNibName:xib bundle:nil];
    if (self) {
        _currentSession = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 收到消息时，播放音频
    [[HDCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[HDCDDeviceManager sharedInstance] playVibration];
}

#pragma mark - videoView

- (void)setLocalView {
    _localBackView = [[HDCallBackView alloc] initWithFrame:CGRectMake(0, 0, KWH, KWH)];
    [_localBackView addSubviewRestoreBtn];
    [_localBackView addSubviewNameLabel];
    _localBackView.nameLabel.text = @"我是一只丑小鸭";
    _localBackView.delegate = self;
    _localView = [[EMCallLocalView alloc] initWithFrame:_localBackView.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(localViewClicked)];
    [_localView addGestureRecognizer:tap];
    _localView.scaleMode = EMCallViewScaleModeAspectFill;
    _localView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_localBackView addSubview:_localView];
    [_localBackView bringSubviewToFront:_localBackView.nameLabel];
    [self.view addSubview:_localBackView];
    [[EMediaManager shared] setLocalPreviewView:_localView];
}

- (void)localViewClicked {
    _localBackView.frame = [UIScreen mainScreen].bounds;
    _localView.scaleMode = EMCallViewScaleModeAspectFit;
    [self showOneVideoBackView:_localBackView];
}

- (void)restoreBtnClicked {
    _localBackView.frame = CGRectMake(0, 0, KWH, KWH);
    _localView.scaleMode = EMCallViewScaleModeAspectFill;
    _localBackView.restoreBtn.hidden = YES;
    [[HDCallManager sharedInstance] reLayoutVideos];
}



#pragma mark BottomMenu

- (IBAction)switchBtnClicked:(id)sender {
    UIButton *btn = sender;
    _switchBtn.selected = !btn.selected;
    [[EMediaManager shared] switchCamera];
}
- (IBAction)micBtnClicked:(id)sender {
    UIButton *btn = sender;
    _micBtn.selected = !btn.selected;
    [[EMediaManager shared] setMuteEnabled:_micBtn.selected];
}


- (IBAction)voiceBtnClicked:(id)sender {
    UIButton *btn = sender;
    _voiceBtn.selected = !btn.selected;
    [[HDCallManager sharedInstance] setSpeakEnable:!_voiceBtn.selected];
}

- (IBAction)videoBtnClicked:(id)sender {
    UIButton *btn = sender;
    _videoBtn.selected = !btn.selected;
    [[EMediaManager shared] setVideoEnabled:!_videoBtn.selected];
}
//拒绝
- (IBAction)rejectBtnClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCallManager sharedInstance] exit:_currentSession onDone:^(id obj, EMediaError *error) {
            if (error == nil) {
                NSLog(@"离开会话成功");
            }
        }];
    });
}

//挂断
- (IBAction)hungupBtnClicked:(id)sender {
    [self stopTimeTimer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCallManager sharedInstance] exit:_currentSession onDone:^(id obj, EMediaError *error) {
            if (error == nil) {
                NSLog(@"离开会话成功");
            }
        }];
    });
}


//接受视频邀请
- (IBAction)acceptBtnClicked:(id)sender {
    _acceptBtn.hidden = YES;
    [self setAudioSessionSpeaker];
    CGPoint center = _rejectBtn.center;
    center.x = kScreenWidth/2;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _rejectBtn.center = center;
    } completion:^(BOOL finished) {
        _timerLabel.hidden = NO;
        [[HDCallManager sharedInstance] acceptVideoRequest];
         [self startRecordTime];
        _rejectBtn.hidden = YES;
        _hangUpBtn.hidden = NO;
        _menuBackView.hidden = NO;
        [self setLocalView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[HDCallManager sharedInstance] publish:_currentSession publishConfig:[self getcConfig] onDone:^(id obj, EMediaError *error) {
                if (error == nil) {
                    NSLog(@"发布流成功");
                }
            }];
        });
    }];
}




#pragma mark - updateUI


- (void)addStreamWithHDMemberObj:(HDMemberObject *)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:obj.remoteVideoItem.backView];
    });
}


- (void)layoutVideosWithMembers:(NSArray *)members {
    NSInteger memberCount = members.count;
    if (memberCount<1) {
        return;
    }
    for (int i=1; i<=memberCount; i++) {
        CGFloat x = i%2 * KWH;
        CGFloat y = i/2 * KWH;
        CGRect frame = CGRectMake(x, y, KWH, KWH);
        HDMemberObject *item = members[i-1];
        item.remoteVideoItem.scaleMode = EMCallViewScaleModeAspectFill;
        item.isFull = NO;
        item.remoteVideoItem.backView.restoreBtn.hidden = YES;
        item.remoteVideoItem.backView.frame = frame;
        
    }
}

- (void)showOneVideoBackView:(HDCallBackView *)backView {
    [backView bringSubviewToFront:backView.restoreBtn];
    [backView bringSubviewToFront:backView.nameLabel];
    backView.restoreBtn.hidden = NO;
    backView.frame = [UIScreen mainScreen].bounds;
    [self.view bringSubviewToFront:backView];
    [self showBottomMenu];
}

- (void)showBottomMenu {
    [self.view bringSubviewToFront:_hangUpBtn];
    [self.view bringSubviewToFront:_menuBackView];
}


//开始计时
- (void)startRecordTime
{
    _promptLabel.text = @"多人视频通话中";
    _timeLength = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

//结束计时
- (void)stopTimeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    if (hour > 0) {
        _timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, m, s];
    } else {
        _timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - private

- (EMediaPublishConfiguration *)getcConfig {
    EMediaPublishConfiguration *config = [[EMediaPublishConfiguration alloc] init];
    config.videoOff = NO;
    config.mute = NO;
    config.extension = @"";
    return config;
}

//扬声器模式
-(void)setAudioSessionSpeaker
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
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
