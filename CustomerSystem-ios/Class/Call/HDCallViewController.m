//
//  HDCallViewController.m
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/8.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import "HDCallViewController.h"
#import "HDCallViewCollectionViewCell.h"
#import <HelpDesk/HelpDesk.h>

#define kCamViewTag 100001

@interface HDCallViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HDCallManagerDelegate> {
    NSMutableArray *_members; // 通话人
    NSTimer *_timer;
    NSInteger _time;
    HDCallViewCollectionViewCellItem *_currentItem;
}
@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *nickname;

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

@implementation HDCallViewController

+ (HDCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName
                                             avatarStr:(NSString *)aAvatarStr
                                              nickName:(NSString *)aNickname
                                        hangUpCallBack:(HangUpCallback)callback{
    HDCallViewController *callVC = [[HDCallViewController alloc]
                                    initWithNibName:@"HDCallViewController"
                                    bundle:nil];
    callVC.agentName = aAgentName;
    callVC.avatarStr = aAvatarStr;
    callVC.nickname = aNickname;
    callVC.hangUpCallback = callback;
    return callVC;
}

+ (HDCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName
                                             avatarStr:(NSString *)aAvatarStr
                                              nickName:(NSString *)aNickname {
    HDCallViewController *callVC = [[HDCallViewController alloc]
                                    initWithNibName:@"HDCallViewController"
                                    bundle:nil];
    callVC.agentName = aAgentName;
    callVC.avatarStr = aAvatarStr;
    callVC.nickname = aNickname;
    return callVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(handleStatusBarOrientationChange)
                                                name:UIApplicationDidChangeStatusBarOrientationNotification
                                              object:nil];
    
    // 初始化数据源
    _members = [NSMutableArray array];
    // 设置第一个item的头像，昵称都为自己。
    HDCallViewCollectionViewCellItem *item = [[HDCallViewCollectionViewCellItem alloc] initWithAvatarURI:@"url" defaultImage:[UIImage imageNamed:self.avatarStr] nickname:self.nickname];
    item.isSelected = YES; // 默认自己会被选中
    // 随机给一个memberNumber
    item.memberName = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    item.camView = [[HDCallLocalView alloc] init]; // 自己的camView是HDCallLocalView，其他人的是HDCallRemoteView
    [_members addObject:item]; // 将自己的item添加到datasource中
    
    // 设置音视频 options
    HDCallOptions *options = [[HDCallOptions alloc] init];
    options.videoOff = NO; // 这个值要和按钮状态统一。
    options.mute = NO; // 这个值要和按钮状态统一。
    options.previewView = (HDCallLocalView *)item.camView; // 设置自己视频时使用的view
    [[HDClient sharedClient].callManager setCallOptions:options];
    
    // 添加监听
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    
    // 设置 ui
    [self.view setBackgroundColor:UIColor.blackColor];
    [self.timeLabel setHidden:YES];
    [self.callingView setHidden:YES];
    [self.collectionView reloadData];
    
    // 响铃
    [self startRing];
    
    // 设置选中 collectionView 第一项
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    
    [self updateInfoLabel]; // 尝试更新“正在通话中...(n)”中的n。
}

- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"HDCallViewCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cellid"];
}

// 监听屏幕方向变化
- (void)handleStatusBarOrientationChange {
    EMCallRemoteView *view = (EMCallRemoteView *)[self.view viewWithTag:kCamViewTag];
    view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
    view.frame = UIScreen.mainScreen.bounds;
}

// 根据HDCallMember 创建cellItem
- (HDCallViewCollectionViewCellItem *)createCallerWithMember:(HDCallMember *)aMember {
    HDCallViewCollectionViewCellItem *item = [[HDCallViewCollectionViewCellItem alloc] initWithAvatarURI:aMember.extension[@"avatarUrl"] defaultImage:[UIImage imageNamed:@"default_customer_avatar"] nickname:aMember.extension[@"nickname"]];
    item.memberName = aMember.memberName;
    return item;
}

// 更新详情显示
- (void)updateInfoLabel {
    if (!self.callingView.isHidden) { // 只有在已经通话中的情况下，才回去更新。
        self.infoLabel.text = [NSString stringWithFormat:@"正在通话中...(%d)",(int)_members.count];
    }
}

// 切换摄像头事件
- (IBAction)camBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[HDClient sharedClient].callManager switchCamera];
}

// 静音事件
- (IBAction)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDClient sharedClient].callManager pauseVoice];
    } else {
        [[HDClient sharedClient].callManager resumeVoice];
    }
}

// 停止发送视频流事件
- (IBAction)videoBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDClient sharedClient].callManager pauseVideo];
    } else {
        [[HDClient sharedClient].callManager resumeVideo];
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
        [[HDClient sharedClient].callManager publishWindow:self.view completion:^(id obj, HDError * error) {
            if(error){
                NSLog(@"desktop shared fail, error: %@", error.errorDescription);
            }else{
                NSLog(@"desktop shared success.");
            }
        }];
    }else{
        [[HDClient sharedClient].callManager unPublishWindowWithCompletion:^(id obj, HDError * error) {
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
    [[HDClient sharedClient].callManager endCall];
    [self stopTimer];
    if (self.hangUpCallback) {
        self.hangUpCallback(self, self.timeLabel.text);
    }
}

// 应答事件
- (IBAction)anwersBtnClicked:(id)sender {
    [self stopRing];
    [self.callinView setHidden:YES];
    [self.infoLabel setHidden:NO];
    [self.callingView setHidden:NO];
    NSArray *hasJoined = [HDClient.sharedClient.callManager hasJoinedMembers];
    for (HDCallMember *member in hasJoined) {
       [_members addObject:[self createCallerWithMember:member]];
    }
    [self setupCollectionView];
    [self updateInfoLabel];
    __weak typeof(self) weakSelf = self;
    [[HDClient sharedClient].callManager acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HDError *error)
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
    _timer = [NSTimer timerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
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
    HDCallViewCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
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
    HDCallViewCollectionViewCellItem *item = [_members objectAtIndex:indexPath.section];
    _currentItem = item;
    EMCallRemoteView *view = (EMCallRemoteView *)item.camView;
    view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
    view.frame = UIScreen.mainScreen.bounds;
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    view.tag = kCamViewTag;
    
    HDCallViewCollectionViewCell *cell = (HDCallViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selected];
}

#pragma mark - Call
// 成员加入回调
- (void)onMemberJoin:(HDCallMember *)member {
    // 有 member 加入，添加到datasource中。
    if (!self.callingView.isHidden) { // 只有在已经通话中的情况下，才回去在ui加入，否则都在接听时加入。
        [_members addObject: [self createCallerWithMember:member]];
        [self.collectionView reloadData];
        [self updateInfoLabel];
    }
}

// 成员离开回调
- (void)onMemberExit:(HDCallMember *)member {
    // 有 member 离开，清理datasource
    HDCallViewCollectionViewCellItem *currentItem = nil;
    for (HDCallViewCollectionViewCellItem *item in _members) {
        if ([item.memberName isEqualToString:member.memberName]) {
            currentItem = item;
            break;
        }
    }
    
    // 如果移除的是当前显示的客服
    if ([_currentItem.memberName isEqualToString:member.memberName]) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    }
    
    [_members removeObject:currentItem];
    [self.collectionView reloadData];
    [self updateInfoLabel];
}

// 视频流加入回调
- (void)onStreamAdd:(HDCallStream *)stream {
    // 有新视频流加入， 找到所属的member，设置remoteView
    HDCallViewCollectionViewCellItem *currentItem = nil;
    for (HDCallViewCollectionViewCellItem *member in _members) {
        if ([member.memberName isEqualToString:stream.memberName]) {
            currentItem = member;
            break;
        }
    }
    
    if (!currentItem) {
        return; // 如果没有找到，return
    }
    
    
    HDCallStream *oldStream = currentItem.handleStreams.firstObject;
    if (oldStream) {
        [[HDClient sharedClient].callManager updateSubscribeStreamId:oldStream.streamId
                                                                view:nil
                                                          completion:nil];
    }
    
    BOOL _hasStream = NO;
    for (HDCallStream *st in currentItem.handleStreams) {
        if ([st.streamId isEqualToString:stream.streamId]) {
            _hasStream = YES;
            break;
        }
    }
    
    if (!_hasStream) {
        [currentItem.handleStreams addObject:stream];
    }
    
    if (!currentItem.camView) {
        currentItem.camView = [[HDCallRemoteView alloc] init];
    }
    
    [[HDClient sharedClient].callManager subscribeStreamId:stream.streamId
                                                      view:(HDCallRemoteView *)currentItem.camView
                                                completion:^(id obj, HDError *error) {
                                                    if ([_currentItem.memberName isEqualToString:currentItem.memberName]) {
                                                        [[self.view viewWithTag:kCamViewTag] removeFromSuperview];
                                                        EMCallRemoteView *view = (EMCallRemoteView *)currentItem.camView;
                                                        view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
                                                        view.frame = UIScreen.mainScreen.bounds;
                                                        [self.view addSubview:view];
                                                        [self.view sendSubviewToBack:view];
                                                        view.tag = kCamViewTag;
                                                    }
                                                }];
}

// 视频流离开回调
- (void)onStreamRemove:(HDCallStream *)stream {
    // 有视频流被移除， 找到所属的member，设置清空
    HDCallViewCollectionViewCellItem *currentItem = nil;
    for (HDCallViewCollectionViewCellItem *member in _members) {
        if ([member.memberName isEqualToString:stream.memberName]) {
            currentItem = member;
            break;
        }
    }
    
    
    HDCallStream *curStream = nil;
    for (HDCallStream *tmpStream in currentItem.handleStreams) {
        if ([tmpStream.streamId isEqualToString:stream.streamId]) {
            curStream = tmpStream;
            break;
        }
    }
   
    if (curStream) {
        [currentItem.handleStreams removeObject:curStream];
        [[HDClient sharedClient].callManager updateSubscribeStreamId:curStream.streamId
                                                                view:nil
                                                          completion:nil];
        
    }
    
    if (currentItem.handleStreams.firstObject) {
        currentItem.camView = [[HDCallRemoteView alloc] init];
        HDCallStream *needUpdateStream = currentItem.handleStreams.firstObject;
        [[HDClient sharedClient].callManager unSubscribeStreamId:needUpdateStream.streamId completion:nil];
        [[HDClient sharedClient].callManager subscribeStreamId:needUpdateStream.streamId
                                                                view:(HDCallRemoteView *)currentItem.camView
                                                          completion:^(id obj, HDError *error) {
                                                              if ([_currentItem.memberName isEqualToString:currentItem.memberName]) {
                                                                  [[self.view viewWithTag:kCamViewTag] removeFromSuperview];
                                                                  EMCallRemoteView *view = (EMCallRemoteView *)currentItem.camView;
                                                                  view.scaleMode = self.screenBtn.selected ? EMCallViewScaleModeAspectFill : EMCallViewScaleModeAspectFit;
                                                                  view.frame = UIScreen.mainScreen.bounds;
                                                                  [self.view addSubview:view];
                                                                  [self.view sendSubviewToBack:view];
                                                                  view.tag = kCamViewTag;
                                                              }
                                                          }];
    }
}

// 视频流更新回调
- (void)onStreamUpdate:(HDCallStream *)stream {

}

// 结束回调
- (void)onCallEndReason:(int)reason desc:(NSString *)desc {
    [self stopTimer];
    if (self.hangUpCallback) {
        self.hangUpCallback(self, self.timeLabel.text);
    }
}


@end
