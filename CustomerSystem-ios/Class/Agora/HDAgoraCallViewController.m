//
//  AgoraViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/5.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDAgoraCallViewController.h"
#import <HelpDesk/HelpDesk.h>
#import "HDCallViewCollectionViewCell.h"
#import <ReplayKit/ReplayKit.h>
#import "HDAgoraCallMember.h"
#import "HDAgoraCallManager.h"
#import "HDAgoraCallManagerDelegate.h"
#define kLocalUid 11111111111 //设置本地的uid
#define kCamViewTag 100001
#define kScreenShareExtensionBundleId @"com.easemob.enterprise.demo.customer.shareWindow"
#define kNotificationShareWindow kScreenShareExtensionBundleId
@interface HDAgoraCallViewController()<UICollectionViewDelegate,UICollectionViewDataSource,HDAgoraCallManagerDelegate,HDCallManagerDelegate>
{
    NSMutableArray *_members; // 通话人
    NSTimer *_timer;
    NSInteger _time;
    HDCallViewCollectionViewCellItem *_currentItem;
    BOOL isCalling; //是否正在通话
    NSString * _thirdAgentNickName;
    NSString * _thirdAgentUid;
}
@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *nickname;
@property (strong, nonatomic) IBOutlet UIView *bgView;

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
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));

@property (nonatomic, strong) UIView *localView;

@end

@implementation HDAgoraCallViewController

+ (HDAgoraCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter avatarStr:(NSString *)aAvatarStr nickName:(NSString *)aNickname hangUpCallBack:(HangAgroaUpCallback)callback{
    
    HDAgoraCallViewController *callVC = [[HDAgoraCallViewController alloc]
                                    initWithNibName:@"HDAgoraCallViewController"
                                    bundle:nil];

    callVC.avatarStr = aAvatarStr;
    callVC.nickname = aNickname;
    callVC.agentName = keyCenter.agentNickName;
    callVC.hangUpCallback = callback;
    
    //需要必要创建房间的参数
    [HDAgoraCallManager shareInstance].keyCenter =keyCenter;
    return callVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 用于添加语音呼入的监听 onCallReceivedNickName:
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];

    
    // 初始化数据源
    _members = [NSMutableArray array];
    // 设置 ui
    [self.timeLabel setHidden:YES];
    [self.callingView setHidden:YES];
    [self.collectionView reloadData];
    [self updateInfoLabel]; // 尝试更新“正在通话中...(n)”中的n。
    [self initBroadPickerView];
//    [self addNotifications];
  
}

/// 接收视频通话后 设置本地view
- (void)setAcceptCallView{
    [HDAgoraCallManager shareInstance].roomDelegate = self;
    [self setAgoraVideo];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[HDAgoraCallManager shareInstance] endCall];
    [[HDAgoraCallManager shareInstance] destroy];
}

- (void)setAgoraVideo{
    // 设置音视频 options
    HDAgoraCallOptions *options = [[HDAgoraCallOptions alloc] init];
    options.videoOff = NO; // 这个值要和按钮状态统一。
    options.mute = NO; // 这个值要和按钮状态统一。
    [[HDAgoraCallManager shareInstance] setCallOptions:options];
    //add local render view
    [self addLocalSessionWithUid:kLocalUid];//本地用户的id demo 切换的时候 有根据uid 判断 传入的时候尽量避免跟我们远端用户穿过来的相同
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
}
///  添加本地视频流
/// @param localUid   本地用户id
- (void)addLocalSessionWithUid:(NSInteger )localUid{
//    // 设置第一个item的头像，昵称都为自己。HDCallViewCollectionViewCellItem 界面展示类
    HDCallViewCollectionViewCellItem *item = [[HDCallViewCollectionViewCellItem alloc] initWithAvatarURI:@"url" defaultImage:[UIImage imageNamed:self.avatarStr] nickname:self.nickname];
    item.isSelected = YES; // 默认自己会被选中
    item.uid = localUid;
    UIView * localView = [[UIView alloc] init];
    item.camView = localView;
    //设置本地试图
    [[HDAgoraCallManager shareInstance] setupLocalVideoView:item.camView];
    //添加数据源
    [_members addObject:item];
}
- (void)setupCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"HDCallViewCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cellid"];
}
// 监听屏幕方向变化
- (void)handleStatusBarOrientationChange {

}
// 根据HDCallMember 创建cellItem
- (HDCallViewCollectionViewCellItem *)createCallerWithMember2:(HDAgoraCallMember *)aMember {
    UIView * remoteView = [[UIView alloc] init];
    HDCallViewCollectionViewCellItem *item = [[HDCallViewCollectionViewCellItem alloc] initWithAvatarURI:aMember.extension[@"avatarUrl"] defaultImage:[UIImage imageNamed:@"default_customer_avatar"] nickname:self.agentName];
    item.uid = [aMember.memberName integerValue];
    item.camView = remoteView;
    //设置远端试图
    [[HDAgoraCallManager shareInstance] setupRemoteVideoView:item.camView withRemoteUid:item.uid];
    return item;
}
// 更新详情显示
- (void)updateInfoLabel {
    if (!self.callingView.isHidden) { // 只有在已经通话中的情况下，才回去更新。
        self.infoLabel.text = [NSString stringWithFormat:@"正在通话中...(%d)",(int)_members.count];
    }
}
/// 初始化屏幕分享view
- (void)initBroadPickerView{
    if (@available(iOS 12.0, *)) {
        _broadPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadPickerView.preferredExtension = kScreenShareExtensionBundleId;
        
    } else {
        // Fallback on earlier versions
    }
}

- (void)onCallReceivedInvitation:(NSString *)thirdAgentNickName withUid:(NSString *)uid{
    
    _thirdAgentNickName = thirdAgentNickName;
    _thirdAgentUid = uid;
    
    [self updateThirdAgent];
}
- (void)updateThirdAgent{
   
    if (_thirdAgentNickName.length > 0) {
    [_members enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSLog(@"%@----%@",_members[idx],[NSThread currentThread]);
        HDCallViewCollectionViewCellItem *item = obj;
        if (item.uid == [_thirdAgentUid integerValue]) {
            item.nickname = _thirdAgentNickName;
            [_members  replaceObjectAtIndex:idx withObject:item];
        }
    }];

    [self.collectionView reloadData];
    }
}
// 切换摄像头事件
- (IBAction)camBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[HDAgoraCallManager shareInstance] switchCamera];
}

// 静音事件
- (IBAction)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDAgoraCallManager shareInstance] pauseVoice];
    } else {
        [[HDAgoraCallManager shareInstance] resumeVoice];
    }
}

// 停止发送视频流事件
- (IBAction)videoBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    UIView *selfView = [_members.firstObject camView];
    if (btn.selected) {
        [[HDAgoraCallManager shareInstance] pauseVideo];
    } else {
        [[HDAgoraCallManager shareInstance] resumeVideo];
    }
    selfView.hidden = btn.selected;
}

// 扬声器事件
- (IBAction)speakerBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[HDAgoraCallManager shareInstance] setEnableSpeakerphone:btn.selected];
}

// 屏幕共享事件
- (IBAction)shareDesktopBtnClicked:(UIButton *)btn {
    
    for (UIView *view in _broadPickerView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
            //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
            [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];

        }
    }
}


// 切换屏幕尺寸事件
- (IBAction)screenBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    UIView * view = [self.view viewWithTag:kCamViewTag];
    CGRect frame = self.videoView.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    view.frame = self.screenBtn.selected ? UIScreen.mainScreen.bounds : frame;
    [UIView commitAnimations];
    
//    [[HDAgoraCallManager shareInstance].agoraKit setLocalRenderMode:AgoraVideoRenderModeHidden];
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
    isCalling = NO;
    //挂断和拒接 都走这个
    [[HDAgoraCallManager shareInstance] endCall];
    [self stopTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.hangUpCallback) {
            self.hangUpCallback(self, self.timeLabel.text);
        }
    });
   
}

// 应答事件
- (IBAction)anwersBtnClicked:(id)sender {
    [self.callinView setHidden:YES];
    [self.infoLabel setHidden:NO];
    [self.callingView setHidden:NO];
    
    [self setupCollectionView];
    [self updateInfoLabel];
    [self setAcceptCallView];
    // 设置选中 collectionView 第一项
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    __weak typeof(self) weakSelf = self;
    [[HDAgoraCallManager shareInstance] acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HDError *error)
     {
        if (error == nil){
             [weakSelf.timeLabel setHidden:NO];
             [weakSelf startTimer];
            isCalling = YES;
        }else{
            // 加入失败 或者视频网络断开
            dispatch_async(dispatch_get_main_queue(), ^{
               // UI更新代码
                if (self.hangUpCallback) {
                    self.hangUpCallback(self, self.timeLabel.text);
                }
            });
            NSLog(@"VC=Occur error%d",error.code);
        }
     }];
}


// 开始计时
- (void)startTimer {
    _time = 0;
    _timer = [NSTimer timerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
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
    CGRect frame = self.videoView.frame;
    UIView *view = item.camView;
    view.frame = self.screenBtn.selected ? UIScreen.mainScreen.bounds : frame;
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    view.tag = kCamViewTag;
    HDCallViewCollectionViewCell *cell = (HDCallViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selected];
}

#pragma mark - Call

// 成员加入回调
- (void)onMemberJoin:(HDAgoraCallMember *)member {
    // 有 member 加入，添加到datasource中。
    NSLog(@"join Member  member---- %@ ",member.memberName);
    if (!self.callingView.isHidden) { // 只有在已经通话中的情况下，才回去在ui加入，否则都在接听时加入。
        @synchronized(_members){
            BOOL isNeedAdd = YES;
            for (HDCallViewCollectionViewCellItem *item in _members) {
                if (item.uid  == [member.memberName integerValue] ) {
                    isNeedAdd = NO;
                    break;
                }
            }
            if (isNeedAdd) {
                [_members addObject: [self createCallerWithMember2:member]];
            }
        };
        [self updateThirdAgent];
        [self.collectionView reloadData];
        [self updateInfoLabel];
    }
}

// 成员离开回调
- (void)onMemberExit:(HDAgoraCallMember *)member {
    // 有 member 离开，清理datasource
    // 如果移除的是当前显示的客服
    if (_currentItem.uid == [member.memberName integerValue]) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    }
    HDCallViewCollectionViewCellItem *deleteItem;
    for (HDCallViewCollectionViewCellItem *item in _members) {
        if (item.uid == [member.memberName integerValue]) {
            deleteItem = item;
            break;
        }
    }
    if (deleteItem) {
        [_members removeObject:deleteItem];
        [[HDAgoraCallManager shareInstance] setupRemoteVideoView:deleteItem.camView withRemoteUid:deleteItem.uid];
        [self.collectionView reloadData];
        [self updateInfoLabel];
    }
}
// 坐席主动 挂断 结束回调
- (void)onCallEndReason:(NSString *)desc {
   
    [self stopTimer];
    [[HDAgoraCallManager shareInstance] leaveChannel];
       // UI更新代码
        if (self.hangUpCallback) {
            self.hangUpCallback(self, self.timeLabel.text);
        }
    
}

#pragma mark - 进程间通信-CFNotificationCenterGetDarwinNotifyCenter 使用之前，需要为container app与extension app设置 App Group，这样才能接收到彼此发送的进程间通知。
// 录屏直播 主App和宿主App数据共享，通信功能实现 如果我们要将开始、暂停、结束这些事件以消息的形式发送到宿主App中，需要使用CFNotificationCenterGetDarwinNotifyCenter。
- (void)sendNotificationWithIdentifier:(nullable NSString *)identifier userInfo:(NSDictionary *)info {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFDictionaryRef userInfo = (__bridge CFDictionaryRef)info;
    BOOL const deliverImmediately = YES;
    CFStringRef identifierRef = (__bridge CFStringRef)identifier;
    CFNotificationCenterPostNotification(center, identifierRef, NULL, userInfo, deliverImmediately);
}
//void NotificationCallback(CFNotificationCenterRef center,
//                                   void * observer,
//                                   CFStringRef name,
//                                   void const * object,
//                                   CFDictionaryRef userInfo) {
//    NSString *identifier = (__bridge NSString *)name;
//    NSObject *sender = (__bridge NSObject *)observer;
////    NSDictionary *info = (__bridge NSDictionary *)userInfo;
////    NSDictionary *info = CFBridgingRelease(userInfo);
//    NSDictionary *notiUserInfo = @{@"identifier":identifier};
//    if (sender) {
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShareWindow
//                                                            object:sender
//                                                          userInfo:notiUserInfo];
//    }
//
//}
//- (void)addNotifications {
//    [self registerNotificationsWithIdentifier:@"broadcastStartedWithSetupInfo"];
//    [self registerNotificationsWithIdentifier:@"broadcastPaused"];
//    [self registerNotificationsWithIdentifier:@"broadcastResumed"];
//    [self registerNotificationsWithIdentifier:@"broadcastFinished"];
//    [self registerNotificationsWithIdentifier:@"processSampleBuffer"];
//    //这里同时注册了分发消息的通知，在宿主App中使用
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationAction:) name:kNotificationShareWindow object:nil];
//}
//
//- (void)registerNotificationsWithIdentifier:(nullable NSString *)identifier{
//    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
//    CFStringRef str = (__bridge CFStringRef)identifier;
//
//    CFNotificationCenterAddObserver(center,
//                                    (__bridge const void *)(self),
//                                    NotificationCallback,
//                                    str,
//                                    NULL,
//                                    CFNotificationSuspensionBehaviorDeliverImmediately);
//}
- (void)NotificationAction:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSString *identifier = userInfo[@"identifier"];
    
    if ([identifier isEqualToString:@"broadcastStartedWithSetupInfo"]) {
        
        self.shareDeskTopBtn.selected =YES;
        
        [[HDAgoraCallManager shareInstance]  leaveChannel];
        [[HDAgoraCallManager shareInstance]  destroy];
        
        NSLog(@"broadcastStartedWithSetupInfo");
    }
    if ([identifier isEqualToString:@"broadcastPaused"]) {
        NSLog(@"broadcastPaused");
    }
    if ([identifier isEqualToString:@"broadcastResumed"]) {
        NSLog(@"broadcastResumed");
    }
    if ([identifier isEqualToString:@"broadcastFinished"]) {
        
        //更改按钮的状态
        self.shareDeskTopBtn.selected =NO;
        
        [[HDAgoraCallManager shareInstance] joinChannel];
        //设置远端试图
        for (HDCallViewCollectionViewCellItem * item in _members) {
            if (item.uid == kLocalUid) {
                //设置本地试图 取出本地item
                [[HDAgoraCallManager shareInstance] setupLocalVideoView:item.camView];
            }else{
                [[HDAgoraCallManager shareInstance] setupRemoteVideoView:item.camView withRemoteUid:item.uid];
            }
        }
       
        
        NSLog(@"broadcastFinished");
    }
    if ([identifier isEqualToString:@"processSampleBuffer"]) {
        NSLog(@"processSampleBuffer");
    }
}
@end
