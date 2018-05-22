//
//  HCallViewController.m
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/8.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import "HCallViewController.h"
#import "HCallViewCollectionViewCell.h"
#import <HelpDesk/HelpDesk.h>

#define kCamViewTag 100001

@interface HCallViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HCallManagerDelegate> {
    NSMutableArray *_members; // 通话人
    NSTimer *_timer;
    NSInteger _time;
}
@property (nonatomic, strong) NSString *agentName;

@property (weak, nonatomic) IBOutlet UIView *callingView; // 通话中展示的view
@property (weak, nonatomic) IBOutlet UIView *callinView;  // 呼入时展示的view

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;  // 正在通话中...(人数)
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  // 时间 00:00:00

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; // 显示头像

@property (weak, nonatomic) IBOutlet UIButton *camBtn;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *speakerBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareDeskTopBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBtn;
@property (weak, nonatomic) IBOutlet UIButton *offBtn;


@end

@implementation HCallViewController

+ (HCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName {
    HCallViewController *callVC = [[HCallViewController alloc] initWithNibName:@"HCallViewController" bundle:nil];
    callVC.agentName = aAgentName;
    return callVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange)
                                                name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // 初始化数据源
    _members = [NSMutableArray array];
    HCallViewCollectionViewCellItem *item = [[HCallViewCollectionViewCellItem alloc] initWithAvatarURI:@"url"
                                                                                          defaultImage:[UIImage imageNamed:@"off"]
                                                                                              nickname:@"自己"];
    item.isSelected = YES;
    item.memberName = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    item.camView = [[HCallLocalView alloc] init];
    [_members addObject:item];
    [self updateInfoLabel];
    
    // 设置音视频 options
    HCallOptions *options = [[HCallOptions alloc] init];
    options.videoOff = NO; // 这个值要和按钮状态统一。
    options.mute = NO; // 这个值要和按钮状态统一。
    options.previewView = (HCallLocalView *)item.camView;
    [[HChatClient sharedClient].callManager setCallOptions:options];
    [HChatClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    
    // 设置 ui
    [self.view setBackgroundColor:UIColor.blackColor];
    [self.infoLabel setHidden:YES];
    [self.timeLabel setHidden:YES];
    [self.callingView setHidden:YES];
    [self.collectionView reloadData];
    
    // 响铃
    [self startRing];
    
    // 设置 collectionView 第一项
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
}

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"HCallViewCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cellid"];
}

// 监听屏幕方向变化
- (void)handleStatusBarOrientationChange {
    EMCallRemoteView *view = (EMCallRemoteView *)[self.view viewWithTag:kCamViewTag];
    view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
    view.frame = UIScreen.mainScreen.bounds;
}

// 添加member
- (HCallViewCollectionViewCellItem *)createCallerWithMember:(HCallMember *)aMember {
    HCallViewCollectionViewCellItem *item = [[HCallViewCollectionViewCellItem alloc] initWithAvatarURI:aMember.extension[@"avatarUrl"] defaultImage:[UIImage imageNamed:@"off"] nickname:aMember.extension[@"nickname"]];
    item.memberName = aMember.memberName;
    return item;
}

// 更新详情显示
- (void)updateInfoLabel {
    self.infoLabel.text = [NSString stringWithFormat:@"正在通话中...(%d)",(int)_members.count];
}

// 旋转摄像头事件
- (IBAction)camBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[HChatClient sharedClient].callManager switchCamera];
}

// 静音事件
- (IBAction)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HChatClient sharedClient].callManager pauseVoice];
    } else {
        [[HChatClient sharedClient].callManager resumeVoice];
    }
}

// 停止发送视频流事件
- (IBAction)videoBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HChatClient sharedClient].callManager pauseVideo];
    } else {
        [[HChatClient sharedClient].callManager resumeVideo];
    }
}

// 扬声器事件
- (IBAction)speakerBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession overrideOutputAudioPort:btn.selected ? AVAudioSessionPortOverrideNone : AVAudioSessionPortOverrideSpeaker error:nil];
    [audioSession setActive:YES error:nil];
}

// 屏幕共享事件
- (IBAction)shareDesktopBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if(btn.selected){
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
}

// 切换屏幕尺寸事件
- (IBAction)screenBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    EMCallRemoteView *view = (EMCallRemoteView *)[self.view viewWithTag:kCamViewTag];
    view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
}

// 隐藏按钮事件
- (IBAction)hiddenBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.collectionView setHidden:btn.selected];
    [self.infoLabel setHidden:btn.selected];
    [self.timeLabel setHidden:btn.selected];
    [self.camBtn setHidden:btn.selected];
    [self.muteBtn setHidden:btn.selected];
    [self.videoBtn setHidden:btn.selected];
    [self.speakerBtn setHidden:btn.selected];
    [self.shareDeskTopBtn setHidden:btn.selected];
    [self.screenBtn setHidden:btn.selected];
    [self.offBtn setHidden:btn.selected];
}

// 挂断事件
- (IBAction)offBtnClicked:(id)sender
{
    [self stopRing];
    [[HChatClient sharedClient].callManager endCall];
    self.callback(self, self.timeLabel.text);
    [self stopTimer];
}

// 应答事件
- (IBAction)anwersBtnClicked:(id)sender {
    [self stopRing];
    [self.callinView setHidden:YES];
    [self.infoLabel setHidden:NO];
    [self.callingView setHidden:NO];
    [self setupCollectionView];
    
    __weak typeof(self) weakSelf = self;
    [[HChatClient sharedClient].callManager acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HError *error)
     {
         if (error == nil) {
             [weakSelf.timeLabel setHidden:NO];
             [weakSelf startTimer];
             AVAudioSession *audioSession = [AVAudioSession sharedInstance];
             [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
             [audioSession setActive:YES error:nil];
         }
     }];
}

// 响铃
- (void)startRing {
    
}

// 停止响铃
- (void)stopRing {
    
}

// 开始计时
- (void)startTimer {
    _time = 0;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)updateTime {
    _time++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_time / 3600, (_time % 3600) / 60, _time % 60];
}

// 停止计时
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HCallViewCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.item = _members[indexPath.section];
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _members.count ? _members.count : 0 ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[self.view viewWithTag:kCamViewTag] removeFromSuperview];
    HCallViewCollectionViewCellItem *item = [_members objectAtIndex:indexPath.section];
    EMCallRemoteView *view = (EMCallRemoteView *)item.camView;
    view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
    view.frame = UIScreen.mainScreen.bounds;
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    view.tag = kCamViewTag;
    
    HCallViewCollectionViewCell *cell = (HCallViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selected];
}

#pragma mark - Call
// 成员加入回调
- (void)onMemberJoin:(HCallMember *)member {
    // 有 member 加入，添加到datasource中。
    [_members addObject: [self createCallerWithMember:member]];
    [self.collectionView reloadData];
    [self updateInfoLabel];
}

// 成员离开回调
- (void)onMemberExit:(HCallMember *)member {
    // 有 member 离开，清理datasource
    HCallViewCollectionViewCellItem *currentItem = nil;
    for (HCallViewCollectionViewCellItem *item in _members) {
        if ([item.memberName isEqualToString:member.memberName]) {
            currentItem = item;
            break;
        }
    }
    
    [_members removeObject:currentItem];
    [self.collectionView reloadData];
    [self updateInfoLabel];
}

// 视频流加入回调
- (void)onStreamAdd:(HCallStream *)stream {
    // 有新视频流加入， 找到所属的member，设置remoteView
    HCallViewCollectionViewCellItem *currentItem = nil;
    for (HCallViewCollectionViewCellItem *member in _members) {
        if ([member.memberName isEqualToString:stream.memberName]) {
            currentItem = member;
            break;
        }
    }
    
    if (!currentItem) {
        return; // 如果没有找到，return
    }
    
    if (!currentItem.camView) {
        currentItem.camView = [[HCallRemoteView alloc] init];
    }
    
    [[HChatClient sharedClient].callManager subscribeStreamId:stream.streamId
                                                         view:(HCallRemoteView *)currentItem.camView
                                                   completion:^(id obj, HError *error)
    {
        
    }];
}

// 视频流离开回调
- (void)onStreamRemove:(HCallStream *)stream {
    // 有视频流被移除， 找到所属的member，设置清空
    HCallViewCollectionViewCellItem *currentItem = nil;
    for (HCallViewCollectionViewCellItem *member in _members) {
        if ([member.memberName isEqualToString:stream.memberName]) {
            currentItem = member;
            break;
        }
    }
    
    if (!currentItem.camView) {
        currentItem.camView = nil;
    }
}

// 视频流更新回调
- (void)onStreamUpdate:(HCallStream *)stream {
    
}

// 结束回调
- (void)onCallEndReason:(int)reason desc:(NSString *)desc {
    self.callback(self, self.timeLabel.text);
    [self stopTimer];
}

@end
