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

#define kLocalUid 11111111111 //设置本地的uid
#define kCamViewTag 100001
#define kScreenShareExtensionBundleId @"com.easemob.enterprise.demo.customer.shareWindow"
#define kNotificationShareWindow kScreenShareExtensionBundleId

@interface HDCallViewController ()<HDAgoraCallManagerDelegate,HDCallManagerDelegate,UIPopoverPresentationControllerDelegate>{
    
    UIView *_changeView;
    NSMutableArray * _videoItemViews;
    NSMutableArray * _videoViews;
    NSMutableArray * _tmpArray;
    
    
    NSMutableArray *_members; // 通话人
    NSTimer *_timer;
    NSInteger _time;
    HDCallCollectionViewCellItem *_currentItem;
    BOOL isCalling; //是否正在通话
    NSString * _thirdAgentNickName;
    NSString * _thirdAgentUid;
    
    UIButton *_cameraBtn;
    BOOL _cameraState; //摄像头状态； yes 开启摄像头 no 关闭
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
@property (nonatomic, strong) UIView *tmpView;
@property (nonatomic, assign) BOOL  isLandscape;//当前屏幕 是横屏还是竖屏
@property (strong, nonatomic) HDPopoverViewController *buttonPopVC;
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
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
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    NSArray * selImageArr = @[barModel,barModel1,barModel2,barModel3,barModel4];
    
    [self.barView buttonFromArrBarModels:selImageArr view:self.barView];
    
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
    
    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
    item.isSelected = YES; // 默认自己会被选中
    item.nickName = self.nickname;
    item.uid = localUid;
    UIView * localView = [[UIView alloc] init];
    item.camView = localView;
    [[HDAgoraCallManager shareInstance] setupLocalVideoView:item.camView];
    //添加数据源
    [_members addObject:item];
    
    [self.itemView setItemString:item.nickName];
}
// 根据HDCallMember 创建cellItem
- (HDCallCollectionViewCellItem *)createCallerWithMember2:(HDAgoraCallMember *)aMember {
    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
    item.nickName = self.nickname;
    item.uid = [aMember.memberName integerValue];
    item.camView = self.midelleVideoView;
    //设置远端试图
    [[HDAgoraCallManager shareInstance] setupRemoteVideoView:item.camView withRemoteUid:item.uid];
    return item;
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
        HDCallCollectionViewCellItem *item = obj;
        if (item.uid == [_thirdAgentUid integerValue]) {
            item.nickName = _thirdAgentNickName;
            [_members  replaceObjectAtIndex:idx withObject:item];
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
        make.bottom.mas_equalTo(self.barView.mas_top).offset(10);
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
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(84);
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
        make.height.offset([UIScreen mainScreen].bounds.size.width *9/16 );
        
    }];
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
    [self updateVideoView];
}
/// 更新视频窗口（大窗口）
-(void)updateSmallVideoView:(HDCallCollectionViewCellItem *)item withIndex:(NSInteger )idx{
    
    [_videoItemViews removeAllObjects];
    //这个数组里边添加的是小窗口需要放到中间视频窗口的view 在传给cell 前先保存之前的view
    [_videoItemViews addObject:item.camView];
    //cell 小窗口切换
    UIView * tmpVideoView = [_videoViews firstObject];
    item.camView = tmpVideoView;
    [self.smallWindowView setSelectCallItemChangeVideoView:item withIndex:idx];
 
    [self.itemView setItemString:item.nickName];
    
}

/// 更新视频窗口（大窗口）
-(void)updateVideoView{
    
    [_videoViews removeAllObjects];
    UIView * videoView = [_videoItemViews firstObject];
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
            make.height.offset([UIScreen mainScreen].bounds.size.width *9/16 );
        }];
    }
    [_videoViews addObject:videoView];

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
        _midelleVideoView.backgroundColor = [UIColor blueColor];
        self.tmpView = _midelleVideoView;
        [_videoViews addObject:_midelleVideoView];
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
   
    [[HDAgoraCallManager shareInstance] acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HDError *error)
     {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (error != nil){
            self.hdAnswerView.hidden = YES;
            //应答的时候 在创建view
            //添加 页面布局
            [self addSubView];
            //默认进来调用竖屏
            [self updatePorttaitLayout];
            [self initData];
            [self.hdTitleView startTimer];
            [self setAcceptCallView];
            isCalling = YES;
        }else{
            // 加入失败 或者视频网络断开
          
               // UI更新代码
                if (self.hangUpCallback) {
                    self.hangUpCallback(self,self.hdTitleView.timeLabel.text);
                }
          
            NSLog(@"VC=Occur error%d",error.code);
        }
        });
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
- (void)initBroadPickerView{
    if (@available(iOS 12.0, *)) {
       
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
    } else {
        [[HDAgoraCallManager shareInstance] resumeVoice];
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
        [[HDAgoraCallManager shareInstance] resumeVideo];
        _cameraState = YES;

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

    [[HDAgoraCallManager shareInstance] pauseVideo];
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

// 互动白板
- (void)onClickedFalt:(UIButton *)sender
{
    NSLog(@"点击了互动白板事件");
   
}
#pragma mark - Call

// 成员加入回调
- (void)onMemberJoin:(HDAgoraCallMember *)member {
    // 有 member 加入，添加到datasource中。
    if (isCalling) { // 只有在已经通话中的情况下，才回去在ui加入，否则都在接听时加入。
        @synchronized(_members){
            BOOL isNeedAdd = YES;
            for (HDCallCollectionViewCellItem *item in _members) {
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
     //刷新 collectionView
        [self.smallWindowView reloadData];
        
    }
}

// 成员离开回调
- (void)onMemberExit:(HDAgoraCallMember *)member {
    // 有 member 离开，清理datasource
    // 如果移除的是当前显示的客服
    if (_currentItem.uid == [member.memberName integerValue]) {
        [self.smallWindowView removeCurrentCellItem];
    }
    HDCallCollectionViewCellItem *deleteItem;
    for (HDCallCollectionViewCellItem *item in _members) {
        if (item.uid == [member.memberName integerValue]) {
            deleteItem = item;
            break;
        }
    }
    if (deleteItem) {
        [_members removeObject:deleteItem];
        [[HDAgoraCallManager shareInstance] setupRemoteVideoView:deleteItem.camView withRemoteUid:deleteItem.uid];
       
        [self.smallWindowView reloadData];
       
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
        
//        self.shareDeskTopBtn.selected =YES;
        
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
