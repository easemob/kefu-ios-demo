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
@property (weak, nonatomic) IBOutlet UIButton *shareViewBtn;

//进入与否

@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangUpBtn;

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;


@end

@implementation HDCallViewController
{
    
    HDCallBackView *_localBackView;
    HCallLocalView *_localView;
    
    //计时
    NSTimer *_timer;
    int _timeLength;
    //响应
    NSCondition *_condition;
    BOOL _isOperate; //访客是否操作
}

- (instancetype)init {
    NSString *xib = @"HDCallViewController";
    self = [super initWithNibName:xib bundle:nil];
    if (self) {
        _isOperate = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    _inviterLabel.text = _nickname;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _condition = [[NSCondition alloc] init];
        [_condition lock];
        [_condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:60]];
        if (_isOperate == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"长时间未接听,挂断"];
                [[HDCallManager sharedInstance] exitSession];
            });
        }
        [_condition unlock];
    });
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark - videoView

- (void)setLocalView {
    _localBackView = [[HDCallBackView alloc] initWithFrame:CGRectMake(0, 0, KWH, KWH)];
    [_localBackView addSubviewRestoreBtn];
    [_localBackView addSubviewNameLabel];
    _localBackView.nameLabel.text = [CSDemoAccountManager shareLoginManager].nickname;
    _localBackView.delegate = self;
    _localView = [HDCallManager sharedInstance].localView;
    _localView.frame = _localBackView.bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(localViewClicked)];
    [_localView addGestureRecognizer:tap];
    _localView.scaleMode = EMCallViewScaleModeAspectFill;
    _localView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_localBackView addSubview:_localView];
    [_localBackView bringSubviewToFront:_localBackView.nameLabel];
    [self.view addSubview:_localBackView];
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

//旋转摄像头
- (IBAction)switchBtnClicked:(id)sender {
    UIButton *btn = sender;
    _switchBtn.selected = !btn.selected;
    [[HChatClient sharedClient].callManager switchCamera];
}
- (IBAction)shareViewBtnClicked:(id)sender {
    UIButton *btn = sender;
    BOOL isSelected = btn.selected;
    if(!isSelected){
        [[HChatClient sharedClient].callManager publishWindow:self.view completion:^(id obj, HError * error) {
            if(error){
                NSLog(@"desktop shared fail, error: %@", error.errorDescription);
            }else{
                NSLog(@"desktop shared success.");
            }
        }];
    }else{
        [[HChatClient sharedClient].callManager unPublishWindowWithCompletion:^(id obj, HError * error) {
            if(error){
                NSLog(@" unpublish failed., error: %@", error.errorDescription);
            }else{
                NSLog(@" unpublish success.");
            }
        }];
    }
    
    _shareViewBtn.selected = !btn.selected;
    
    
}

//开关mic
- (IBAction)micBtnClicked:(id)sender {
    UIButton *btn = sender;
    _micBtn.selected = !btn.selected;
    if (_micBtn.selected) {
        [[HChatClient sharedClient].callManager pauseVoice];
    } else {
        [[HChatClient sharedClient].callManager resumeVoice];
    }
}

//开关喇叭
- (IBAction)voiceBtnClicked:(id)sender {
    UIButton *btn = sender;
    _voiceBtn.selected = !btn.selected;
    [[HDCallManager sharedInstance] setSpeakEnable:!_voiceBtn.selected];
}

//开关自己视频
- (IBAction)videoBtnClicked:(id)sender {
    UIButton *btn = sender;
    _videoBtn.selected = !btn.selected;
    if (_videoBtn.selected) {
        [[HChatClient sharedClient].callManager pauseVideo];
    } else {
        [[HChatClient sharedClient].callManager resumeVideo];
    }
}

//拒绝
- (IBAction)rejectBtnClicked:(id)sender {
    [_condition lock];
    _isOperate = YES;
    [_condition signal];
    [_condition unlock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCallManager sharedInstance] endCall];
    });
}

//挂断
- (IBAction)hungupBtnClicked:(id)sender {
    [self stopTimeTimer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [[HDCallManager sharedInstance] endCall];
    });
}


//接受视频邀请
- (IBAction)acceptBtnClicked:(id)sender {
    [_condition lock];
    _isOperate = YES;
    [_condition signal];
    [_condition unlock];
    _acceptBtn.hidden = YES;
    [self setAudioSessionSpeaker];
    CGPoint center = _rejectBtn.center;
    center.x = kScreenWidth/2;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.rejectBtn.center = center;
    } completion:^(BOOL finished) {
        weakSelf.timerLabel.hidden = NO;
         [self startRecordTime];
        weakSelf.rejectBtn.hidden = YES;
        weakSelf.hangUpBtn.hidden = NO;
        weakSelf.menuBackView.hidden = NO;
        [self setLocalView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[HDCallManager sharedInstance] acceptCallWithNickname:[CSDemoAccountManager shareLoginManager].nickname completion:^(id obj, HError * error) {
                if (error == nil) {
                    NSLog(@"acceptCall Success!");
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

//扬声器模式
-(void)setAudioSessionSpeaker
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
}

- (void)passiveCloseSessionTip:(NSString *)tip {
    [self showHint:tip];
    _isOperate = YES;
    [_condition  signal];
}

- (void)dealloc {
    _condition = nil;
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
