//
//  CallViewController.m
//  HLtest
//
//  Created by houli on 2022/3/4.
//

#import "HDVideoCallViewController.h"
#import "HDControlBarView.h"
#import "HDMiddleVideoView.h"
#import "HDSmallWindowView.h"
#import "HDTitleView.h"
#import "Masonry.h"
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
#import "MBProgressHUD+Add.h"
#import "UIViewController+AlertController.h"
#import "CSDemoAccountManager.h"
#import "HDVideoGeneralCustomView.h"
#import "HDVideoIDCardScaningView.h"
#import "IDInfo.h"
#import "HDVideoLinkMessagePush.h"
#import "HDSignView.h"
#import "HDSatisfactionView.h"
#import "HDVideoMessageView.h"
#import "HDVideoCallChatViewController.h"
#import "AppDelegate.h"

#define kLocalUid 1111111 //设置真实的本地的uid
#define kLocalWhiteBoardUid 222222 //设置虚拟白板uid
#define kCamViewTag 100001
#define kScreenShareExtensionBundleId @"com.easemob.kf.demo.customer.shareWindow"
#define kNotificationShareWindow kScreenShareExtensionBundleId
#define kPointHeight [UIScreen mainScreen].bounds.size.width *0.9

#define kHDVideoMessageHeight [UIScreen mainScreen].bounds.size.height * 0.8

typedef NS_ENUM(NSInteger, HDVideoCallTaskType) {
    HDVideoCallTaskPush = 1, //  信息推送
    HDVideoCallTaskSign , //  签名
    HDVideoCallTaskIDCard , //  卡证识别
    HDVideoCallTaskFace , // 人脸识别
};
@interface HDVideoCallViewController ()<HDAgoraCallManagerDelegate,HDCallManagerDelegate,HDWhiteboardManagerDelegate,UIPopoverPresentationControllerDelegate,SuspendCustomViewDelegate,HDVideoGeneralCustomViewDelegate,HDSignDelegate>{
    
//    BOOL _isShow; //是否已经调用过show方法
    
    UIView *_changeView;
    NSMutableArray * _videoItemViews;
    NSMutableArray * _videoViews;
    NSMutableArray * _tmpArray;
    
    
    NSMutableArray *_members; // 通话人小窗
    NSMutableArray *_midelleMembers; // 通话人中间窗口
    NSTimer *_timer;
    NSInteger _time;
    HDCallCollectionViewCellItem *_currentItem; //中间窗口的item 对象
    HDCallCollectionViewCellItem *_ocrItem; //ocr的item 对象
    BOOL isCalling; //是否正在通话
    NSString * _thirdAgentNickName;
    NSString * _thirdAgentUid;
    
    NSString * _isFirstAdd; // 远端进来是不是第一次添加
    UIButton *_muteBtn;  //声音button
    UIButton *_cameraBtn; //相机button
    UIButton *_moreBtn; // 更多button
    UIButton *_shareBtn;     //屏幕共享的button
    UIButton *_whiteBoardBtn;     //白板的button
    BOOL _cameraState; //摄像头状态； yes 开启摄像头 no 关闭
    BOOL _shareState; //屏幕共享状态； yes 正在共享 no 没有共享
    
    NSMutableDictionary *  allMembersDic; // 全局数据存储
    
    MBProgressHUD *_hud;
    
    UIView * _closeBgview;
    CGFloat viewWidth;
    CGFloat viewHeight;
    BOOL _isCurrenDeviceFront; //当前是否是前置摄像头
    BOOL _isOcrCloseSwitchCamera; // 调用ocr 识别后 摄像头 有没有切换 如果有切换 那就需要在切换回去
    
    NSString * _signflowId; //签名的flowid
__block NSString * _pushflowId; //信息推送的flowid
    NSString * _faceflowId; // 身份验证的flowid
    NSString * _ocrflowId;  // ocr的flowid
   
    
    //点击屏幕共享的model
    HDPopoverViewControllerCellItem * _shareScreenCellItem;
    //点击白板的model
    HDPopoverViewControllerCellItem * _whiteboardCellItem;
    
   
}
/*
 * 弹窗窗口
 */
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) NSString *agentName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) HDKeyCenter *keyCenter;

@property (nonatomic, strong) HDControlBarView *barView;
@property (nonatomic, strong) HDMiddleVideoView *midelleVideoView;
@property (nonatomic, strong) HDSmallWindowView *smallWindowView;
@property (nonatomic, strong) HDTitleView *hdTitleView;
@property (nonatomic, strong) HDItemView *itemView;
@property (nonatomic, strong) HDHiddenView *hidView;
@property (nonatomic, assign) BOOL  isLandscape;//当前屏幕 是横屏还是竖屏
@property (strong, nonatomic) HDPopoverViewController *buttonPopVC;
@property (strong, nonatomic) HDPopoverViewController *morePopVC;//更多
@property (nonatomic, strong) RPSystemBroadcastPickerView *broadPickerView API_AVAILABLE(ios(12.0));
@property (nonatomic, strong) HDWhiteBoardView *whiteBoardView;
@property (nonatomic, assign) BOOL  isSmallWindow;//当前是不是 半屏模式
@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) HDSuspendCustomView *hdSupendCustomView;
@property (nonatomic, strong) HDVideoLinkMessagePush *hdVideoLinkMessagePush;
@property (nonatomic, strong) HDSignView *hdSignView;
@property (nonatomic, strong) HDVideoIDCardScaningView *idCardScaningView;
@property (nonatomic, strong) UIView *ocrView;
@property (nonatomic, strong) HDSatisfactionView *hdSatisfactionView;
@property (nonatomic, strong) UIView *hdCameraFocusView;
@property (nonatomic, strong) HDVideoMessageView *hdMessageView;
@property (nonatomic, strong) HDVideoCallChatViewController * chat;
@property (nonatomic, weak) NSTimer *hideDelayTimer;
@property (nonatomic, weak) NSTimer *timeOutTimer;
// 队列数组 保证有一个正在执行的任务
@property (nonatomic, strong) NSMutableArray * queueArray;
@end
static dispatch_once_t onceToken;
 
static HDVideoCallViewController *_manger = nil;
@implementation HDVideoCallViewController

#pragma mark- 单利
 
/** 单利创建
 */
+ (instancetype)sharedManager
{
    dispatch_once(&onceToken, ^{
        _manger = [[HDVideoCallViewController alloc] init];
        _manger.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _manger.alertWindow.windowLevel = 0.0;
        _manger.alertWindow.backgroundColor = [UIColor clearColor];
        _manger.alertWindow.rootViewController = [UIViewController new];
        _manger.alertWindow.accessibilityViewIsModal = YES;
        [_manger.alertWindow makeKeyAndVisible];
        _manger.view.frame = [UIScreen mainScreen].bounds;
        [_manger.alertWindow  addSubview:_manger.view];
    });
    return _manger;
}
 
/** 单利销毁
*/
 
- (void)removeSharedManager
{
    /**只有置成0，GCD才会认为它从未执行过。它默认为0。
     这样才能保证下次再次调用sharedManager的时候，再次创建对象。*/
    onceToken= 0;

    [_manger removeAllSubviews];
    _manger.alertWindow = nil;
    _manger=nil;

    [self cancelWindow];
    [HDAgoraCallManager shareInstance].keyCenter.isAgentCancelCallbackReceive = NO;
    [HDAgoraCallManager shareInstance].keyCenter.isAgentCallBackReceive = NO;
    [HDAgoraCallManager shareInstance].currentWindow = nil;
    
    
}
- (void)removeAllSubviews {
    while (_manger.alertWindow.subviews.count) {
        UIView* child = _manger.alertWindow.subviews.lastObject;
        [child removeFromSuperview];
    }
}
+ (HDVideoCallViewController *)hasReceivedCallWithKeyCenter:(HDKeyCenter *)keyCenter  avatarStr:(NSString *)aAvatarStr nickName:(NSString *)aNickname hangUpCallBack:(HangUpVideoCallback)callback{
    
    HDVideoCallViewController *callVC = [[HDVideoCallViewController alloc] init];
    callVC.nickname = aNickname;
    callVC.avatarStr = aAvatarStr;
    callVC.agentName = keyCenter.agentNickName;
    callVC.hangUpVideoCallback = callback;
    
    //初始化灰度管理
    [[HDCallManager shareInstance] initGrayCompletion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
    
    }];
        
    //需要必要创建房间的参数
    [HDAgoraCallManager shareInstance].keyCenter =keyCenter;
    return callVC;
}
+(id)alertWithView:(UIView *)view AlertType:(HDVideoCallAlertType)type
{
    HDVideoCallViewController *callVC = [[HDVideoCallViewController alloc] init];
    return callVC;
}
+ (id)alertCallWithView:(UIView *)view{
   
    return [HDVideoCallViewController alertWithView:view AlertType:HDVideoCallAlertTypeVideo];
    
}
- (void)showViewWithKeyCenter:(HDKeyCenter *)keyCenter withType:(HDVideoType)type withVisitornickName:(nonnull NSString *)aNickname{
//    [HDAgoraCallManager shareInstance].currentWindow = self.alertWindow;
    [HDAgoraCallManager shareInstance].currentVC = self;
    [HDCallManager shareInstance].isVecVideo = YES;
    [HDLog logD:@"HD===%s vec1.2=====收到坐席回呼cmd消息 拿到keyCenter:%@",__func__,keyCenter];
    // 获取企业信息
    [self getConfigInfoVisitorNickName:aNickname];
    
    if (!isCalling) {
        
        if (type == HDVideoDirectionSend) {
            // 发送 界面
            self.isVisitorSend = YES;

            if ([HDAgoraCallManager shareInstance].layoutModel && [HDAgoraCallManager shareInstance].layoutModel.isSkipWaitingPage) {

                    //直接发起 视频呼叫
                    [self createVideoCall];

            }
            self.hdVideoAnswerView.callType = HDVideoDirectionSend;
        }else{
            [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 进入接收通话界面 "];
            // 接受 界面
            //需要必要创建房间的参数
            [HDAgoraCallManager shareInstance].keyCenter = keyCenter;
            self.nickname = keyCenter.visitorNickName;
            self.agentName = keyCenter.agentNickName;
            if (keyCenter.isAgentCallBackReceive && !keyCenter.agoraAppid) {
                //回呼过来的通话
             self.hdVideoAnswerView.callType = HDVideoDirectionReceive;
                
            // 其他情况下都是 坐席回拨过来的
            self.isVisitorSend = NO;
            }else{
                
                [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 坐席回拨过来了 "];
                //访客发起后 坐席回拨过来了
                [self anwersBtnClicked:nil];
            }
            
        }
    }
}
-(void)getConfigInfoVisitorNickName:(NSString *)vNickName{
    
    HDEnterpriseInfo * model = [[HDAgoraCallManager shareInstance] hd_getEnterpriseInfo];
    
    if (model) {
        
        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf setHdVideoAnswerViewWithEnterpriseInfo:model withVisitorNickName:vNickName];
            
        });
        
    }else{
    
    // 获取插件信息
    [[HDAgoraCallManager shareInstance] getConfigInfoCompletion:^(HDEnterpriseInfo * _Nonnull model, HDError * _Nonnull error) {

        kWeakSelf
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf setHdVideoAnswerViewWithEnterpriseInfo:model withVisitorNickName:vNickName];
            
        });
    }];
    
    }
}

- (void)setHdVideoAnswerViewWithEnterpriseInfo:(HDEnterpriseInfo *)model withVisitorNickName:(NSString *)vNickName{
    
    if (model) {
        self.hdVideoAnswerView.nickNameLabel.text = model.name;
        NSArray * array = [model.avatar componentsSeparatedByString:@"/v1"];
        NSString * str;
        for (int i =0; i< array.count; i++) {
            if (i!=0) {
                NSString * strUrl = array[i];
               
                str = [NSString stringWithFormat:@"%@",strUrl];
            }
            
        }
        NSString * imgStr = [NSString stringWithFormat:@"HelpDeskUIResource.bundle/easemob@2x.png"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v1%@",[HDClient sharedClient].kefuRestServer, str]];
        
        [self.hdVideoAnswerView.icon hdSD_setImageWithURL:url placeholderImage: [UIImage imageNamed:imgStr]];
    }else{
        self.hdVideoAnswerView.nickNameLabel.text = vNickName;
    }

    
    
}

- (void)hideView{
    if (self&&self.view) {
        self.view.hidden = YES;
    }
}
- (void)removeView{
   
    self.isShow = NO;
    [self.view removeFromSuperview];
    self.view = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [[HDAppSkin mainSkin] contentColorGray];

    self.view.backgroundColor = [[HDAppSkin mainSkin] contentColorBlockalpha:0.6];
    [self.view hideKeyBoard];
    // 获取灰度vec
    [[HDCallManager shareInstance] initGrayCompletion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
    
    }];
    self.isShow = YES;
    _cameraState = YES;
    
    // 用于添加语音呼入的监听 onCallReceivedNickName:
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    [HDClient.sharedClient.whiteboardManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelected:) name:@"click" object:nil];
    [self.view addSubview:self.hdVideoAnswerView];
    [self.hdVideoAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.offset([UIScreen mainScreen].bounds.size.width * 0.8);
//                make.height.offset([UIScreen mainScreen].bounds.size.width * 0.8 * 1.3);
//        make.centerX.mas_equalTo(self.view);
//        make.centerY.mas_equalTo(self.view);
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
  
    
}
//
-(void)clearViewData{
    
    [_videoViews removeAllObjects];
    [_videoItemViews removeAllObjects];
    [_members removeAllObjects];
    [_midelleMembers removeAllObjects];
    [allMembersDic removeAllObjects];
    [self clearQueueTask];
    for (UIView *view in [self.view subviews]) {

        if (![view isKindOfClass:[HDVideoAnswerView class]]) {
        
            [view removeFromSuperview];
        }
    }
    
    self.barView = nil;
    
    self.midelleVideoView= nil;
    
    self.hdTitleView = nil;

    self.smallWindowView=nil;
    self.whiteBoardView = nil;
    [self.parentView removeFromSuperview];
    self.parentView = nil;
    self.view.backgroundColor = [[HDAppSkin mainSkin] contentColorBlockalpha:0.6];
    self.isVisitorSend = NO;
    _isCurrenDeviceFront = YES;
    if (_isOcrCloseSwitchCamera) {
        // 如果不是前置摄像头 需要自动切换摄像头
        [[HDAgoraCallManager shareInstance] switchCamera];
        _isOcrCloseSwitchCamera = NO;
    }
    
    if (self.hdVideoAnswerView.hidden) {
    
        self.hdVideoAnswerView.hidden = NO;
    }
    //隐藏 popervc
    [self dismissHDPoperViewController];
   
    //清理白板数据
    [self clearWhiteBoardData];
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view hideKeyBoard];
    
}

/// 初始化屏幕分享
- (void)initScreenShare{
    [self initBroadPickerView];
}
-(void)initData{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeMute;
    barModel.name=@"";
    barModel.imageStr= kmaikefeng1 ;
    barModel.selImageStr= kjinmai;
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"";
    barModel1.imageStr= kshexiangtou1 ;
    barModel1.selImageStr=kguanbishexiangtou1;
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeHangUp;
    barModel2.name=@"";
    barModel2.imageStr=kguaduan1;
    barModel2.selImageStr=kguaduan1;
    barModel2.isHangUp = YES;
    
//    HDControlBarModel * barModel3 = [HDControlBarModel new];
//    barModel3.itemType = HDControlBarItemTypeMessage;
//    barModel3.name=@"";
//    barModel3.imageStr=kxiaoxiguanli;
//    barModel3.selImageStr=kxiaoxiguanli;
//
//    HDControlBarModel * barModel4 = [HDControlBarModel new];
//    barModel4.itemType = HDControlBarItemTypeMore;
//    barModel4.name=@"";
//    barModel4.imageStr=kmore;
//    barModel4.selImageStr=kmore;
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
    
//    NSMutableArray * selImageArr = [NSMutableArray arrayWithObjects:barModel,barModel1,barModel2,barModel3,barModel4, nil];
    NSMutableArray * selImageArr = [NSMutableArray arrayWithObjects:barModel,barModel1,barModel2, nil];
   
    HDGrayModel * grayModelWhiteBoard =  [[HDCallManager shareInstance] getGrayName:@"whiteBoard"];
    HDGrayModel * grayModelShare =  [[HDCallManager shareInstance] getGrayName:@"shareDesktop"];
    if (grayModelShare.enable) {
        [selImageArr addObject:barModel3];
    }
    if (grayModelWhiteBoard.enable) {
        [selImageArr addObject:barModel4];
    }

 NSMutableArray * barArray = [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleVideo] ;
//    NSMutableArray * barArray = [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleVideoNew] ;

   _cameraBtn =  [self.barView hd_bttonWithTag:0 withArray:barArray];
    
    _muteBtn =  [self.barView hd_bttonMuteWithTag];
    
    _moreBtn =  [barArray lastObject];

    
    [self initSmallWindowData];
}
- (void)initDataNew{
    HDControlBarModel * barModel = [HDControlBarModel new];
    barModel.itemType = HDControlBarItemTypeMute;
    barModel.name=@"";
    barModel.imageStr= kmaikefeng1 ;
    barModel.selImageStr= kjinmai;
    
    HDControlBarModel * barModel1 = [HDControlBarModel new];
    barModel1.itemType = HDControlBarItemTypeVideo;
    barModel1.name=@"";
    barModel1.imageStr= kshexiangtou1 ;
    barModel1.selImageStr=kguanbishexiangtou1;
    
    HDControlBarModel * barModel2 = [HDControlBarModel new];
    barModel2.itemType = HDControlBarItemTypeHangUp;
    barModel2.name=@"";
    barModel2.imageStr=kguaduan1;
    barModel2.selImageStr=kguaduan1;
    barModel2.isHangUp = YES;
    
    HDControlBarModel * barModel3 = [HDControlBarModel new];
    barModel3.itemType = HDControlBarItemTypeMessage;
    barModel3.name=@"";
    barModel3.imageStr=kxiaoxiguanli;
    barModel3.selImageStr=kxiaoxiguanli;

    HDControlBarModel * barModel4 = [HDControlBarModel new];
    barModel4.itemType = HDControlBarItemTypeMore;
    barModel4.name=@"";
    barModel4.imageStr=kmore;
    barModel4.selImageStr=kmore;
//    HDControlBarModel * barModel3 = [HDControlBarModel new];
//       barModel3.itemType = HDControlBarItemTypeShare;
//       barModel3.name=@"";
//       barModel3.imageStr=kpingmugongxiang2;
//       barModel3.selImageStr=kpingmugongxiang2;
//
//       HDControlBarModel * barModel4 = [HDControlBarModel new];
//       barModel4.itemType = HDControlBarItemTypeFlat;
//       barModel4.name=@"";
//       barModel4.imageStr=kbaiban;
//       barModel4.selImageStr=kbaiban;
    
    NSMutableArray * selImageArr = [NSMutableArray arrayWithObjects:barModel,barModel1,barModel2,barModel3,barModel4, nil];
//    NSMutableArray * selImageArr = [NSMutableArray arrayWithObjects:barModel,barModel1,barModel2, nil];
       
//    HDGrayModel * grayModelWhiteBoard =  [[HDCallManager shareInstance] getGrayName:@"whiteBoard"];
//    HDGrayModel * grayModelShare =  [[HDCallManager shareInstance] getGrayName:@"shareDesktop"];
//    if (grayModelShare.enable) {
//        [selImageArr addObject:barModel3];
//    }
//    if (grayModelWhiteBoard.enable) {
//        [selImageArr addObject:barModel4];
//    }

// NSMutableArray * barArray = [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleVideo] ;
    NSMutableArray * barArray = [self.barView hd_buttonFromArrBarModels:selImageArr view:self.barView withButtonType:HDControlBarButtonStyleVideoNew] ;

   _cameraBtn =  [self.barView hd_bttonWithTag:0 withArray:barArray];
    
    _muteBtn =  [self.barView hd_bttonMuteWithTag];
    
    _moreBtn =  [barArray lastObject];

    
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

- (void)setAgoraVideo{
    // 设置音视频 options
    HDAgoraCallOptions *options = [[HDAgoraCallOptions alloc] init];
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
    _currentItem = item;
    //默认进来 中间窗口显示 坐席头像
    [self.itemView setItemString:self.agentName];
    
}
// 根据HDCallMember 创建cellItem
- (HDCallCollectionViewCellItem *)createCallerWithMember2:(HDAgoraCallMember *)aMember withView:(UIView *)view {

    [HDLog logD:@"HD===%s join 成员加入回调- 根据HDCallMember start---%@",__func__,aMember.memberName];
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

#pragma mark - 各种挂断场景
// 坐席主动 挂断 结束回调
- (void)onCallEndReason:(NSString *)desc {
    [self.hdTitleView stopTimer];
    isCalling = NO;
    [[HDAgoraCallManager shareInstance] leaveChannel];
    [self hangUpclearViewData];
}
/// 接通后 挂断
/// @param sender button
- (void)callingHangUpBtn:(UIButton *)sender{
    [HDLog logD:@"HD===%s vec1.2=====callingHangUpBtn 接通后主动点击挂断",__func__];
    isCalling = NO;
    //挂断和拒接 都走这个
    [[HDAgoraCallManager shareInstance] closeVecCall];
    [self.hdTitleView stopTimer];
    [self clearViewData];
    [self.hdVideoAnswerView endCallLayout];
}

//mark vec 独立访客端 收到坐席拒绝接通的邀请
- (void)onCallHangUpInvitation{
    
    [self offBtnClicked:nil];
    
}
- (void)onCallReceivedInvitation:(NSString *)thirdAgentNickName withUid:(NSString *)uid{
    [HDLog logD:@"HD===%s vec1.2=====onCallReceivedInvitation _thirdAgentUid=%@",__func__,uid];
    _thirdAgentNickName = thirdAgentNickName;
    
    _thirdAgentUid = uid;
    
    [self updateThirdAgent];
   
}
- (void)updateThirdAgent{
   
    if (_thirdAgentNickName.length > 0) {
    [self.smallWindowView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [HDLog logD:@"HD=== self.smallWindowView.items[idx]=%@----当前线程=%@",self.smallWindowView.items[idx],[NSThread currentThread]];
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
    [self.view addSubview: self.parentView];
    [self.parentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
    }];
    //顶部 title
    [self.parentView addSubview:self.hdTitleView];
    //中间小窗
    [self.parentView addSubview:self.smallWindowView];
    //中间打窗口
    [self.parentView addSubview:self.midelleVideoView];
    //底部view
    [self.parentView addSubview:self.barView];
    
    //添加昵称信息
    [self.parentView addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.barView.mas_top).offset(-30);
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
            
            [HDLog logD:@"HD=== 横屏"];
            [self updateCustomViewFrame:screen withScreen:YES];
        }else{
            
            [HDLog logD:@"HD=== 竖屏"];
            [self updateCustomViewFrame:screen withScreen:NO];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [HDLog logD:@"HD=== 动画播放完之后处理"];
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
//    float ratio = 16/9;
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
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44 + kApplicationStatusBarHeight);
    }];
  
    //底部功能按钮
    
    // 老界面版本
//    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            UIEdgeInsets insets = self.view.safeAreaInsets;
//            make.bottom.mas_equalTo(-insets.bottom).offset(-5);
//        } else {
//            // Fallback on earlier versions
//            make.bottom.offset(-5);
//        }
//        make.leading.offset(20);
//        make.trailing.offset(-20);
//        make.height.offset(64);
//    }];
//    [self.barView layoutIfNeeded];
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets insets = self.view.safeAreaInsets;
            make.bottom.mas_equalTo(-insets.bottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.bottom.offset(0);
        }
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(77);
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
    [self updateBgMilldelVideoView:self.midelleVideoView whiteBoard:NO];
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
//    [self.hdTitleView  modifyTextColor: [UIColor blackColor]];
//    [self.hdTitleView  modifyIconBackColor: [UIColor blackColor]];
    [self.smallWindowView setSelectCallItemChangeVideoView:bigItem withIndex:idx];

}

/// 更新大视频窗口变成小窗口）
-(void)updateBigVideoView{
    
    [_videoViews removeAllObjects];
    HDCallCollectionViewCellItem * smallItem = [_videoItemViews firstObject];
    UIView * videoView = smallItem.camView;
    if (smallItem.isWhiteboard) {
        videoView.userInteractionEnabled = YES;
        [self.hdTitleView  modifyTextColor: [UIColor blackColor]];
        [self.hdTitleView  modifyIconBackColor: [UIColor blackColor]];
    }
   
    
    self.midelleVideoView = (HDMiddleVideoView *)videoView;
    [self.parentView addSubview:videoView];
    //中间 视频窗口
    [self updateBgMilldelVideoView:videoView whiteBoard:smallItem.isWhiteboard];
    
    [_videoViews addObject:smallItem];

    //大窗昵称变成 小窗昵称
    [self changeNickNameItem:smallItem];
    
}

/// 更新大视频窗口变成小窗口）
-(void)updateBigVideoView:(HDCallCollectionViewCellItem *)item{
    
    if (self.parentView ==nil) {
        
        return;
    }
    [_videoViews removeAllObjects];
    UIView * videoView = item.camView;
    //中间 视频窗口

    [self updateBgMilldelVideoView:videoView whiteBoard:NO];
    [_videoViews addObject:item];

    //大窗昵称变成 小窗昵称
    [self changeNickNameItem:item];
    
}

- (void)updateBgMilldelVideoView:(UIView *)view whiteBoard:(BOOL)isjoinWhiteBoare{
    
//    [view removeFromSuperview];
    
    [self.parentView addSubview:view];
    
    if (isjoinWhiteBoare) {
        //开启白板 更新页面布局
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(kPointHeight );
        }];
        [view layoutIfNeeded];
       
    }else{

        [self.parentView sendSubviewToBack:view];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);
        
        }];
        
        [view layoutIfNeeded];
    }
}

    
- (void)createVideoCall{
    //这个地方是真正发消息邀请视频的代码
    
    self.isVisitorSend = YES;
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    [HDCallManager shareInstance].isVecVideo= YES;
    HDMessage *message = [HDClient.sharedClient.callManager creteVideoInviteMessageWithImId:lgM.cname content: NSLocalizedString(@"em_chat_invite_video_call", @"em_chat_invite_video_call")];
    [message addContent:lgM.visitorInfo];
    
    NSDictionary *dic = @{@"targetSystem":@"kefurtc",@"official_account":@"null"};
//    NSDictionary *dic = @{@"targetSystem":@"kefurtc"};
    [message addAttributeDictionary:dic];
    
    [self _sendMessage:message];

}
- (void)_sendMessage:(HDMessage *)aMessage
{
    
    [[HDClient sharedClient].chatManager sendMessage:aMessage
                                            progress:nil
                                          completion:^(HDMessage *message, HDError *error)
     {
        [HDLog logD:@"HD===error=%@",error];
    }];
    
}

///  控制器中大小窗昵称切换
/// @param item  获取昵称的对象
-(void)changeNickNameItem:(HDCallCollectionViewCellItem *)item{
    
    //大窗昵称变成 小窗昵称
    [self.itemView setItemString:item.nickName];
    
    self.itemView.muteBtn.selected = item.isMute;
    
    // 中间窗口
    item.camView.frame = self.parentView.frame;
    
    [self setMidelleMutedItem:item];
   
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

- (HDVideoAnswerView *)hdVideoAnswerView{
   if (!_hdVideoAnswerView) {
       _hdVideoAnswerView = [[HDVideoAnswerView alloc]init];
//       _hdVideoAnswerView.backgroundColor = [UIColor blackColor];
//       _hdVideoAnswerView.layer.borderWidth = 1;
//       _hdVideoAnswerView.layer.borderColor = [[HDAppSkin mainSkin] contentColorGrayWhithWite].CGColor;
//       _hdVideoAnswerView.layer.cornerRadius = 10.0f;
//       _hdVideoAnswerView.layer.masksToBounds = YES;
//       _hdVideoAnswerView.layer.shadowOpacity = 0.5;
//       _hdVideoAnswerView.layer.shadowRadius = 15;
       __weak __typeof__(self) weakSelf = self;
       _hdVideoAnswerView.clickOnBlock = ^(UIButton * _Nonnull btn) {
//           [weakSelf anwersBtnClicked:btn];
           // 如果是回呼需要点击接收的时候 发送cmd 通知
           if ([HDAgoraCallManager shareInstance].keyCenter.isAgentCallBackReceive) {
               //
               CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
               HDMessage * message =  [[HDClient sharedClient].callManager hd_visitorAcceptInvitationMessageWithImId:lgM.cname content:@"访客接受视频邀请"];
               [weakSelf _sendMessage:message];
               
           }
       };
       _hdVideoAnswerView.clickOffBlock = ^(UIButton * _Nonnull btn) {
           [weakSelf offBtnClicked:btn];
       };
       _hdVideoAnswerView.clickVideoOnCallBlock = ^(UIButton * _Nonnull btn) {
          //发送 视频邀请 参数
           [weakSelf createVideoCall];
       };
       _hdVideoAnswerView.clickCloseCallBlock = ^(UIButton * _Nonnull btn) {
          //真正关闭页面
           if (weakSelf.hangUpVideoCallback) {
               weakSelf.hangUpVideoCallback(weakSelf, weakSelf.hdTitleView.timeLabel.text);
           }
           if (weakSelf.hdSatisfactionView) {
               
               [weakSelf.hdSatisfactionView removeFromSuperview];
               weakSelf.hdSatisfactionView = nil;
           }
       };
    }
    return _hdVideoAnswerView;
}
- (HDTitleView *)hdTitleView {
    if (!_hdTitleView) {
        _hdTitleView = [[HDTitleView alloc]init];
//        _hdTitleView.backgroundColor = [UIColor redColor];
        kWeakSelf
        _hdTitleView.clickHideBlock = ^(UIButton * _Nonnull btn) {
             
            if (btn.selected) {
                [weakSelf __enablePictureInPicture];
            }else{
                [weakSelf __cancelPictureInPicture];
            }
            
            
        };
        _hdTitleView.clickZoomBtnBlock = ^(UIButton * _Nonnull btn) {
            [weakSelf __enablePictureInPictureZoom];
           
        };
       
    }
    return _hdTitleView;
}
- (HDControlBarView *)barView {
    if (!_barView) {
        _barView = [[HDControlBarView alloc]init];
//        _barView.backgroundColor = [UIColor redColor];
//        _barView.layer.cornerRadius = 10;
//        _barView.layer.masksToBounds = YES;
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
                    [weakSelf callingHangUpBtn:btn];
                    break;
                case HDControlBarItemTypeMessage:
                    [weakSelf showMessage];
                    break;
                case HDControlBarItemTypeShare:
                    [weakSelf shareDesktopBtnClicked:btn];
                    break;
                case HDControlBarItemTypeFlat:
                    [weakSelf onClickedFalt:btn];
                    break;
                case HDControlBarItemTypeMore:
                    [weakSelf onClickedMore:btn];
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



#pragma mark - event
/// 应答事件
/// @param sender  button
- (void)anwersBtnClicked:(UIButton *)sender{
    
    [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 anwersBtnClicked "];
    self.view.backgroundColor = [[HDAppSkin mainSkin] contentColorWhitealpha:1];
    if (self.hdVideoAnswerView.answerCallBackView) {
        [self.hdVideoAnswerView.answerCallBackView removeFromSuperview];
        self.hdVideoAnswerView.answerCallBackView = nil;
    }
    self.hdVideoAnswerView.hidden = YES;
    //应答的时候 在创建view
    //添加 页面布局
    [self addSubView];
    //默认进来调用竖屏
    [self updatePorttaitLayout];
    [self initData];
//    [self initDataNew];
    [self setAcceptCallView];
    [self.hdTitleView startTimer];
    isCalling = YES;
    _isCurrenDeviceFront = YES;
    [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 anwersBtnClicked 设置接口判断 "];
    if ([HDAgoraCallManager shareInstance].layoutModel.isVisitorCameraOff) {
        
        [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 anwersBtnClicked 设置接口进入"];
        
        [self closeCamera];
        _muteBtn.selected =YES;
        [self muteBtnClicked:_muteBtn];
    }
    
    [[HDAgoraCallManager shareInstance] acceptCallWithNickname:self.agentName
                                                        completion:^(id obj, HDError *error)
     {
      
        if (error == nil){
            
        }else{
            [HDLog logD:@"HD===anwersBtnClicked=dispatch_async%d",error.code];
            // 加入失败 或者视频网络断开
            dispatch_async(dispatch_get_main_queue(), ^{
               // UI更新代码
                [self hangUpclearViewData];
            });
        }
       
     }];
}

- (void)hangUpclearViewData{
    [self clearViewData];
    // 把vec 置为初始值
    if ([HDAgoraCallManager shareInstance].keyCenter.isAgentCallBackReceive && [HDAgoraCallManager shareInstance].keyCenter.isAgentCancelCallbackReceive ) {
    
        
    }else{
        
//        [CSDemoAccountManager shareLoginManager].isVEC = NO;
        [HDClient sharedClient].callManager.isVecVideo = NO;
    }
    
    [self.hdVideoAnswerView endCallLayout];

  
    
}

/// 拒接事件
/// @param sender button
- (void)offBtnClicked:(UIButton *)sender{
    isCalling = NO;
    // 如果是回呼需要点击接收的时候 发送cmd 通知
    if ([HDAgoraCallManager shareInstance].keyCenter.isAgentCallBackReceive) {
        //
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
       HDMessage *message=  [[HDClient sharedClient].callManager hd_visitorRejectInvitationMessageWithImId:lgM.cname content:@"访客接受视频邀请"];
        [self _sendMessage:message];
        [HDAgoraCallManager shareInstance].keyCenter.isAgentCallBackReceive = NO;
        [[HDVideoCallViewController sharedManager]  removeView];
        [[HDVideoCallViewController sharedManager] removeSharedManager];
        return;
    }

    [[HDAgoraCallManager shareInstance] endVecCall];
    [self.hdTitleView stopTimer];
    
    [self clearViewData];
    
    [self.hdVideoAnswerView endCallLayout];

    if (self.hdVideoAnswerView.hidden) {
        
        self.hdVideoAnswerView.hidden = NO;

    }
    
}
- (UIView *)parentView{
    
    if (!_parentView) {
        _parentView = [[UIView alloc] init];
    }
    
    return _parentView;
    
}


/// 初始化屏幕分享view
- (void)initBroadPickerView{
    if (@available(iOS 12.0, *)) {
        _broadPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadPickerView.preferredExtension = kScreenShareExtensionBundleId;
        _broadPickerView.showsMicrophoneButton = NO;
        _broadPickerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        
    } else {
        // Fallback on earlier versions
        [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.screenShareExtension", "video.screenShareExtension")  withWindow:self.alertWindow];
        
        
    }
}
// 切换摄像头事件
- (void)camBtnClicked:(UIButton *)btn {
    [[HDAgoraCallManager shareInstance] switchCamera];
    _isCurrenDeviceFront = !_isCurrenDeviceFront;
}

// 静音事件
- (void)muteBtnClicked:(UIButton *)btn {
//    btn.selected = !btn.selected;
    if (btn.selected) {
        [[HDAgoraCallManager shareInstance] pauseVoice];
        [self updateAudioMuted:YES byUid:kLocalUid withVideoMuted:NO];
    } else {
        [[HDAgoraCallManager shareInstance] resumeVoice];
        
        [self updateAudioMuted:NO byUid:kLocalUid withVideoMuted:NO];
    }
    [HDLog logD:@"HD===点击了静音事件"];
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
//        [[HDAgoraCallManager shareInstance] resumeVideo];
        _cameraState = YES;
        
        [self updateAudioMuted:_muteBtn.isSelected byUid:kLocalUid withVideoMuted:NO];

    }
    
}
- (void)popoverVCWithBtn:(UIButton *)btn{
    [HDLog logD:@"HD===点击了视频事件"];
    self.buttonPopVC = [[HDPopoverViewController alloc] init];
    self.buttonPopVC.popoverType = HDPopoverTypeCamera;
    HDPopoverViewControllerCellItem * item = [[HDPopoverViewControllerCellItem alloc] init];
    item.cellItemType = HDPopoverCellItemTypeCloseCamera;
    item.name =NSLocalizedString(@"video.call.close.camera", @"关闭摄像头");
    item.imgName = kshexiangtou1;
    
    HDPopoverViewControllerCellItem * item1 = [[HDPopoverViewControllerCellItem alloc] init];
    item1.name =NSLocalizedString(@"video.call.switch.camera", @"切换摄像头");
    item.cellItemType = HDPopoverCellItemTypeChangeCamera;
    item1.imgName = kqiehuanshexiangtou;
    
    NSMutableArray * items = [[NSMutableArray alloc] initWithObjects:item,item1, nil];
    
    [self.buttonPopVC setDataArrayWithModel:items];
    
    self.buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.buttonPopVC.popoverPresentationController.sourceView = btn;  //rect参数是以view的左上角为坐标原点（0，0）
    self.buttonPopVC.popoverPresentationController.sourceRect = btn.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    self.buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    self.buttonPopVC.popoverPresentationController.delegate = self;
    self.buttonPopVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.buttonPopVC animated:YES completion:nil];
}

///处理popover上的talbe的cell点击
- (void)tableDidSelected:(NSNotification *)notification {
    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
    
    NSDictionary * userInfo = notification.userInfo;
    
    HDPopoverViewController * popover = [userInfo valueForKey:@"currentClass"];
    
    HDPopoverViewControllerCellItem * item = [userInfo valueForKey:@"currentItemClass"];
    
    if (popover.popoverType == HDPopoverTypeCamera) {
        switch (indexpath.row) {
            case 0:
                //关闭摄像头
                [self closeCamera];
                break;
            case 1:
                //切换摄像头
                [HDLog logD:@"HD===点击了切换摄像头"];
                [[HDAgoraCallManager shareInstance] switchCamera];
                _isCurrenDeviceFront = !_isCurrenDeviceFront;
                break;
        
        }
        if (self.buttonPopVC) {
            [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
            self.buttonPopVC = nil;
            
        }else{
          
        }
    }else if(popover.popoverType == HDPopoverTypeMore){
        
        //点击了更多
        [self clickPopoverMore:indexpath withItemModel:item];
      
        
    }
}
- (void)closeCamera{
    [HDLog logD:@"HD===点击了关闭摄像头"];
    _cameraState = NO;
//    _cameraBtn.selected =NO;
    //更新对应状态 设置button 照片
    _cameraBtn.selected =!_cameraBtn.selected ;
//    [[HDAgoraCallManager shareInstance] pauseVideo];
    [[HDAgoraCallManager shareInstance] enableLocalVideo:NO];
    // 获取
   
    [self updateAudioMuted:_muteBtn.isSelected byUid:kLocalUid withVideoMuted:YES];

}
#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover不消失， 默认yes
}
// 扬声器事件
- (void)speakerBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
//    [[HDAgoraCallManager shareInstance] setEnableSpeakerphone:btn.selected];
    [HDLog logD:@"HD===点击了扬声器事件"];
}

#pragma mark - Call

// 成员加入回调
- (void)onMemberJoin:(HDAgoraCallMember *)member {
    [HDLog logD:@"HD===join 成员加入回调----start =%@",member.memberName];
    // 有 member 加入，添加到datasource中。
    if (isCalling) { // 只有在已经通话中的情况下，才回去在ui加入，否则都在接听时加入。
        [HDLog logD:@"HD===join 成员加入回调----isCalling =%@",member.memberName];
        @synchronized(_midelleMembers){
            BOOL isNeedAdd = YES;
            for (HDCallCollectionViewCellItem *item in _midelleMembers) {
        
                [HDLog logD:@"HD===join 成员加入回调----isCalling @synchronized for循环开始=%@",item.uid];
                if (item.uid  == [member.memberName integerValue] ) {
                    isNeedAdd = NO;
                    break;
                }
            }
            [HDLog logD:@"HD===join 成员加入回调----isCalling @synchronized for循环结束=%@",member.memberName];
            if (isNeedAdd) {
                [HDLog logD:@"HD===join 成员加入回调----isCalling isNeedAdd start=%@",member.memberName];
                if (_midelleMembers.count > 0) {

                    [HDLog logD:@"HD===join 成员加入回调----isCalling _midelleMembers=%@",member.memberName];
                    UIView * localView = [[UIView alloc] init];
                    HDCallCollectionViewCellItem * thirdItem = [self createCallerWithMember2:member withView:localView];
                    [self.smallWindowView  setThirdUserdidJoined:thirdItem];
                   
                }else{
    
                    [HDLog logD:@"HD===join 成员加入回调----isCalling isNeedAdd=%d",isNeedAdd];
                    HDCallCollectionViewCellItem * thirdItem = [self createCallerWithMember2:member withView:self.midelleVideoView];
                    [_midelleMembers addObject: thirdItem];
                }
            }
            
        };
        

        [HDLog logD:@"HD===join 成员加入回调----@synchronized 加入成员结束- 开始执行updateThirdAgent= %@",member.memberName];
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
    [HDLog logD:@"HD===onMemberExit Member start =%@",member.memberName];
    //先判断房间里边有没有人 如果么有人  删除界面
    if ([HDAgoraCallManager shareInstance].hasJoinedMembers.count ==0) {
        //退出 界面
        [self  onCallEndReason:@"房间里没有人挂断会话"];
        return;
    }
    
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
          
            [self.smallWindowView removeCurrentCellItem:samllItem];
            [self.smallWindowView reloadData];
        
            // 把删除的view 移除掉
            [deleteItem.camView removeFromSuperview];
            [self updateBigVideoView:samllItem];
        
          
        }
        
    }
    
}

/// 远端用户音频静音通知
/// @param muted  是否静音
/// @param uid  静音的用户 uid
- (void)onCalldidAudioMuted:(BOOL)muted byUid:(NSUInteger)uid{
    
    [self updateAudioMuted:muted byUid:uid withVideoMuted:NO];
    
}
- (void)onCalldidVideoMuted:(BOOL)muted byUid:(NSUInteger)uid{
    
    [self updateAudioMuted:NO byUid:uid withVideoMuted:muted];
    
}

- (void)updateAudioMuted:(BOOL)muted byUid:(NSUInteger)uid withVideoMuted:(BOOL)videoMuted{
    
    // 根据uid 找到用户 然后刷新一下界面
    BOOL  __block isSmallVindow = NO;
    [self.smallWindowView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDCallCollectionViewCellItem *item = obj;
        if (item.uid == uid) {
            isSmallVindow = YES;
            [HDLog logD:@"HD===uid===%lu",(unsigned long)uid];
            item.isMute = muted;
            item.isVideoMute = videoMuted;
            [self.smallWindowView setAudioMuted:item];
            *stop = YES;
        }
    }];
    
    if (!isSmallVindow) {
        //说明需要更新 中间窗口的下边的麦克风
        self.itemView.muteBtn.selected = muted;
        
        [_videoViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HDCallCollectionViewCellItem *item = obj;
            NSLog(@"%ld----%@",(long)item.uid,[NSThread currentThread]);
            if (item.uid == uid) {
                item.isVideoMute = videoMuted;
                item.isMute = muted;
                [self.itemView setItemString:item.nickName];
                [self  setMidelleMutedItem:item];
                *stop = YES;
            }
        }];
    }
}
- (void)setMidelleMutedItem:(HDCallCollectionViewCellItem *)item{
    
    if (item.isVideoMute) {
        //修改一下背景
        [item.closeCamView removeFromSuperview];
        item.closeCamView = nil;
        item.closeCamView = [[UIView alloc] initWithFrame:item.camView.frame];
        item.closeCamView.backgroundColor =  [[HDAppSkin mainSkin] contentColorGray];
    
        //添加 笑脸图片
        UIImageView * bgImgView= [[UIImageView alloc]init];
        [item.closeCamView addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(item.closeCamView);
            make.centerX.mas_equalTo(item.closeCamView);
            make.width.height.offset(64);
            
        }];
        [bgImgView layoutIfNeeded];
        UIImage * img = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:bgImgView.hd_size.width color:[[HDAppSkin mainSkin] contentColorGray1] ];
        bgImgView.image = img;
        
        [item.camView addSubview:item.closeCamView];
        [self.hdTitleView  modifyTextColor: [UIColor blackColor]];
        [self.hdTitleView  modifyIconBackColor: [UIColor blackColor]];
    }else{
        if (item.isWhiteboard) {
            [self.hdTitleView  modifyTextColor: [UIColor blackColor]];
            [self.hdTitleView  modifyIconBackColor: [UIColor blackColor]];
        }else{
        [self.hdTitleView  modifyTextColor: [UIColor whiteColor]];
        [self.hdTitleView  modifyIconBackColor: [UIColor whiteColor]];
        }
        [item.closeCamView removeFromSuperview];

    }
    
}

#pragma mark -  互动白板 相关

//接收cmd 消息过来
- (void)onRoomDataReceivedParameter:(NSDictionary *)roomData{
  
    //互动白板加入成功以后 屏幕共享 不能使用 不能创建白板房间
    if (_videoViews.count == 0) {
        return;
    }
    if (_shareState) {
        //当前正在共享
        return;
    }
    [[HDWhiteRoomManager shareInstance] hd_setValueFrom:roomData];
    [self updateBgMilldelVideoView:self.whiteBoardView whiteBoard:YES];

}


// 互动白板
- (void)onClickedFalt:(UIButton *)sender
{
    if (_shareState) {
        //当前正在共享
        //当前正在白板房间
        _whiteBoardBtn.selected = !_shareState;
        [MBProgressHUD  dismissInfo:NSLocalizedString(@"video_call_shareScreen_not_swhiteBoard", "video_call_shareScreen_not_swhiteBoard")  withWindow:self.alertWindow];
        return;
    }
    _whiteBoardBtn = sender;
    if ([HDWhiteRoomManager shareInstance].roomState) {
        
        return;
    }

    _hud = [MBProgressHUD showTitle:NSLocalizedString(@"video_call_whiteBoard_join", @"video_call_whiteBoard_join") toView:self.alertWindow withTimeOut:kShowTimeOut];
    [self hideInvalidate:YES afterDelay:kShowTimeOut];
    // 创建白板产生
    [[HDWhiteRoomManager shareInstance] hd_joinVECRoom];
    
}
- (void)onFastboardDidJoinRoomFail{
    
    [self handleHideTimerShow:YES];
    NSLog(@"===========加入失败");
    [HDLog logD:@"HD===加入失败"];
    [self.whiteBoardView removeFromSuperview];
}
- (void)onFastboardDidJoinRoomSuccess{
    
    [self handleHideTimerShow:NO];
    
    self.whiteBoardView.hidden = NO;
    //只有加入成功才会替换
    HDCallCollectionViewCellItem  * midelleViewItem =  [_videoViews firstObject];
    [self.smallWindowView setThirdUserdidJoined:midelleViewItem];
    [self.smallWindowView reloadData];
    
    HDCallCollectionViewCellItem *item = [[HDCallCollectionViewCellItem alloc] init];
    item.uid = kLocalWhiteBoardUid;
    item.realUid = kLocalUid;
    [HDWhiteRoomManager shareInstance].uid = [NSString stringWithFormat:@"%ld",(long)item.realUid];
    item.isWhiteboard = YES;
    item.nickName = NSLocalizedString(@"video_call_whiteBoard_nickName", "video_call_whiteBoard_nickName") ;
    item.camView = self.whiteBoardView;
    
    //先取出中间试图的model 放到 小窗口  然后把白板的试图放到中间窗口
    [_videoViews replaceObjectAtIndex:0 withObject:item];
    [self changeNickNameItem:item];
    _whiteBoardBtn.selected = [HDWhiteRoomManager shareInstance].roomState;
    [self.parentView bringSubviewToFront:[_videoViews firstObject]];
    
    [self.hdTitleView  modifyTextColor: [UIColor blackColor]];
    [self.hdTitleView  modifyIconBackColor: [UIColor blackColor]];
    
}
//  清理白板 数据
- (void)clearWhiteBoardData{
    
    //1、退出白板房间
    [[HDWhiteRoomManager shareInstance] hd_OnLogout];
    
    //2、关闭上传 等view上的操作
    [[HDUploadFileViewController sharedManager] removeSharedManager];
    
    
}

-(HDWhiteBoardView *)whiteBoardView{
    
    if (!_whiteBoardView) {
        
        _whiteBoardView = [[HDWhiteBoardView alloc] init];
        __weak __typeof(self) weakSelf = self;
        _whiteBoardView.hidden = YES;
        _whiteBoardView.clickWhiteBoardViewBlock = ^(HDClickButtonType type, UIButton * _Nonnull btn) {
            
            [weakSelf clickWhiteBoardView:type withBtn:btn];
            
        };
        _whiteBoardView.fastboardDidJoinRoomSuccessBlock = ^{
            [weakSelf onFastboardDidJoinRoomSuccess];
        };
        _whiteBoardView.fastboardDidJoinRoomFailBlock = ^{
            [weakSelf onFastboardDidJoinRoomFail];
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
            //退出确认提示
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
    [HDLog logD:@"HD===%d",sender.isSelected];
    if (sender.isSelected) {
        NSLog(@"sender.isSelected");
        if (self.isLandscape) {
            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);

            }];
            [self.parentView sendSubviewToBack:whiteView];
        }else{

            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(kApplicationStatusBarHeight);
//                make.top.mas_equalTo(self.hdTitleView.mas_bottom).offset(10);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);
            }];
            [whiteView layoutIfNeeded];
            [self.parentView bringSubviewToFront:whiteView];
        }
    }else{
        [HDLog logD:@"HD===点击了互动白板事件"];
        if (self.isLandscape) {
            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);

            }];
            [self.parentView sendSubviewToBack:whiteView];
        }else{

            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.smallWindowView.mas_bottom).offset(44);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.height.offset(kPointHeight);
            }];
            [whiteView layoutIfNeeded];
//            [self.parentView bringSubviewToFront:whiteView];
            
            
        }
    }
    
    [self.whiteBoardView reloadFastboardOverlayWithScle:YES];
    
 
    
}
- (void)uploadFile{
   
    [HDUploadFileViewController sharedManager];
    
   
}
- (void)disconnectRoomAlert{
    
    [self showAlertWithTitle:NSLocalizedString(@"uploading...", "Upload attachment")
                actionTitles:@[NSLocalizedString(@"uploading...", "Upload attachment")]
                 cancelTitle:NSLocalizedString(@"uploading...", "Upload attachment")
                    callBack:^(NSInteger index) {
        
        [self disconnectRoom];
        
    }];
}
- (void)disconnectRoom{
   
    if (self.isSmallWindow) {
        
        [self __cancelPictureInPicture];
        
    }
    
    for (HDCallCollectionViewCellItem * tmpItem in self.smallWindowView.items) {
        
        NSLog(@"======%@",tmpItem.nickName);
    }
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
    
    //修改顶部 标题字体颜色
    [self.hdTitleView modifyTextColor:[UIColor whiteColor]];
    [self.hdTitleView  modifyIconBackColor: [UIColor whiteColor]];
    _whiteBoardBtn.selected = [HDWhiteRoomManager shareInstance].roomState;
    
}
#pragma mark - 屏幕共享相关
// 屏幕共享事件
- (void)shareDesktopBtnClicked:(UIButton *)btn {
    
    _shareBtn = btn;
    _shareBtn.selected = _shareState;
   
    if ([HDWhiteRoomManager shareInstance].roomState == YES) {
        //当前正在白板房间
        [MBProgressHUD  dismissInfo:NSLocalizedString(@"video_call_whiteBoard_not_shareScreen", "video_call_whiteBoard_not_shareScreen")  withWindow:self.alertWindow];
        return;
    }
    /// 初始化屏幕分享
    [self initScreenShare];
    
    //点击的时候先要 保存屏幕共享的数据
    [[HDAgoraCallManager shareInstance] hd_saveShareDeskData:[HDAgoraCallManager shareInstance].keyCenter];
    
    sleep(0.5);
    //通过UserDefaults建立数据通道
    [self setupUserDefaults];
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
    [HDLog logD:@"HD===点击了屏幕共享事件"];
}


#pragma mark - 进程间通信-CFNotificationCenterGetDarwinNotifyCenter 使用之前，需要为container app与extension app设置 App Group，这样才能接收到彼此发送的进程间通知。
// 录屏直播 主App和宿主App数据共享，通信功能实现 如果我们要将开始、暂停、结束这些事件以消息的形式发送到宿主App中，需要使用CFNotificationCenterGetDarwinNotifyCenter。
- (void)setupUserDefaults{
    // 通过UserDefaults建立数据通道，接收Extension传递来的视频帧
  
    [[HDAgoraCallManager shareInstance].userDefaults setObject:@{@"state":@"x"} forKey:kUserDefaultState];//给状态一个默认值
    [[HDAgoraCallManager shareInstance].userDefaults addObserver:self forKeyPath:kUserDefaultState options:NSKeyValueObservingOptionNew context:KVOContext];
//    [self.userDefaults addObserver:self forKeyPath:kUserDefaultFrame options:NSKeyValueObservingOptionNew context:KVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kUserDefaultState]) {
        NSDictionary *string = change[NSKeyValueChangeNewKey];
        if ([string[@"state"] isEqual:@"初始化"]) {
            //开启 RTC：外部视频输入通道，开始推送屏幕流（configLocalScreenPublish）
//            [self screenShareStart];
            
            NSLog(@"== 屏幕分享开始=====%@",string);
            _shareState= YES;
            _shareBtn.selected = _shareState;
        
        }
        if ([string[@"state"] isEqual:@"停止"]) {
            //关闭 RTC：外部视频输入通道，停止推送屏幕流
//            [self screenShareStop];
            NSLog(@"== 屏幕分享停止=====%@",string);
            _shareState= NO;
            //更改按钮的状态
            _shareBtn.selected = _shareState;
        }
        return;
    }else if ([keyPath isEqualToString:@"text"]) {
        NSString *string = change[NSKeyValueChangeNewKey];
        if (self.hdSupendCustomView) {
            [self.hdSupendCustomView  updateTimeText:string];
        }
        
    }
}
#pragma mark - Picture in picture  相关

- (void)__enablePictureInPicture{

    if (self.hdMessageView) {
        
        [self hideVideoMessage];
    }
    
    [self.view hideKeyBoard];
    self.isSmallWindow = YES;
    self.alertWindow.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
//    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
    
//    self.alertWindow.layer.borderWidth = 1;
//    self.alertWindow.layer.borderColor = [UIColor blackColor].CGColor;
    self.alertWindow.layer.shadowOpacity = 0.5;
    self.alertWindow.layer.shadowRadius = 15;
    

    if ([HDWhiteRoomManager shareInstance].roomState) {
        // 先去 小窗拿 如果没有在去中间拿
        if (_videoViews.count > 0) {
            HDCallCollectionViewCellItem * tmpItem = [_videoViews firstObject];
//            [self.view  sendSubviewToBack:tmpItem.camView];
            [self updateBgMilldelVideoView:tmpItem.camView whiteBoard:NO];

            self.smallWindowView.hidden = YES;
            self.barView.hidden = YES;
        }

        [self.whiteBoardView hd_ModifyStackViewLayout:self.hdTitleView withScle:YES];
        [self.whiteBoardView hdmas_remakeConstraints:^(MASConstraintMaker * _Nonnull make) {

            make.top.offset(self.hdTitleView.hd_size.height);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);

        }];

    }else{

        self.barView.hidden = YES;

    }
    
    if (_videoViews.count > 0) {
        HDCallCollectionViewCellItem * tmpItem = [_videoViews firstObject];

        if (tmpItem.isVideoMute) {
            tmpItem.closeCamView.frame = self.alertWindow.frame;
        }
      
    }
    
    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);

    }];

}
- (void)__cancelPictureInPicture{
   
    [self.view hideKeyBoard];
    self.isSmallWindow = NO;
    self.alertWindow.frame = [UIScreen mainScreen].bounds;
//    self.alertWindow.layer.borderWidth = 0;
//    self.alertWindow.layer.borderColor = [UIColor blackColor].CGColor;
    if ([HDWhiteRoomManager shareInstance].roomState) {
        // 先去 小窗拿 如果没有在去中间拿
        if (_videoViews.count > 0) {
            HDCallCollectionViewCellItem * tmpItem = [_videoViews firstObject];
            [self updateBgMilldelVideoView:tmpItem.camView whiteBoard:YES];

            self.smallWindowView.hidden = NO;
            self.barView.hidden = NO;
        }
        [self.whiteBoardView hd_ModifyStackViewLayout:self.hdTitleView withScle:NO];
    }else{
        self.smallWindowView.hidden = NO;
        self.barView.hidden = NO;
    }
    if (_videoViews.count > 0) {
        HDCallCollectionViewCellItem * tmpItem = [_videoViews firstObject];
        if (tmpItem.isVideoMute) {
            tmpItem.closeCamView.frame = self.alertWindow.frame;
        }
    }
    
    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.barView.mas_top).offset(-30);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);

    }];
}

#pragma mark - Picture in picture 中 隐藏效果
- (void)createBaseUI{
    if (_suspendType==BUTTON) {
        viewWidth=80;
        viewHeight=80;
    }else if (_suspendType==IMAGEVIEW){
        viewWidth=100;
        viewHeight=100;
    }else if (_suspendType==GIF){
        viewWidth=100;
        viewHeight=100;
        
    }else if (_suspendType==MUSIC){
        viewWidth=150;
        viewHeight=100;
    }else if (_suspendType==VIDEO){
        viewWidth=200;
        viewHeight=150;
    }else if (_suspendType==SCROLLVIEW){
        viewWidth=200;
        viewHeight=200;
    }else if (_suspendType==OTHERVIEW){
        viewWidth=88;
        viewHeight=88;
    }
    NSString *type=[NSString stringWithFormat:@"%ld",(long)_suspendType];
    _hdSupendCustomView=[self createCustomViewWithType:type];
    _customWindow=[self createCustomWindow];
    
    [_customWindow addSubview:_hdSupendCustomView];
    [_customWindow makeKeyAndVisible];
    
}
- (HDSuspendCustomView *)createCustomViewWithType:(NSString *)type{
    if (!_hdSupendCustomView) {
        _hdSupendCustomView=[[HDSuspendCustomView alloc]init];
        _hdSupendCustomView.viewWidth=viewWidth;
        _hdSupendCustomView.viewHeight=viewHeight;
        [_hdSupendCustomView initWithSuspendType:type];
        _hdSupendCustomView.frame=CGRectMake(0, 0, viewWidth, viewHeight);
        _hdSupendCustomView.suspendDelegate=self;
        _hdSupendCustomView.rootView=self.view;
    }

    return _hdSupendCustomView;
}

- (UIWindow *)createCustomWindow{
     if (!_customWindow) {
        _customWindow=[[UIWindow alloc]init];
        _customWindow.frame=CGRectMake(WINDOWS.width-viewWidth,WINDOWS.height/4.6, viewWidth, viewHeight);
        _customWindow.windowLevel=UIWindowLevelAlert+2;
        _customWindow.backgroundColor=[UIColor clearColor];
        
    }
    return _customWindow;
}

//悬浮视图消失
- (void)cancelWindow{
    [_customWindow resignFirstResponder];
    [_customWindow removeFromSuperview];
    _customWindow=nil;
}

#pragma mark --SuspendCustomViewDelegate

- (void)suspendCustomViewClicked:(id)sender{
    self.alertWindow.hidden = NO;
    self.view.hidden = NO;
    _hdSupendCustomView.hidden = !self.view.hidden;
    [self.hdTitleView.timeLabel removeObserver:self forKeyPath:@"text"];
    
    [self cancelWindow];

}
- (void)dragToTheLeft{
    NSLog(@"左划到左边框了");

}
- (void)dragToTheRight{
    NSLog(@"右划到右边框了");

}
- (void)dragToTheTop{
    NSLog(@"上滑到顶部了");

}
- (void)dragToTheBottom{
    NSLog(@"下滑到底部了");
}

- (void)__enablePictureInPictureZoom{

    self.alertWindow.hidden = YES;
    self.view.hidden = YES;

    self.suspendType = OTHERVIEW;
    [self createBaseUI];
    
    _hdSupendCustomView.hidden = !self.view.hidden;

    [self.hdTitleView.timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
  
}

#pragma mark --vec 1.3 相关
#pragma mark - vec 1.3 弹窗  中 效果

#pragma mark - 收到cmd 各种通知 原子化能力
//mark vec 1.3 独立访客端 收到坐席 签名
- (void)onCallSignIdentify:(NSDictionary *)dic{
    if (!isCalling) {
        return;
    }
    // 获取flowid
    _signflowId = [self getFlowId:dic];
    [self hd_hiddenPictureInPictureScreen];
    [self.view addSubview:self.hdSignView];
    [self saveTaskQueue:HDVideoCallTaskSign];
    [self.hdSignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(5);
        make.trailing.offset(-5);
        make.bottom.offset (-5);
        make.height.offset(self.view.hd_height*0.45);
        
    }];
}
//mark vec 1.3 独立访客端 收到坐席 身份认证
- (void)onCallFaceIdentify:(NSDictionary *)dic{
    if (!isCalling) {
        return;
    }
    // 获取flowid
    _faceflowId = [self getFlowId:dic];
    if ( [self isFlowEndAction:dic]) {
        [self showCallingOtherView:YES];
       
    }else{
        //摄像头 相关操作
        [self saveTaskQueue:HDVideoCallTaskFace];
        [self hiddenCallingOtherView];
        [self createVECGeneralBaseUI:HDVideoIDCardScaningViewTypeFace];
    }
}
//mark vec 1.3 独立访客端 收到坐席 ocr 识别
- (void)onCallLOcrIdentify:(NSDictionary *)dic{
    if (!isCalling) {
        return;
    }
    // 获取flowid
    _ocrflowId = [self getFlowId:dic];
    if ( [self isFlowEndAction:dic]) {
        [self showCallingOtherView:YES];
    }else{
        [self saveTaskQueue:HDVideoCallTaskIDCard];
        
        [self hiddenCallingOtherView];
        [self createVECGeneralBaseUI:HDVideoIDCardScaningViewTypeIDCard];
        
    }
}

- (void)onCallLinkMessagePush:(NSDictionary *)dic{
    if (!isCalling) {
        return;
    }
    // 获取flowid
    _pushflowId = [self getFlowId:dic];
    
    //创建 webview 加载 url
    if ([[dic allKeys] containsObject:@"content"]) {
        
//        NSString * iframe = [dic objectForKey:@"type"];
        
        NSDictionary *contentDic =[dic objectForKey:@"content"];
        float  heightRatio = 0.5;
        if (contentDic) {
            // iframe 页面
            heightRatio = [[contentDic objectForKey:@"heightRatio"] floatValue];
            NSString * content = [contentDic objectForKey:@"content"];
            NSString * link = [contentDic objectForKey:@"type"];
            [self hd_hiddenPictureInPictureScreen];
            if (![link isKindOfClass:[NSNull class]] && link.length > 0 ) {
                
                if ([link isEqualToString:@"link"]) {
                    [self.view addSubview:self.hdVideoLinkMessagePush];
                    [self saveTaskQueue:HDVideoCallTaskPush];
                    [self.hdVideoLinkMessagePush mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.offset(0);
                        make.trailing.offset(0);
                        make.bottom.offset (0);
                        make.height.offset(self.view.hd_height*heightRatio);
                        
                    }];
                    [self.hdVideoLinkMessagePush setWebUrl:content];
                }
                // 以后其他类型
               
            }
           
        }

    }else{
        
        [self.view addSubview:self.hdVideoLinkMessagePush];
        [self saveTaskQueue:HDVideoCallTaskPush];
        [self.hdVideoLinkMessagePush mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset (0);
            make.height.offset(self.view.hd_height*0.5);
            
        }];
        
        [self.hdVideoLinkMessagePush setWebUrl:@"http://baidu.com"];
    }
}
#pragma mark - 收到cmd通知 创建对应view
- (void)createVECGeneralBaseUI:(HDVideoIDCardScaningViewType )ScanType{
    
    //切换摄像头
    [self hd_ocrSwitchCamera:ScanType];
    
    // 先去判断 当前中间的item 是不是本地的 如果是 不动。隐藏小窗就行了。如果不是 需要去小窗里边拿  然后把 小窗移除的一次掉
    if (_videoViews.count > 0) {
        HDCallCollectionViewCellItem *citem =[_videoViews firstObject];
        if (citem.uid == kLocalUid) {
            //说明 进行切换过了 并且在中间
        }else{
            [self.smallWindowView.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HDCallCollectionViewCellItem *item = obj;
                NSLog(@"%ld----%@",(long)item.uid,[NSThread currentThread]);
                if (item.uid == kLocalUid) {
//                    isCardSmallVindow = YES;
                    NSLog(@"==uid===%lu",(unsigned long)item.uid);
                    [self.smallWindowView removeCurrentCellItem:item];

                    // 把本地 item 加入到 新创建的页面当中
                    UIView *v =item.camView;
                    [self.ocrView addSubview: v];
                    [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                        CGFloat width;
                        if (ScanType == HDVideoIDCardScaningViewTypeIDCard) {
                        if (_isSmallWindow) {
                         
                            width =  [UIScreen mainScreen].bounds.size.width;
                            CGFloat heigth =  self.view.frame.size.height;
                            make.width.offset(width);
                            make.height.offset(heigth* 0.7);
                            
                        }else{
                            
                            width =  [UIScreen mainScreen].bounds.size.width;
                            make.width.offset(width);
                            make.height.offset(width*1.5);
                        }
                        }else{
                            
                          
                            make.width.offset(self.view.frame.size.width);
                            make.height.offset(self.view.frame.size.height);
                        }
                        make.centerX.mas_equalTo(self.ocrView.mas_centerX).offset(0);
                        make.centerY.mas_equalTo(self.ocrView.mas_centerY).offset(0);
                       
                    }];
                    
                    [self.view addSubview:self.ocrView];
                    _ocrItem= item;
                    *stop = YES;
                }
            }];
        }
    }
    // 添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
//    HDVideoIDCardScaningView *idCardScaningView = [[HDVideoIDCardScaningView alloc] initWithFrame:self.view.frame];
    [self.idCardScaningView setVideoScanType:ScanType withISSmallWindow:_isSmallWindow];
//    self.idCardScaningView =idCardScaningView;
    [self.view addSubview:self.idCardScaningView];
    
}
#pragma mark - 页面懒加载
- (HDVideoIDCardScaningView *)idCardScaningView{
    if (!_idCardScaningView) {
        _idCardScaningView = [[HDVideoIDCardScaningView alloc] initWithFrame:self.view.frame];
    }
    
    
    return _idCardScaningView;
}
- (HDVideoLinkMessagePush *)hdVideoLinkMessagePush{
    if (!_hdVideoLinkMessagePush) {
        _hdVideoLinkMessagePush = [[HDVideoLinkMessagePush alloc] init];
        _hdVideoLinkMessagePush.layer.cornerRadius = 5.0f;
        _hdVideoLinkMessagePush.layer.masksToBounds = YES;
        _hdVideoLinkMessagePush.layer.shadowOpacity = 0.5;
        _hdVideoLinkMessagePush.layer.shadowRadius = 15;
        kWeakSelf
        _hdVideoLinkMessagePush.clickIframeCloseBlock = ^(NSString *  content) {
            
            [weakSelf pushBusinessreport:content];
            [weakSelf hd_showPictureInPictureScreen];
        };
       
    }
    return  _hdVideoLinkMessagePush;
    
}
- (HDSignView *)hdSignView{
    if (!_hdSignView) {
        _hdSignView = [[HDSignView alloc] init];
        _hdSignView.delegate = self;
        _hdSignView.layer.cornerRadius = 5.0f;
        _hdSignView.layer.masksToBounds = YES;
        _hdSignView.layer.shadowOpacity = 0.5;
        _hdSignView.layer.shadowRadius = 15;
    }
    return  _hdSignView;
}
- (UIView *)ocrView{
    
    if (!_ocrView) {
        _ocrView = [[UIView alloc] initWithFrame:self.view.frame];
//        _ocrView.backgroundColor = [UIColor redColor];
        
    }
    
    return _ocrView;
}
#pragma mark - 事件处理
- (void)pushBusinessreport:(NSString *)content{
    
    [self clearQueueTask];
    // 上报 信息推送
    [[HDClient sharedClient].callManager hd_pushBusinessReportWithFlowId:_pushflowId withAction:@"infopush_end" withType:@"infopush" withUrl:@"" withContent:content Completion:^(id responseObject, HDError * error) {
        
        NSLog(@"====%@",responseObject);
        
    }];
    
}
//隐藏 视频通话 中相关的页面
- (void)hiddenCallingOtherView{
    self.smallWindowView.hidden = YES;
    self.hdTitleView.hidden = YES;
    self.barView.hidden= YES;
    self.itemView.hidden = YES;
    
}
- (void)showCallingOtherView:(BOOL)isSwitchCamera{
    
    self.itemView.hidden = NO;
    self.smallWindowView.hidden = NO;
    self.hdTitleView.hidden = NO;
    
    if (!_isSmallWindow) {
        self.barView.hidden= NO;
    }
    
    [_idCardScaningView removeFromSuperview];
    _idCardScaningView = nil;
    if (self.ocrView == nil || _ocrItem == nil) {
        
    }else{
        // 在把 当前小窗 加进去
        [_ocrItem.camView removeFromSuperview];
        [self.ocrView removeFromSuperview];
        self.ocrView = nil;
        [self.smallWindowView addCurrentCellItem:_ocrItem];
        _ocrItem = nil;
    }
    if (isSwitchCamera) {
        //需要还原原来摄像头状态
        if (_isOcrCloseSwitchCamera) {
            // 如果不是前置摄像头 需要自动切换摄像头
            [[HDAgoraCallManager shareInstance] switchCamera];
            _isOcrCloseSwitchCamera = NO;
        }
    }
}
// 接到ocr 以后 判断需不需要切换摄像头
- (void)hd_ocrSwitchCamera:(HDVideoIDCardScaningViewType )ScanType{
    
    if (ScanType == HDVideoIDCardScaningViewTypeIDCard) {
       
        //需要前置 摄像头
        if (_isCurrenDeviceFront) {
            // 如果不是前置摄像头 需要自动切换摄像头
            [[HDAgoraCallManager shareInstance] switchCamera];
            _isOcrCloseSwitchCamera = YES;
        }else{
            
            _isOcrCloseSwitchCamera = NO;
        }
        
    }else{
        
        //需要前置 摄像头
        if (!_isCurrenDeviceFront) {
            // 如果不是前置摄像头 需要自动切换摄像头
            [[HDAgoraCallManager shareInstance] switchCamera];
            _isOcrCloseSwitchCamera = YES;
        }else{
            
            _isOcrCloseSwitchCamera = NO;
        }
    }
}
// 隐藏画中画半屏 按钮功能
- (void)hd_hiddenPictureInPictureScreen{
    
    self.hdTitleView.hideBtn.hidden = YES;
    
}
// 显示画中画半屏按钮功能
- (void)hd_showPictureInPictureScreen{
    
    self.hdTitleView.hideBtn.hidden = NO;
    
}

- (BOOL)isFlowEndAction:(NSDictionary *)msgTypeDic{
    
    if ([[msgTypeDic allKeys] containsObject:@"action"]) {
        
        NSString * action = [msgTypeDic objectForKey:@"action"];
        
        if ([action containsString:@"end"]) {
            [self clearQueueTask];
            return YES;
        }
        
        return NO;
    }
    
    return NO;
    
}
- (NSString *)getFlowId:(NSDictionary *)msgTypeDic{
   
    if ([[msgTypeDic allKeys] containsObject:@"flowId"]) {
        
        NSString * flowId = [msgTypeDic objectForKey:@"flowId"];
        
        return [NSString stringWithFormat:@"%@",flowId];
    
    }else{
        return @"";
    }
}
#pragma mark --HDSignDelegate
- (void)hdSignCompleteWithImage:(UIImage *)img base64Data:(nonnull NSData *)base64data{
    
    _hud = [MBProgressHUD showMessag:NSLocalizedString(@"", @"") toView:self.hdSignView];
    [[HDClient sharedClient].callManager hd_commitSignData:base64data  WithVisitorId:@"" withFlowId:_signflowId  Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        [_hud hideAnimated:YES];
        if (error ==nil) {
            
            NSLog(@"===hdSignCompleteWithImage==%@",responseObject);
            
            [MBProgressHUD dismissInfo:NSLocalizedString(@"new_leave_send_success", @"new_leave_send_success") withWindow:self.alertWindow];
            
            //移除 签名界面
            [self.hdSignView removeFromSuperview];
            self.hdSignView = nil;
            [self hd_showPictureInPictureScreen];
            [self clearQueueTask];
            
        }else{
            NSLog(@"=====%@",error.errorDescription);
            NSString *str = [NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"video.vec.atomized.submit_fail", @"video.vec.atomized.submit_fail"),error.errorDescription];
            
            [MBProgressHUD dismissInfo:str withWindow:self.alertWindow];
        }
        
    }];
}
//
#pragma mark --vec 1.3 满意度
- (void)onEnquiryInviteParameter:(NSDictionary *)enquiryInvite withMessage:(HDMessage *)message{
    
    if (self.hdVideoAnswerView.processType != HDVideoProcessLineUp) {
        
    [self.hdVideoAnswerView addSubview:self.hdSatisfactionView];
    
    [self.hdSatisfactionView setEnquiryInvite:enquiryInvite withModel:message];
    
    [self.hdVideoAnswerView bringSubviewToFront:self.hdSatisfactionView];
    }
}
- (void)hd_upateFrame:(CGFloat)height{
    
    if (height == 0) {
        
        height = self.view.frame.size.height *0.5;
    }
    
    [self.hdSatisfactionView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.leading.offset(10);
        make.trailing.offset(-10);
        make.bottom.offset (-10);
        make.height.offset(height);
        
    }];
    
    [self.hdSatisfactionView layoutIfNeeded];
}
- (HDSatisfactionView *)hdSatisfactionView{
    
    if (!_hdSatisfactionView) {
        _hdSatisfactionView = [[HDSatisfactionView alloc] init];
        _hdSatisfactionView.layer.cornerRadius = 5.0f;
        _hdSatisfactionView.layer.masksToBounds = YES;
        _hdSatisfactionView.layer.shadowOpacity = 0.5;
        _hdSatisfactionView.layer.shadowRadius = 15;
        _hdSatisfactionView.backgroundColor = [UIColor whiteColor];
        kWeakSelf
        _hdSatisfactionView.updateSelfFrame = ^(CGFloat height) {
            [weakSelf hd_upateFrame:height];
        };

    }
    
    return _hdSatisfactionView;
}
#pragma mark --vec 1.4  远程协助
/*!
 *  \~chinese
 *   麦克风 通知
 */
- (void)onMuteLocalAudioStreamParameter:(NSDictionary *)dic{

    if (dic && [[dic allKeys] containsObject:@"action"]) {

        if ([[dic valueForKey:@"action"] isEqualToString:@"on"]) {

            _muteBtn.selected =NO;
        }else{

            _muteBtn.selected =YES;

        }
        [self muteBtnClicked:_muteBtn];
    }
    
    [self sendCmdMessageAction:@"microphonecallback" withOn:YES withContent:@""];
}
/*!
 *  \~chinese
 *   摄像头
 */
- (void)onMuteLocalVideoStreamParameter:(NSDictionary *)dic{
    
    
    if (dic && [[dic allKeys] containsObject:@"action"]) {

        if ([[dic valueForKey:@"action"] isEqualToString:@"on"]) {
            _cameraState=NO;
        }else{

            _cameraState =YES;

        }
    }
    
    //默认进来判断获取摄像头状态
    //1、如果是关闭  点击直接打开摄像头
    //2、如果是开启的 点击按钮 谈窗
//        1、点击关闭摄像头  调用关闭摄像头方法 并且 更改当前btn 图片状态
//        2、点击切换摄像头  调用切换摄像头方法
    if (_cameraState) {
        //开启
     
        [self closeCamera];
       
        
    }else{
        //当前摄像头关闭 需要打开
        [[HDAgoraCallManager shareInstance] enableLocalVideo:YES];
//        [[HDAgoraCallManager shareInstance] resumeVideo];
        _cameraState = YES;
        _cameraBtn.selected =!_cameraBtn.selected ;
        [self updateAudioMuted:_muteBtn.isSelected byUid:kLocalUid withVideoMuted:NO];

    }
    [self sendCmdMessageAction:@"cameraacallback" withOn:YES withContent:@""];
}
/*!
 *  \~chinese
 *   切换摄像头
 */
- (void)onSwitchCameraParameter:(NSDictionary *)dic{
    
    [self camBtnClicked:_cameraBtn];
    
    [self sendCmdMessageAction:@"cameraChangecallback" withOn:YES withContent:@""];
    
}
/*!
 *  \~chinese
 *   对焦、
 */
- (void)onFocusingOnParameter:(NSDictionary *)dic{
    
    BOOL state = NO;
    NSString *content=@"";
    if ([HDAgoraCallManager shareInstance].isCameraFocusPositionInPreviewSupported) {
        
        NSLog(@"=====1111========%d",[HDAgoraCallManager shareInstance].isCameraFocusPositionInPreviewSupported);
        
        if ([[HDAgoraCallManager shareInstance] setCameraFocusPositionInPreview:CGPointMake(self.view.center.x, self.view.center.y)]) {
            state = YES;
            // 创建 对焦窗口
            [self.view addSubview:self.hdCameraFocusView];
            HDCallCollectionViewCellItem * bigItem =[_videoViews firstObject];
            if (bigItem.uid == kLocalUid) {
                self.hdCameraFocusView.hidden = NO;
                
            }else{
                self.hdCameraFocusView.hidden = YES;
            }
            self.hdCameraFocusView.alpha = 1;
            [self.view bringSubviewToFront:self.hdCameraFocusView];
            [self.hdCameraFocusView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
                make.centerY.mas_equalTo(self.view.mas_centerY).offset(0);
                make.width.offset(88);
                make.height.offset(88);
                
            }];
            [self.hdCameraFocusView layoutIfNeeded];
            

            [self addScaleAnimationTo:self.hdCameraFocusView];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:3.0];
            [UIView setAnimationDelegate:self];
            self.hdCameraFocusView.alpha = 0;
            [UIView commitAnimations];
        }
        
    }else{
        state = NO;
        if(!_cameraState){
            content =NSLocalizedString(@"video.remoteassistance.camera.close", @"video.remoteassistance.camera.close");
            [MBProgressHUD  showSuccess:content toView:self.view];
            
            
        }else if ([[HDAgoraCallManager shareInstance] getCurrentFrontFacingCamera]) {
            
            // 是前置 需要后置
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.remoteassistance.device.front", @"video.remoteassistance.device.front") toView:self.view];
            
            content =NSLocalizedString(@"video.remoteassistance.device.front", @"video.remoteassistance.device.front");
        } else{
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.remoteassistance.device", @"video.remoteassistance.device") toView:self.view];
            content =NSLocalizedString(@"video.remoteassistance.device", @"video.remoteassistance.device");
        }
        
    }
    
    [self sendCmdMessageAction:@"focusCameracallback" withOn:state withContent:content];
}

- (void)addScaleAnimationTo:(UIView*)animationView{
    [animationView.layer removeAnimationForKey:@"scale"];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    scaleAnimation.fromValue=@1.f;

    scaleAnimation.toValue=@1.1f;

    scaleAnimation.autoreverses=YES;

    scaleAnimation.repeatCount=HUGE_VALF;

    scaleAnimation.duration=2.f;
   
    [animationView.layer addAnimation:scaleAnimation forKey:@"scale"];

}
/*!
 *  \~chinese
 *  开关闪光灯  后置摄像头可用
 */
- (void)onCameraTorchOnParameter:(NSDictionary *)dic{
    
    [self onFlashlightWithCameraTorchWithAction:@"cameraTorchOncallback" withDic:dic];
}

#pragma mark - event response

/*!
 *  \~chinese
 *    flashlight
 *    手电筒
 */
- (void)onFlashlightParameter:(NSDictionary *)dic{
    
    [self onFlashlightWithCameraTorchWithAction:@"flashlightcallback" withDic:dic];
}
-(void)onFlashlightWithCameraTorchWithAction:(NSString *)action withDic:(NSDictionary *)dic{
    
    BOOL state = NO;
    NSString *content=@"";
    // 手电筒 只有后置摄像头可以 使用
    if ([HDAgoraCallManager shareInstance].isCameraTorchSupported) {
    if (dic && [[dic allKeys] containsObject:@"action"]) {

        if ([[dic valueForKey:@"action"] isEqualToString:@"on"]) {

            state = YES;
            [[HDAgoraCallManager shareInstance] setCameraTorchOn:YES];
        }else{

            state = NO;
            [[HDAgoraCallManager shareInstance] setCameraTorchOn:NO];
        }
    }

    }else{
        state = NO;
        if ([[HDAgoraCallManager shareInstance] getCurrentFrontFacingCamera]) {
            
            // 是前置 需要后置
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.remoteassistance.device.front", @"video.remoteassistance.device.front") toView:self.view];
            content =NSLocalizedString(@"video.remoteassistance.device.front", @"video.remoteassistance.device.front");
        }else{
            
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.remoteassistance.device", @"video.remoteassistance.device") toView:self.view];
            content =NSLocalizedString(@"video.remoteassistance.device", @"video.remoteassistance.device");
        }
       
        
    }
    [self sendCmdMessageAction:action withOn:state withContent:content];
    
    
}
- (void)sendCmdMessageAction:(NSString *)action withOn:(BOOL)on withContent:(NSString *)content{
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
 
    HDMessage *message = [[HDClient sharedClient].callManager hd_visitorCallBackStateCmdMessageWithImId:lgM.cname withOn:on withAction:action content:content];
    
     [self _sendMessage:message];
}

//开启+关闭🔦
-(void)FlashlightON{
    AVCaptureDevice *device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if([device hasFlash]) {
        if(device.torchMode==AVCaptureFlashModeOff) {
            device.torchMode=AVCaptureTorchModeOn;
        }else if(device.torchMode==AVCaptureFlashModeOn) {
            device.torchMode=AVCaptureTorchModeOff;
        }
    }
    [device unlockForConfiguration];
}

- (UIView *)hdCameraFocusView{
    
    if (!_hdCameraFocusView) {
        _hdCameraFocusView = [[UIView alloc] init];
//        _hdCameraFocusView.backgroundColor = [UIColor redColor];

        UIImage *image =[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_focus.png"];
        _hdCameraFocusView.layer.contents = (id)image.CGImage;
    }
    
    return _hdCameraFocusView;
}
- (void)onClickedMore:(UIButton *)sender{
    
    
    [self popoverMoreWithBtn:sender];
}

- (void)popoverMoreWithBtn:(UIButton *)btn{
    NSLog(@"点击了更多事件");
    self.morePopVC = [[HDPopoverViewController alloc] init];
   
    self.morePopVC.popoverType = HDPopoverTypeMore;
    HDPopoverViewControllerCellItem * item = [[HDPopoverViewControllerCellItem alloc] init];
    item.name =NSLocalizedString(@"video.call.shareScreen.title", @"屏幕共享");
    item.imgName = kpingmugongxiang2;
    item.cellItemType = HDPopoverCellItemTypeShareScreen;
    item.isOn = _shareState;
    
    HDPopoverViewControllerCellItem * item1 = [[HDPopoverViewControllerCellItem alloc] init];
    item1.name =NSLocalizedString(@"video.call.whiteBoard.title", @"互动白板");
    item1.imgName = kbaiban;
    item1.cellItemType = HDPopoverCellItemTypeWhiteBoard;
    item1.isOn = [HDWhiteRoomManager shareInstance].roomState;
    NSMutableArray * items = [[NSMutableArray alloc] init];
    HDGrayModel * grayModelWhiteBoard =  [[HDCallManager shareInstance] getGrayName:@"whiteBoard"];
    HDGrayModel * grayModelShare =  [[HDCallManager shareInstance] getGrayName:@"shareDesktop"];
    if (grayModelShare.enable) {
        [items addObject:item];
    }
    if (grayModelWhiteBoard.enable) {
        [items addObject:item1];
    }
    
    [self.morePopVC setDataArrayWithModel:items];
    
    self.morePopVC.modalPresentationStyle = UIModalPresentationPopover;
  
    //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    self.morePopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    self.morePopVC.popoverPresentationController.delegate = self;
    self.morePopVC.popoverPresentationController.sourceView = btn;  //rect参数是以view的左上角为坐标原点（0，0）
    self.morePopVC.popoverPresentationController.sourceRect = btn.bounds;
    self.morePopVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.morePopVC animated:YES completion:nil];

}

- (void)clickPopoverMore:(NSIndexPath *)indexPath withItemModel:(HDPopoverViewControllerCellItem *)item{
    
    // 根据灰度去判断 对应的功能

    switch (item.cellItemType) {
        case  HDPopoverCellItemTypeShareScreen:
            //屏幕共享
            NSLog(@"=========点击了屏幕共享");
            [self initScreenShare];
            _shareScreenCellItem = item;
            [self shareDesktopBtnClicked:nil];
            break;
        case  HDPopoverCellItemTypeWhiteBoard:
            //
            NSLog(@"=========点击了白板");
            _whiteboardCellItem = item;
            [self onClickedFalt:nil];
            break;
        default:
            break;
    
    }
    if (self.morePopVC) {
        [self.morePopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.morePopVC = nil;
        
    }else{
      
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];
        self.buttonPopVC = nil;
    }
    
    
}
- (void)showMessage{
    
    // 将view.frame 设置在屏幕下方
    [self.view addSubview:self.hdMessageView];
    [UIView transitionWithView:self.hdMessageView duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.hdMessageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -  kHDVideoMessageHeight, self.view.frame.size.width, kHDVideoMessageHeight);
        
        
    } completion:^(BOOL finished) {
    
    }];
    
  
    [self.hdMessageView addSubview:self.chat.view];
    [self.chat.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(44);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
        
    }];
    
    [self.barView setModel:nil];
}

- (void)hideVideoMessage{
    
    [UIView transitionWithView:self.hdMessageView duration:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.hdMessageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kHDVideoMessageHeight);
        
        
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - 隐藏 popervc
- (void)dismissHDPoperViewController{
    
    if (self.morePopVC) {
        [self.morePopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.morePopVC = nil;
        
    }
    if (self.buttonPopVC) {
        [self.buttonPopVC dismissViewControllerAnimated:YES completion:nil];    //我暂时使用这个方法让popover消失，但我觉得应该有更好的方法，因为这个方法并不会调用popover消失的时候会执行的回调。
        self.buttonPopVC = nil;
        
    }
    
    
}
#pragma mark - 懒加载
- (HDVideoMessageView *)hdMessageView{
    
    if (!_hdMessageView) {
        _hdMessageView = [[HDVideoMessageView alloc] init];
        _hdMessageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kHDVideoMessageHeight);
        _hdMessageView.layer.cornerRadius = 10.0f;
        _hdMessageView.layer.masksToBounds = YES;
        _hdMessageView.layer.shadowOpacity = 0.5;
        _hdMessageView.layer.shadowRadius = 15;
        kWeakSelf
        _hdMessageView.clickCloseMessageBlock = ^(UIButton *btn) {
            
           // 隐藏动画
            [weakSelf hideVideoMessage];
            
            
        };
    }
    return _hdMessageView;
    
}

- (HDVideoCallChatViewController *)chat{
    
    if (!_chat) {
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        _chat = [[HDVideoCallChatViewController alloc] initWithConversationChatter:lgM.cname];
        _chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
    }
    
    return _chat;
}

- (void)hideInvalidate:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    // Cancel any scheduled hideAnimated:afterDelay: calls
    [self.hideDelayTimer invalidate];

    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleTimeoutHideTimer:) userInfo:@(animated) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}
- (void)handleTimeoutHideTimer:(NSTimer *)timer {

    [self handleHideTimerShow:YES];
}
- (void)handleHideTimerShow:(BOOL)isShowTost {
   
    if (self.hideDelayTimer) {
        [self.hideDelayTimer invalidate];
    }
    if (isShowTost) {
        [MBProgressHUD  showSuccess:NSLocalizedString(@"加入房间失败", @"加入房间失败") toView:self.view.superview];
    }else{
   
    }
    [_hud hideAnimated:YES];
}

#pragma mark --vec 1.5 排队超时

- (void)initAnswerTimeOut{
    
    // 调用接口 获取 超时时间
    [[HDCallManager shareInstance] hd_getVideoLineUpTimeOutCompletion:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
    }];
    
}

- (void)startLineUpTimer:(NSTimeInterval)delay{
    
    [self.timeOutTimer invalidate];

    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(timeOutRemoveCall:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timeOutTimer = timer;
    
}
- (void)timeOutRemoveCall:(NSTimer *)timer {

    [MBProgressHUD  showSuccess:NSLocalizedString(@"排队超时，通话结束", @"排队超时，通话结束") toView:self.view.superview];
    // 挂断
    [self offBtnClicked:nil];

}
#pragma mark - 原子化 能力 优化
-  (void)saveTaskQueue:(HDVideoCallTaskType )taskId{
    
    
    if ([self.queueArray containsObject:[NSNumber numberWithInteger:taskId]]) {
        
        return;
    }
    
    
    if (self.queueArray.count ==0) {
        
        [self.queueArray addObject:[NSNumber numberWithInteger:taskId]];
        
    }else{
        
        // 先取出 任务名字
        HDVideoCallTaskType  oldTaskId = [[self.queueArray lastObject] integerValue];
        
        [self.queueArray removeAllObjects];
        [self clearQueueTask];
        
        // 去执行 取消正在执行的任务
        [self cancelPerformQueueTask:oldTaskId];
        
        [self.queueArray addObject:[NSNumber numberWithInteger:taskId]];
        
    }
}
- (BOOL)cancelPerformQueueTask:(HDVideoCallTaskType )taskId{
    
    BOOL cancel = NO;
    switch (taskId) {
        case HDVideoCallTaskIDCard:
            [self showCallingOtherView:YES];
            cancel = YES;
            break;
        case HDVideoCallTaskFace:
            cancel = YES;
            [self showCallingOtherView:YES];
            break;
        case HDVideoCallTaskPush:
            cancel = YES;
            [self.hdVideoLinkMessagePush removeFromSuperview];
            self.hdVideoLinkMessagePush = nil;
            break;
        case HDVideoCallTaskSign:
            
            //移除 签名界面
            [self.hdSignView removeFromSuperview];
            self.hdSignView = nil;
            
            cancel = YES;
            break;
            
        default:
            break;
    }
    
    
    return cancel;
    
}
- (void)clearQueueTask{
    
    [self.queueArray removeAllObjects];
    
}

-(NSMutableArray *)queueArray{
    
    
    if (!_queueArray) {
        _queueArray = [[NSMutableArray alloc] init];
    }
    
    return _queueArray;
}
@end