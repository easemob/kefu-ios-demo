//
//  CallViewController.m
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import "HDCallViewController.h"
#import "HDControlBarView.h"
#import "HDMiddleVideoView.h"
#import "HDSmallWindowView.h"
#import "HDTitleView.h"
#import "Masonry.h"
#import "HDAnswerView.h"
#import "HDCallCollectionViewCellItem.h"

#import <HelpDesk/HelpDesk.h>
#import <ReplayKit/ReplayKit.h>
#import "HDAgoraCallManager.h"
#import "HDAgoraCallManagerDelegate.h"
#import "HDPopoverViewController.h"
#import "HDItemView.h"
#import "HDAppSkin.h"
#import "HDHiddenView.h"
#import "HDWhiteBoardView.h"
#import "HDUploadFileViewController.h"
#import "HDWhiteRoomManager.h"
#define kLocalUid 11111111111 //设置真实的本地的uid
#define kLocalWhiteBoardUid 222222 //设置虚拟白板uid
#define kCamViewTag 100001
#define kScreenShareExtensionBundleId @"com.easemob.enterprise.demo.customer.shareWindow"
#define kNotificationShareWindow kScreenShareExtensionBundleId
#define kPointHeight [UIScreen mainScreen].bounds.size.width *0.9
#define kApplicationStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height //状态栏的高度
@interface HDCallViewController ()<HDAgoraCallManagerDelegate,HDCallManagerDelegate,UIPopoverPresentationControllerDelegate>{
    
    UIView *_changeView;
    NSMutableArray * _videoItemViews;
    NSMutableArray * _videoViews;
    NSMutableArray * _tmpArray;
    
    
    NSMutableArray *_members; // 通话人小窗
    NSMutableArray *_midelleMembers; // 通话人中间窗口
    NSTimer *_timer;
    NSInteger _time;
    HDCallCollectionViewCellItem *_currentItem; //中间窗口的item 对象
    BOOL isCalling; //是否正在通话
    NSString * _thirdAgentNickName;
    NSString * _thirdAgentUid;
    
    NSString * _isFirstAdd; // 远端进来是不是第一次添加
    
    UIButton *_cameraBtn;
    BOOL _cameraState; //摄像头状态； yes 开启摄像头 no 关闭
    BOOL _shareState; //屏幕共享状态； yes 正在共享 no 没有共享
    
    NSMutableDictionary *  allMembersDic; // 全局数据存储
}
@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatarStr;

@property (nonatomic, strong) HDControlBarView *barView;
@property (nonatomic, strong) HDMiddleVideoView *midelleVideoView;
@property (nonatomic, strong) HDSmallWindowView *smallWindowView;
@property (nonatomic, strong) HDTitleView *hdTitleView;
@property (nonatomic, strong) HDAnswerView *hdAnswerView;
@property (nonatomic, strong) HDItemView *itemView;
@property (nonatomic, strong) HDHiddenView *hidView;
@property (nonatomic, assign) BOOL  isLandscape;//当前屏幕 是横屏还是竖屏
@property (strong, nonatomic) HDPopoverViewController *buttonPopVC;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
@property (nonatomic, strong) HDWhiteBoardView *whiteBoardView;

@end

@implementation HDCallViewController
+ (HDCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter  avatarStr:(NSString *)aAvatarStr nickName:(NSString *)aNickname hangUpCallBack:(HangUpCallback)callback{
    
    HDCallViewController *callVC = [[HDCallViewController alloc] init];
    callVC.nickname = aNickname;
    callVC.avatarStr = aAvatarStr;
    callVC.agentName = keyCenter.agentNickName;
    callVC.hangUpCallback = callback;
    
        
    
    //需要必要创建房间的参数
    [HDAgoraCallManager shareInstance].keyCenter =keyCenter;
    return callVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[HDAppSkin mainSkin] contentColorGray];
    
    _cameraState = NO;
    
    // 用于添加语音呼入的监听 onCallReceivedNickName:
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelected:) name:@"click" object:nil];
    [self.view addSubview:self.hdAnswerView];
    [self.hdAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
    
    
    self.isLandscape = NO;
    _videoViews = [NSMutableArray new];
    _videoItemViews = [NSMutableArray new];
    _members = [NSMutableArray new];
    _midelleMembers = [NSMutableArray new];
    allMembersDic = [NSMutableDictionary new];
    [self initScreenShare];
}

/// 初始化屏幕分享
- (void)initScreenShare{
    [self initBroadPickerView];
//    [self addNotifications];
    
    
}
-(void)initData{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeMute;
    barModel.name=@"";
    barModel.imageStr= kjinmai;
    barModel.selImageStr= kmaikefeng1;
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"";
    barModel1.imageStr=kguanbishexiangtou1;
    barModel1.selImageStr=kshexiangtou1;
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeHangUp;
    barModel2.name=@"";
    barModel2.imageStr=kguaduan1;
    barModel2.selImageStr=kguaduan1;
    barModel2.isHangUp = YES;
    
    HDControlBarModel * barModel3 = [HDControlBarModel new];
    barModel3.itemType = HDControlBarItemTypeShare;
    barModel3.name=@"";
    barModel3.imageStr=kpingmugongxiang2;
    barModel3.selImageStr=kpingmugongxiang2;
    
    HDControlBarModel * barModel4 = [HDControlBarModel new];
    barModel4.itemType = HDControlBarItemTypeFlat;
    barModel4.name=@"";
    barModel4.imageStr=kbaiban;
    barModel4.selImageStr=kbaiban;
    
//    HDGrayModel * grayModel =  [[HDCallManager shareInstance] getGrayName:@"isTicketTrial"];
    
    
//    NSArray * selImageArr = @[barModel,barModel1,barModel2];
//    NSArray * selImageArr = @[barModel,barModel1,barModel3,barModel2];
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3,barModel4];
    
    [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleVideo] ;
    
    [self initSmallWindowData];
}

- (void)initSmallWindowData{
    
    //初始化本地view
    [self addLocalSessionWithUid:kLocalUid];
    
    [self.smallWindowView setItemData:_members];
    
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
    options.videoOff = _cameraState; // 这个值要和按钮状态统一。
    options.mute = _cameraState; // 这个值要和按钮状态统一。
    [[HDAgoraCallManager shareInstance] setCallOptions:options];
    //add local render view
    [self addLocalSessionWithUid:kLocalUid];//本地用户的id demo 切换的时候 有根据uid 判断 传入的时候尽量避免跟我们远端用户穿过来的相同
    [UIApplication sharedApplication].idleTimerDisabled = YES;

}
///  添加本地视频流
/// @param localUid   本地用户id
- (void)addLocalSessionWithUid:(NSInteger )localUid{
//    // 设置第一个item的头像，昵称都为自己。HDCallViewCollectionViewCellItem 界面展示类
    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
    item.isSelected = YES; // 默认自己会被选中
    item.isMute = !_cameraState; //这个地方需要注意 默认 是需要选中 红色 所以这个地方跟默认取个反 
    item.nickName = self.nickname;
    item.uid = localUid;
    UIView * localView = [[UIView alloc] init];
    item.camView = localView;
    [[HDAgoraCallManager shareInstance] setupLocalVideoView:item.camView];
    //添加数据源
    [_members addObject:item];
    
    //默认进来 中间窗口显示 坐席头像
    [self.itemView setItemString:self.agentName];
    
}
// 根据HDCallMember 创建cellItem
- (HDCallCollectionViewCellItem *)createCallerWithMember2:(HDAgoraCallMember *)aMember withView:(UIView *)view {
    NSLog(@"join 成员加入回调- 根据HDCallMember 创建cellItem--- %@ ",aMember.memberName);
    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
    item.nickName = aMember.agentNickName;
    item.uid = [aMember.memberName integerValue];
    item.camView =view;
//    item.camView = retomView;
    //远端第一次进来 添加中间窗口初始化view
    if (_videoViews.count == 0) {
        [_videoViews addObject:item];
    }
    //设置远端试图
    [[HDAgoraCallManager shareInstance] setupRemoteVideoView:item.camView withRemoteUid:item.uid];
    return item;
}
// 坐席主动 挂断 结束回调
- (void)onCallEndReason:(NSString *)desc {
    [self.hdTitleView stopTimer];
    
    [[HDWhiteRoomManager shareInstance] hd_OnLogout];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.hangUpCallback) {
            self.hangUpCallback(self, self.hdTitleView.timeLabel.text);
        }
    });
   
}
- (void)onCallReceivedInvitation:(NSString *)thirdAgentNickName withUid:(NSString *)uid{
    
    _thirdAgentNickName = thirdAgentNickName;
    _thirdAgentUid = uid;
    
    [self updateThirdAgent];
}
- (void)updateThirdAgent{
   
    if (_thirdAgentNickName.length > 0) {
    [self.smallWindowView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSLog(@"%@----%@",self.smallWindowView.items[idx],[NSThread currentThread]);
        HDCallCollectionViewCellItem *item = obj;
        if (item.uid == [_thirdAgentUid integerValue]) {
            item.nickName = _thirdAgentNickName;
            [self.smallWindowView setAudioMuted:item];
        }
    }];

//    [self.collectionView reloadData];
    }
}

-(void)addSubView{
    //顶部 title
    [self.view addSubview:self.hdTitleView];
    //中间小窗
    [self.view addSubview:self.smallWindowView];
    //中间打窗口
    [self.view addSubview:self.midelleVideoView];
    //底部view
    [self.view addSubview:self.barView];
    
    //添加昵称信息
    [self.view addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.barView.mas_top).offset(-5);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);
        
    }];
    
}
#pragma mark - 屏幕翻转就会调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //计算旋转之后的宽度并赋值
        CGSize screen = [UIScreen mainScreen].bounds.size;
        //动画播放完成之后
        if(screen.width > screen.height){
            NSLog(@"横屏");
            [self updateCustomViewFrame:screen withScreen:YES];
        }else{
            NSLog(@"竖屏");
            [self updateCustomViewFrame:screen withScreen:NO];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"动画播放完之后处理");
    }];
}

-(void)updateCustomViewFrame:(CGSize)size withScreen:(BOOL)landscape{
    self.isLandscape = landscape;
    self.smallWindowView.isLandscape = landscape;
    if (landscape) {
        [self updateLandscapeLayout];
    }else{
        [self updatePorttaitLayout];
    }
}

/// 横屏布局
-(void)updateLandscapeLayout{
    
    //顶部 小窗口
    [self.smallWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hdTitleView.mas_bottom).offset(0);
        make.width.offset(90);
        make.trailing.offset(-10);
        make.bottom.mas_equalTo(self.barView.mas_top).offset(0);
        
    }];
    //中间 视频窗口
    [self.midelleVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
    [self.view sendSubviewToBack:self.midelleVideoView];
    
  
    //底部 窗口
    [self.barView refreshView:self.barView withScreen:self.isLandscape];
    
}
/// 竖屏布局
-(void)updatePorttaitLayout{
    
    //顶部功能
    [self.hdTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);
    }];
  
    //底部功能按钮
    
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets insets = self.view.safeAreaInsets;
            make.bottom.mas_equalTo(-insets.bottom).offset(-5);
        } else {
            // Fallback on earlier versions
            make.bottom.offset(-5);
        }
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.height.offset(64);
    }];
    [self.barView layoutIfNeeded];
    
    //顶部 小窗口
    [self.smallWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hdTitleView.mas_bottom).offset(20);
        make.leading.offset(15);
        make.trailing.offset(0);
        make.height.offset(90);
        
    }];
    //中间 视频窗口
    [self.midelleVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(kPointHeight);
        
    }];
    [self.midelleVideoView layoutIfNeeded];
    
    //底部 窗口
    [self.barView refreshView:self.barView withScreen:self.isLandscape];
}


/// 点击 cell。更改小窗试图
/// @param item  cell 里边的model
/// @param idx  当前点击cell 的index
- (void)changeCallViewItem:(HDCallCollectionViewCellItem *)item withIndex:(NSInteger)idx{
    
     //更新小窗口
    [self updateSmallVideoView:item withIndex:idx];

    //更新中间视频大窗口
    [self updateBigVideoView];
}
/// 更新小视频窗口变成大窗口。把小窗口的 item 信息 给大窗口用。然后在把大窗口的item 信息给小窗切换
-(void)updateSmallVideoView:(HDCallCollectionViewCellItem *)item withIndex:(NSInteger )idx{
   
    //小窗昵称变成 大窗昵称
    [self changeNickNameItem:item];
    
    [_videoItemViews removeAllObjects];
    //这个数组里边添加的是小窗口需要放到中间视频窗口的view 在传给cell 前先保存之前的view
    [_videoItemViews addObject:item];
    
    //cell 小窗口切换_videoViews 存放大窗口 信息
    HDCallCollectionViewCellItem * bigItem =[_videoViews firstObject];
//    UIView * tmpVideoView = smallItem.camView;
//    smallItem.camView = tmpVideoView;
    if (bigItem.isWhiteboard) {
        bigItem.camView.userInteractionEnabled = NO;

    }
    [self.smallWindowView setSelectCallItemChangeVideoView:bigItem withIndex:idx];

}

/// 更新大视频窗口变成小窗口）
-(void)updateBigVideoView{
    
    [_videoViews removeAllObjects];
    HDCallCollectionViewCellItem * smallItem = [_videoItemViews firstObject];
    UIView * videoView = smallItem.camView;
    if (smallItem.isWhiteboard) {
        videoView.userInteractionEnabled = YES;
    }
    self.midelleVideoView = (HDMiddleVideoView *)videoView;
    [self.view addSubview:videoView];
    //中间 视频窗口
    if (self.isLandscape) {
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);
            
        }];
        [self.view sendSubviewToBack:videoView];
    }else{
        
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(kPointHeight );
        }];
    }
    [_videoViews addObject:smallItem];

    //大窗昵称变成 小窗昵称
    [self changeNickNameItem:smallItem];
    
}

/// 更新大视频窗口变成小窗口）
-(void)updateBigVideoView:(HDCallCollectionViewCellItem *)item{
    [_videoViews removeAllObjects];
    UIView * videoView = item.camView;
    self.midelleVideoView = (HDMiddleVideoView *)videoView;
    [self.view addSubview:videoView];
    //中间 视频窗口
    if (self.isLandscape) {
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);
            
        }];
        [self.view sendSubviewToBack:videoView];
    }else{
        
        [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(kPointHeight );
        }];
    }
    [_videoViews addObject:item];

    //大窗昵称变成 小窗昵称
    [self changeNickNameItem:item];
    
}

///  控制器中大小窗昵称切换
/// @param item  获取昵称的对象
-(void)changeNickNameItem:(HDCallCollectionViewCellItem *)item{
    
    //大窗昵称变成 小窗昵称
    [self.itemView setItemString:item.nickName];
    
    self.itemView.muteBtn.selected = item.isMute;
}

- (HDHiddenView *)hidView{
    
    if (_hidView) {
        _hidView = [[HDHiddenView alloc] init];
        _hidView.backgroundColor = [UIColor redColor];
    }
    return _hidView;
}


- (HDItemView *)itemView{
    if (!_itemView) {
        _itemView = [[HDItemView alloc]init];
     }
     return _itemView;
}
- (HDAnswerView *)hdAnswerView{
   if (!_hdAnswerView) {
       _hdAnswerView = [[HDAnswerView alloc]init];
       _hdAnswerView.backgroundColor = [UIColor blackColor];
       __weak __typeof__(self) weakSelf = self;
       _hdAnswerView.clickOnBlock = ^(UIButton * _Nonnull btn) {
           [weakSelf anwersBtnClicked:btn];
       };
       _hdAnswerView.clickOffBlock = ^(UIButton * _Nonnull btn) {
           [weakSelf offBtnClicked:btn];
       };
    }
    return _hdAnswerView;
}

- (HDTitleView *)hdTitleView {
    if (!_hdTitleView) {
        _hdTitleView = [[HDTitleView alloc]init];
//        _hdTitleView.backgroundColor = [UIColor redColor];
       
    }
    return _hdTitleView;
}
- (HDControlBarView *)barView {
    if (!_barView) {
        _barView = [[HDControlBarView alloc]init];
//        _barView.backgroundColor = [UIColor redColor];
        _barView.layer.cornerRadius = 10;
        _barView.layer.masksToBounds = YES;
        __weak __typeof__(self) weakSelf = self;
        _barView.clickControlBarItemBlock = ^(HDControlBarModel * _Nonnull barModel, UIButton * _Nonnull btn) {
            
            switch (barModel.itemType) {
                case HDControlBarItemTypeMute:
                    [weakSelf muteBtnClicked:btn];
                    break;
                case HDControlBarItemTypeVideo:
                    [weakSelf videoBtnClicked:btn];
                    break;
                case HDControlBarItemTypeHangUp:
                    [weakSelf offBtnClicked:btn];
                    break;
                case HDControlBarItemTypeShare:
                    [weakSelf shareDesktopBtnClicked:btn];
                    break;
                case HDControlBarItemTypeFlat:
                    [weakSelf onClickedFalt:btn];
                    break;
                    
                default:
                    break;
            }
            
            
        };
       
    }
    return _barView;
}
- (HDMiddleVideoView *)midelleVideoView {
    if (!_midelleVideoView) {
        _midelleVideoView = [[HDMiddleVideoView alloc]init];
    }
    return _midelleVideoView;
}
- (HDSmallWindowView *)smallWindowView {
    if (!_smallWindowView) {
        _smallWindowView = [[HDSmallWindowView alloc]init];
        __weak __typeof__(self) weakSelf = self;
        _smallWindowView.clickCellItemBlock = ^(HDCallCollectionViewCellItem * _Nonnull item, NSIndexPath * _Nonnull indexpath) {
            //切换逻辑
            [weakSelf changeCallViewItem:item withIndex:indexpath.item];
        };
    }
    return _smallWindowView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self.hdTitleView startTimer];
//    [self.hdTitleView modifyInfoLabelText: @"通话中好多好多人啊"];
    
    
    
}


#pragma mark - event
/// 应答事件
/// @param sender  button
- (void)anwersBtnClicked:(UIButton *)sender{
    self.hdAnswerView.hidden = YES;
    //应答的时候 在创建view
    //添加 页面布局
    [self addSubView];
    //默认进来调用竖屏
    [self updatePorttaitLayout];
    [self initData];
    [self setAcceptCallView];
    [self.hdTitleView startTimer];
    [[HDAgoraCallManager shareInstance] acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HDError *error)
     {
        NSLog(@"===anwersBtnClicked=Occur error%d",error.code);
        if (error == nil){
            isCalling = YES;
            NSLog(@"===anwersBtnClicked=isCalling%d",error.code);
        }else{
            NSLog(@"===anwersBtnClicked=dispatch_async%d",error.code);
            // 加入失败 或者视频网络断开
            dispatch_async(dispatch_get_main_queue(), ^{
               // UI更新代码
                if (self.hangUpCallback) {
                    self.hangUpCallback(self,self.hdTitleView.timeLabel.text);
                }
          
            NSLog(@"VC=Occur error%d",error.code);
            });
        }
       
     }];
}
/// 拒接事件
/// @param sender button
- (void)offBtnClicked:(UIButton *)sender{
    //拒接事件 拒接关闭当前页面
    isCalling = NO;
    //挂断和拒接 都走这个
    [[HDAgoraCallManager shareInstance] endCall];
    [self.hdTitleView stopTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        if (self.hangUpCallback) {
            self.hangUpCallback(self,self.hdTitleView.timeLabel.text);
        }
    });
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

// 切换摄像头事件
- (void)camBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[HDAgoraCallManager shareInstance] switchCamera];
}

// 静音事件
- (void)muteBtnClicked:(UIButton *)btn {
//    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDAgoraCallManager shareInstance] pauseVoice];
        [self updateAudioMuted:NO byUid:kLocalUid];
    } else {
        [[HDAgoraCallManager shareInstance] resumeVoice];
        
        [self updateAudioMuted:YES byUid:kLocalUid];
    }
    
    NSLog(@"点击了静音事件");
}

// 停止发送视频流事件
- (void)videoBtnClicked:(UIButton *)btn {
    _cameraBtn = btn;
    //默认进来判断获取摄像头状态
    //1、如果是关闭  点击直接打开摄像头
    //2、如果是开启的 点击按钮 谈窗
//        1、点击关闭摄像头  调用关闭摄像头方法 并且 更改当前btn 图片状态
//        2、点击切换摄像头  调用切换摄像头方法
    if (_cameraState) {
        //开启
          btn.selected = !btn.selected;
          [self popoverVCWithBtn:btn];
        
    }else{
        //当前摄像头关闭 需要打开
        [[HDAgoraCallManager shareInstance] enableLocalVideo:YES];
        _cameraState = YES;
//        [self.hidView removeFromSuperview];

    }
    
}
- (void)popoverVCWithBtn:(UIButton *)btn{
    NSLog(@"点击了视频事件");
    self.buttonPopVC = [[HDPopoverViewController alloc] init];
    self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.buttonPopVC.popoverPresentationController.sourceView = btn;  //rect参数是以view的左上角为坐标原点（0，0）
    self.buttonPopVC.popoverPresentationController.sourceRect = btn.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    self.buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.buttonPopVC animated:YES completion:nil];
}

///处理popover上的talbe的cell点击
- (void)tableDidSelected:(NSNotification *)notification {
    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
    switch (indexpath.row) {
        case 0:
            //关闭摄像头
            [self closeCamera];
            break;
        case 1:
            //切换摄像头
            NSLog(@"====点击了切换摄像头");
            [[HDAgoraCallManager shareInstance] switchCamera];
            break;
    
    }
    if (self.buttonPopVC) {
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.buttonPopVC = nil;
        
    }else{
      
    }
}
- (void) closeCamera{
    NSLog(@"====点击了关闭摄像头");
    _cameraState = NO;
    _cameraBtn.selected =NO;
    //更新对应状态 设置button 照片
    
    UIImage *img  = [UIImage imageWithIcon:kguanbishexiangtou1 inFont:kfontName size:_cameraBtn.size.width/2 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000] ] ;
    [_cameraBtn setImage:img forState:UIControlStateNormal];

    [[HDAgoraCallManager shareInstance] enableLocalVideo:NO];
    
    
   
//    [self.view addSubview:self.hidView];
//    [self.hidView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
//        make.leading.offset(0);
//        make.trailing.offset(0);
//        make.height.offset([UIScreen mainScreen].bounds.size.width *9/16 );
//    }];
    
    
    
    
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;   //点击蒙版popover不消失， 默认yes
}
// 扬声器事件
- (void)speakerBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
//    [[HDAgoraCallManager shareInstance] setEnableSpeakerphone:btn.selected];
    NSLog(@"点击了扬声器事件");
}

// 屏幕共享事件
- (void)shareDesktopBtnClicked:(UIButton *)btn {
    
    if ([HDWhiteRoomManager shareInstance].roomState == YES) {
        //当前正在白板房间
        return;
    }
    for (UIView *view in _broadPickerView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            //调起录像方法，UIControlEventTouchUpInside的方法看其他文章用的是UIControlEventTouchDown，
            //我使用时用UIControlEventTouchUpInside用好使，看个人情况决定
            [(UIButton*)view sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    NSLog(@"点击了屏幕共享事件");
}

// 切换屏幕尺寸事件
- (void)screenBtnClicked:(UIButton *)btn {
    NSLog(@"点击了切换屏幕尺寸事件");
}

// 隐藏按钮事件
- (void)hiddenBtnClicked:(UIButton *)btn
{
    NSLog(@"点击了隐藏按钮事件");
}


#pragma mark - Call

// 成员加入回调
- (void)onMemberJoin:(HDAgoraCallMember *)member {
    NSLog(@"join 成员加入回调---- %@ ",member.memberName);
    // 有 member 加入，添加到datasource中。
    if (isCalling) { // 只有在已经通话中的情况下，才回去在ui加入，否则都在接听时加入。
        NSLog(@"join 成员加入回调- isCalling--- %@ ",member.memberName);
        @synchronized(_midelleMembers){
            BOOL isNeedAdd = YES;
            for (HDCallCollectionViewCellItem *item in _midelleMembers) {
                NSLog(@"join Member  member---- %@ ",member.memberName);
                if (item.uid  == [member.memberName integerValue] ) {
                    isNeedAdd = NO;
                    break;
                }
            }
            NSLog(@"join 成员加入回调- @synchronized for循环结束--- %@ ",member.memberName);
            if (isNeedAdd) {
                NSLog(@"join Member  isNeedAdd---- %@ ",member.memberName);
                if (_midelleMembers.count > 0) {
                    NSLog(@"join Member  _midelleMembers---- %@ ",member.memberName);
                    UIView * localView = [[UIView alloc] init];
                    HDCallCollectionViewCellItem * thirdItem = [self createCallerWithMember2:member withView:localView];
                    [self.smallWindowView  setThirdUserdidJoined:thirdItem];
                   
                }else{
                    NSLog(@"join Member  isNeedAdd---- %@ ",member.memberName);
                    HDCallCollectionViewCellItem * thirdItem = [self createCallerWithMember2:member withView:self.midelleVideoView];
                    [_midelleMembers addObject: thirdItem];
                }
            }
        };
        
        NSLog(@"join 成员加入回调- @synchronized 加入成员结束--- %@ ",member.memberName);
        [self updateThirdAgent];
     //刷新 collectionView
        [self.smallWindowView reloadData];
      
    }
}


/// 删除小窗
/// @param item
- (void)deleteSmallWindow:(NSString *)uid{
    
}
/// 删除中间
/// @param item
- (void)deleteMiddelWindow:(NSString *)uid{
    
}

// 成员离开回调
- (void)onMemberExit:(HDAgoraCallMember *)member {
    NSLog(@"onMemberExit Member  member---- %@ ",member.memberName);
    //先去小窗 查找 如果在小窗 有删除 刷新即可
    HDCallCollectionViewCellItem *deleteItem;
    
    for (HDCallCollectionViewCellItem *item in self.smallWindowView.items) {
        if (item.uid == [member.memberName integerValue]) {
            deleteItem = item;
            break;
        }
    }
    if (deleteItem) {
        
        [self.smallWindowView removeCurrentCellItem:deleteItem];
        [self.smallWindowView reloadData];
       
    }else{
        //说明小窗里边没有
        //如果小窗没有 那说明是 在中间窗口 那就是删除中间 小窗最后一位回到中间
        for (HDCallCollectionViewCellItem *item in _videoViews) {
            if (item.uid == [member.memberName integerValue]) {
                deleteItem = item;
                break;
            }
        }
        if (deleteItem) {
            [_midelleMembers removeObject:deleteItem];
            //把 小窗口 最后一个元素 拿到中间
            HDCallCollectionViewCellItem * samllItem =  [self.smallWindowView.items lastObject];
            
            [self updateBigVideoView:samllItem];
        
            [self.smallWindowView removeCurrentCellItem:samllItem];
            [self.smallWindowView reloadData];
        }
        
    }
}

/// 远端用户音频静音通知
/// @param muted  是否静音
/// @param uid  静音的用户 uid
- (void)onCalldidAudioMuted:(BOOL)muted byUid:(NSUInteger)uid{
    
    [self updateAudioMuted:muted byUid:uid];
    
}
- (void)updateAudioMuted:(BOOL)muted byUid:(NSUInteger)uid{
    
    // 根据uid 找到用户 然后刷新一下界面
    BOOL  __block isSmallVindow = NO;
    [self.smallWindowView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDCallCollectionViewCellItem *item = obj;
        NSLog(@"%ld----%@",(long)item.uid,[NSThread currentThread]);
        if (item.uid == uid) {
            isSmallVindow = YES;
            NSLog(@"==uid===%lu",(unsigned long)uid);
            item.isMute = muted;
            [self.smallWindowView setAudioMuted:item];
            *stop = YES;
        }
    }];
    
    if (!isSmallVindow) {
        //说明需要更新 中间窗口的下边的麦克风
        self.itemView.muteBtn.selected = muted;
        [_members enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HDCallCollectionViewCellItem *item = obj;
            NSLog(@"%ld----%@",(long)item.uid,[NSThread currentThread]);
            if (item.uid == uid) {
                [self.itemView setItemString:item.nickName];
                *stop = YES;
            }
        }];
        
       
    }
    
    
}
#pragma mark -  互动白板 相关
// 互动白板
- (void)onClickedFalt:(UIButton *)sender
{
    //互动白板加入成功以后 屏幕共享 不能使用 不能创建白板房间
//    if (_videoViews.count == 0) {
//        return;
//    }
//    if (_shareState) {
//        //当前正在共享
//        return;
//    }
//    HDCallCollectionViewCellItem  * midelleViewItem =  [_videoViews firstObject];
//
//    [self.smallWindowView setThirdUserdidJoined:midelleViewItem];
//    [self.smallWindowView reloadData];
//
//    [_videoViews removeAllObjects];
//
//
//    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
//    item.uid = kLocalWhiteBoardUid;
//    item.realUid = kLocalUid;
//    item.isWhiteboard = YES;
//    item.nickName = @"白板";
//    item.camView = self.whiteBoardView;
//    //先取出中间试图的model 放到 小窗口  然后把白板的试图放到中间窗口
//
//    [_videoViews addObject:item];
//    [self changeNickNameItem:item];
    [self.view addSubview:self.whiteBoardView];
//    //中间 视频窗口
    if (self.isLandscape) {
        [self.whiteBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);

        }];
        [self.view sendSubviewToBack:self.whiteBoardView];
    }else{

        [self.whiteBoardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(kPointHeight);
        }];
        [self.whiteBoardView layoutIfNeeded];
    }
    
   
}
-(HDWhiteBoardView *)whiteBoardView{
    
    if (!_whiteBoardView) {
        
        _whiteBoardView = [[HDWhiteBoardView alloc] init];
        __weak __typeof(self) weakSelf = self;
        _whiteBoardView.clickWhiteBoardViewBlock = ^(HDClickButtonType type, UIButton * _Nonnull btn) {
            
            [weakSelf clickWhiteBoardView:type withBtn:btn];
            
        };
    }
    
    return _whiteBoardView;
    
}

- (void)clickWhiteBoardView:(HDClickButtonType )type withBtn:(UIButton *)btn{
    
    switch (type) {
        case HDClickButtonTypeScale:
            [self onScaleBtn:btn];
            break;
        case HDClickButtonTypeFile:
            
            [self uploadFile];
            
            break;
        case HDClickButtonTypeLogout:
            
            [self disconnectRoom];
            
            break;
        default:
            break;
    }
    
    
}
-(void)onScaleBtn:(UIButton *)sender{
    //全屏显示
    HDCallCollectionViewCellItem  * midelleViewItem =  [_videoViews firstObject];
    HDWhiteBoardView * whiteView = (HDWhiteBoardView *) midelleViewItem.camView;
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        
        NSLog(@"sender.isSelected");
        if (self.isLandscape) {
            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);

            }];
            [self.view sendSubviewToBack:whiteView];
        }else{

            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(kApplicationStatusBarHeight);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);
            }];
            [whiteView layoutIfNeeded];
            [self.view bringSubviewToFront:whiteView];
        }
    }else{
        NSLog(@"点击了互动白板事件");
        if (self.isLandscape) {
            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);

            }];
            [self.view sendSubviewToBack:whiteView];
        }else{

            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.height.offset(kPointHeight);
            }];
            [whiteView layoutIfNeeded];
//            [self.view bringSubviewToFront:whiteView];
        }
    }
    
    
  
}
- (void)uploadFile{
    HDUploadFileViewController * vc = [[HDUploadFileViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)disconnectRoom{
   
    
    for (HDCallCollectionViewCellItem * tmpItem in self.smallWindowView.items) {
        
        NSLog(@"======%@",tmpItem.nickName);
    }
    [[HDWhiteRoomManager shareInstance] hd_OnLogout];
    HDCallCollectionViewCellItem  * midelleViewItem =  [_videoViews firstObject];
    HDWhiteBoardView * whiteView = (HDWhiteBoardView *) midelleViewItem.camView;
    
    [whiteView removeFromSuperview];
    [self.whiteBoardView removeFromSuperview];
    self.whiteBoardView=nil;
    //把 小窗口 最后一个元素 拿到中间
    HDCallCollectionViewCellItem * samllItem =  [self.smallWindowView.items lastObject];
    
    [self updateBigVideoView:samllItem];

    [self.smallWindowView removeCurrentCellItem:samllItem];
    [self.smallWindowView reloadData];
    
   
    
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
void NotificationCallback(CFNotificationCenterRef center,
                                   void * observer,
                                   CFStringRef name,
                                   void const * object,
                                   CFDictionaryRef userInfo) {
    NSString *identifier = (__bridge NSString *)name;
    NSObject *sender = (__bridge NSObject *)observer;
//    NSDictionary *info = (__bridge NSDictionary *)userInfo;
//    NSDictionary *info = CFBridgingRelease(userInfo);
    NSDictionary *notiUserInfo = @{@"identifier":identifier};
    if (sender) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShareWindow
                                                            object:sender
                                                          userInfo:notiUserInfo];
    }
   
}
- (void)addNotifications {
    [self registerNotificationsWithIdentifier:@"broadcastStartedWithSetupInfo"];
    [self registerNotificationsWithIdentifier:@"broadcastPaused"];
    [self registerNotificationsWithIdentifier:@"broadcastResumed"];
    [self registerNotificationsWithIdentifier:@"broadcastFinished"];
    [self registerNotificationsWithIdentifier:@"processSampleBuffer"];
    //这里同时注册了分发消息的通知，在宿主App中使用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationAction:) name:kNotificationShareWindow object:nil];
}

- (void)registerNotificationsWithIdentifier:(nullable NSString *)identifier{
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
   
    CFNotificationCenterAddObserver(center,
                                    (__bridge const void *)(self),
                                    NotificationCallback,
                                    str,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}
- (void)NotificationAction:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSString *identifier = userInfo[@"identifier"];
    
    if ([identifier isEqualToString:@"broadcastStartedWithSetupInfo"]) {
        
        [[HDAgoraCallManager shareInstance]  leaveChannel];
        [[HDAgoraCallManager shareInstance]  destroy];
        _shareState= YES;
        
        NSLog(@"broadcastStartedWithSetupInfo");
    }
    if ([identifier isEqualToString:@"broadcastPaused"]) {
        NSLog(@"broadcastPaused");
    }
    if ([identifier isEqualToString:@"broadcastResumed"]) {
        NSLog(@"broadcastResumed");
    }
    if ([identifier isEqualToString:@"broadcastFinished"]) {
        _shareState= NO;
        //更改按钮的状态
        
        [[HDAgoraCallManager shareInstance] joinChannel];
        //设置远端试图
        for (HDCallCollectionViewCellItem * item in _members) {
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
