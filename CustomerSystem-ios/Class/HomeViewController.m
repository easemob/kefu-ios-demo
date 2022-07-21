//
//  HomeViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "HomeViewController.h"
#import "HDLeaveMsgViewController.h"
#import "MallViewController.h"
#import "SettingViewController.h"
#import "LocalDefine.h"
#import "MoreChoiceView.h"
#import "CSDemoAccountManager.h"
#import "MessageViewController.h"
#import "HDMessageViewController.h"
#import "QRCodeViewController.h"
#import "HConversationsViewController.h"
#import "HDAgoraCallViewController.h"
#import "HDCallViewController.h"
#import "HDVideoCallViewController.h"
#import "HDCloudDiskViewController.h"
#import "HDAgoraCallManager.h"
#import "HDVideoWindowViewController.h"
#import "MBProgressHUD+Add.h"
#define kafterSale @"shouhou"
#define kpreSale @"shouqian"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface HomeViewController () <UIAlertViewDelegate,HDChatManagerDelegate,HDCallManagerDelegate>
{
    MallViewController *_mallController;
    MessageViewController *_leaveMsgVC;
    HConversationsViewController *_conversationsVC;
    SettingViewController *_settingController;
    UIBarButtonItem *_chatItem;
    UIBarButtonItem *_leaveItem;
    UIBarButtonItem *_conversationItem;
    UIBarButtonItem *_settingleftItem;
    UIBarButtonItem *_settingRightItem;
    UIWindow *_window;
    UIBarButtonItem *_testItem;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) MoreChoiceView *choiceView;
@property (strong, nonatomic) HDCallViewController *callViewController;

@end

@implementation HomeViewController
{
    BOOL isLogin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated ];
    [_conversationsVC refreshData];
    //测试理想打开
    [self testButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 用于添加语音呼入的监听 onCallReceivedNickName:
    [HDClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.title = NSLocalizedString(@"title.mall", @"Mall");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignWindowClick) name:@"resignWindow" object:nil];
    
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    // 解决第一次启动app 设置导航titleView不显示的问题
    [self setNavTitleView];
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [chatButton setBackgroundImage:[UIImage imageNamed:@"hd_chat_icon.png"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatItemAction) forControlEvents:UIControlEventTouchUpInside];
    _chatItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.rightBarButtonItem = _chatItem;
    
    UIImageView *triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 8)];
    triangleView.image = [UIImage imageNamed:@"Triangle"];
    if (kScreenWidth <= 320) {
        _window = [[UIWindow alloc]initWithFrame:CGRectMake(kScreenWidth - 32, 56, 15, 8)];
    } else if(kScreenWidth > 320) {
        _window = [[UIWindow alloc]initWithFrame:CGRectMake(kScreenWidth - 37, 56, 15, 8)];
    }
    
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor clearColor];
    _window.hidden = YES;
    [_window addSubview:triangleView];
    
    //“会话”
    UIButton *converationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    converationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [converationBtn setTitle:NSLocalizedString(@"title.conversationTitle", @"conversationList") forState:UIControlStateNormal];
    converationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _conversationItem = [[UIBarButtonItem alloc] initWithCustomView:converationBtn];
    
    UIButton *setRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [setRightButton setBackgroundImage:[UIImage imageNamed:@"hd_scan_icon.png"] forState:UIControlStateNormal];
    [setRightButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    _settingRightItem = [[UIBarButtonItem alloc] initWithCustomView:setRightButton];
    
    UIButton *setLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [setLeftButton setTitle:NSLocalizedString(@"title.setting", @"Setting") forState:UIControlStateNormal];
    setLeftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    setLeftButton.userInteractionEnabled = NO;
    _settingleftItem = [[UIBarButtonItem alloc] initWithCustomView:setLeftButton];
    
    UIButton *leaveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leaveButton setTitle:NSLocalizedString(@"leave_title", @"Note") forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    leaveButton.userInteractionEnabled = NO;
    _leaveItem = [[UIBarButtonItem alloc] initWithCustomView:leaveButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatAction:) name:KNOTIFICATION_CHAT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vecAction:) name:KNOTIFICATION_VEC object:nil];
    
   
}
- (void)testButton{
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [testButton setBackgroundImage:[UIImage imageNamed:@"hd_chat_icon.png"] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(agorademo) forControlEvents:UIControlEventTouchUpInside];
    _testItem = [[UIBarButtonItem alloc] initWithCustomView:testButton];
    self.navigationItem.leftBarButtonItem = _testItem;
    
}
- (void)setNavTitleView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 97, 17)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:@"hd_logo.png"];//初始化图像视图
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private action

- (void)chatItemAction
{
    if (_choiceView.hidden) {
        _choiceView.hidden = NO;
        [_window makeKeyAndVisible];
    } else {
        _choiceView.hidden = YES;
        _window.hidden = YES;
    }
//    [self chatAction:nil];
}

- (void)resignWindowClick
{
    _window.hidden = YES;
}
- (void)vecAction:(NSNotification *)notification{
    
    if (isLogin == YES) {
        return;
    }
    isLogin = YES;
    __weak typeof(self) weakSelf = self;
//    [self showHudInView:self.view hint:NSLocalizedString(@"Contacting...", @"连接客服")];
    
//    [weakSelf showHint:NSLocalizedString(@"Contacting...", @"连接客服")];
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"Contacting...", @"连接客服") toView:nil];

    __weak MBProgressHUD *weakHud = hud;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        if ([lgM loginKefuSDK]) {
            
            
            
//            [[HDClient sharedClient].chatManager getEnterpriseWelcomeWithCompletion:^(NSString *welcome, HDError *error) {
//                            
//            }];
           
            
            [weakHud hideAnimated:YES];
            NSString *queue = nil;
            if ([notification.object objectForKey:kpreSell]) {
                queue = [[notification.object objectForKey:kpreSell] boolValue]?kpreSale:kafterSale;
            }
            HDQueueIdentityInfo *queueIdentityInfo=nil;
            if (queue) {
                queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue];
            }
            if ([notification.object objectForKey:kpreSell]) {
//                chat.title = [[notification.object objectForKey:kpreSell] boolValue] ? @"售前":@"售后";
            } else {
//                chat.title = [CSDemoAccountManager shareLoginManager].cname;
            }
            hd_dispatch_main_async_safe(^(){
                [weakSelf hideHud];
                HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                if (queue) {
                    chat.queueInfo = queueIdentityInfo;
                }

                chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                chat.commodityInfo = (NSDictionary *)notification.object;
//                 [self.navigationController pushViewController:chat animated:YES];
                
                //todo 创建视频等待界面  调用接口 vec 使用
//                [CSDemoAccountManager shareLoginManager].isVEC = YES;
                [HDClient sharedClient].callManager.isVecVideo = YES;
                
                [HDClient sharedClient].enableVisitorAccelerator = NO;
                [[HDAgoraCallManager shareInstance] initSettingWithCompletion:^(id  responseObject, HDError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        [[HDVideoCallViewController sharedManager] showViewWithKeyCenter:nil withType:HDVideoDirectionSend withVisitornickName:lgM.nickname];
                        [HDVideoCallViewController sharedManager].hangUpVideoCallback = ^(HDVideoCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
                            [[HDVideoCallViewController sharedManager]  removeView];

                            [[HDVideoCallViewController sharedManager] removeSharedManager];

                        };
                    });
                }];
            });
           
        } else {
            hd_dispatch_main_async_safe(^(){
                [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
            });
            NSLog(@"登录失败");
        }
//    });
    isLogin = NO;
    
    
}
- (void)chatAction:(NSNotification *)notification
{
//    BOOL shouqian = [[notification.object objectForKey:kpreSell] boolValue];
    //登录IM
    if (isLogin == YES) {
        return;
    }
    isLogin = YES;
    __weak typeof(self) weakSelf = self;
    [weakSelf showHudInView:self.view hint:NSLocalizedString(@"Contacting...", @"连接客服")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        if ([lgM loginKefuSDK]) {
            
            [[HDClient sharedClient].pushManager updatePushDisplayStyle:HDPushDisplayStyleMessageSummary completion:^(HDError * _Nonnull error) {
                
                NSLog(@"=======error=%u",error.code);
                
                
            }];
            
            
            NSString *queue = nil;
            if ([notification.object objectForKey:kpreSell]) {
                queue = [[notification.object objectForKey:kpreSell] boolValue]?kpreSale:kafterSale;
            }
            HDQueueIdentityInfo *queueIdentityInfo=nil;
            if (queue) {
                queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue];
            }
            if ([notification.object objectForKey:kpreSell]) {
//                chat.title = [[notification.object objectForKey:kpreSell] boolValue] ? @"售前":@"售后";
            } else {
//                chat.title = [CSDemoAccountManager shareLoginManager].cname;
            }
            hd_dispatch_main_async_safe(^(){
                [weakSelf hideHud];
                HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                if (queue) {
                    chat.queueInfo = queueIdentityInfo;
                }

                chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
                chat.commodityInfo = (NSDictionary *)notification.object;
                 [self.navigationController pushViewController:chat animated:YES];
            });
           
        } else {
            hd_dispatch_main_async_safe(^(){
                [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
            });
            NSLog(@"登录失败");
        }
    });
    isLogin = NO;
    
}

- (void)setPushOptions {

    if ([[CSDemoAccountManager shareLoginManager] loginKefuSDK]) {
        [HDClient.sharedClient.pushManager updatePushDisplayStyle:HDPushDisplayStyleMessageSummary completion:^(HDError * error) {
            NSLog(@" error:%@",error.errorDescription);
            
            
        }];
    }
}

//登录IM【测试切换账号专用】
//- (BOOL)loginKefuSDK:(BOOL)isShouqian {
//    HDClient *client = [HDClient sharedClient];
//    if (client.isLoggedInBefore) {
//        [client logout:NO];
//    }
//
//    NSString *username = @"";
//    if (isShouqian) {
//        username = @"shouqian";
//    } else {
//        username = @"shouhou";
//    }
//    //用户没有注册的请注意注册
////    [[HDClient sharedClient] registerWithUsername:username password:hxPassWord];
//    HDError *error = [[HDClient sharedClient] loginWithUsername:username password:hxPassWord];
//    if (!error) { //IM登录成功
//        return YES;
//    } else { //登录失败
//        NSLog(@"登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
//        return NO;
//    }
//    return NO;
//}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if (item.tag == 0) {
        [self setNavTitleView];
        self.title = nil;
        self.navigationItem.rightBarButtonItem = _chatItem;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else if (item.tag == 1){
        self.title = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = _leaveItem;
    } else if (item.tag == 2) {
        self.title = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = _conversationItem;
    }
    else if (item.tag == 3){
        self.title = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = _settingRightItem;
        self.navigationItem.leftBarButtonItem = _settingleftItem;
    }
}

- (void)scan {
    QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc] init];
    qrcodeVC.qrBlock = ^(NSDictionary *dic) {
        if (dic) {
            [_settingController setvalueWithDic:dic];
        }
    };
    [self.navigationController pushViewController:qrcodeVC animated:YES];
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //监听消息接收，主要更新会话tabbaritem的badge
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[HDClient sharedClient].chatManager removeDelegate:self];
}

- (void)setupSubviews
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
    {
        self.tabBar.tintColor = RGBACOLOR(184, 22, 22, 1);
    }
    else{
        self.tabBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    //商城
    _mallController = [[MallViewController alloc] initWithNibName:nil bundle:nil];
    [self setupController:_mallController
                    title:NSLocalizedString(@"title.mall", @"Mall")
                imageName:@"em_nav_shop_normal"
        selectedImageName:@"em_nav_shop_select"
                      tag:0];

    //留言
    _leaveMsgVC = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
        
    [self setupController:_leaveMsgVC
                    title:NSLocalizedString(@"title.messagebox", @"Message Box")
                imageName:@"em_nav_ticket_select"
        selectedImageName:@"em_nav_ticket_normal"
                      tag:1];
    
    
    
    //会话列表
    _conversationsVC = [[HConversationsViewController alloc] init];
    
    [self setupController:_conversationsVC
                    title:NSLocalizedString(@"title.conversationTitle", @"conversationList")
                imageName:@"list"
        selectedImageName:@"list2"
                      tag:2];
    
    
    //设置
    _settingController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    
    
    [self setupController:_settingController
                    title:NSLocalizedString(@"title.setting", @"Setting")
                imageName:@"em_nav_setting_select"
        selectedImageName:@"em_nav_setting_normal"
                      tag:3];
    
    [self setupController:_settingController
                    title:NSLocalizedString(@"title.setting", @"Setting")
                imageName:@"em_nav_setting_select"
        selectedImageName:@"em_nav_setting_normal"
                      tag:3];
    
    self.viewControllers = @[_mallController, _leaveMsgVC ,_conversationsVC,_settingController];
    
    
    [self tabBar:self.tabBar didSelectItem:_mallController.tabBarItem];
    
    _choiceView = [[MoreChoiceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _choiceView.hidden = YES;
    [self.view addSubview:_choiceView];
}

- (void)setupController:(UIViewController *)aController
                  title:(NSString *)aItemTitle
              imageName:(NSString *)aImageName
      selectedImageName:(NSString *)aSelectedImageName
                    tag:(int)tag{
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:aItemTitle
            image:[UIImage imageNamed:aImageName]
    selectedImage:[UIImage imageNamed:aSelectedImageName]];
    tabBarItem.tag = tag;
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10],
                                        UITextAttributeFont,RGBACOLOR(184, 22, 22, 1),UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
    
    aController.tabBarItem = tabBarItem;

    aController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

/*

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

 */
#pragma mark - private chat

- (void)_playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[HDCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[HDCDDeviceManager sharedInstance] playVibration];
}

- (void)_showNotificationWithMessage:(NSArray *)messages
{
    HDPushOptions *options = [[HDClient sharedClient] hdPushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == HDPushDisplayStyleMessageSummary) {
        id<HDIMessageModel> messageModel  = messages.firstObject;
        NSString *messageStr = nil;
        switch (messageModel.body.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageModel.body).text;
             }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title = messageModel.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
}
/*
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
//    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
//    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
//    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    
}
*/
// 收到im消息回调
- (void)messagesDidIMReceive:(NSArray *)aMessages{
    
    NSLog(@"==========收到消息了messagesDidIMReceive");
}



// 收到消息回调
- (void)messagesDidReceive:(NSArray *)aMessages {
    
    NSLog(@"==========收到消息了");
    
    
    if ([self isNotificationMessage:aMessages.firstObject]) {
        
        
        
        return;
    }
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self _showNotificationWithMessage:aMessages];
    }else {
        [self _playSoundAndVibration];
    }
#endif
    [_conversationsVC refreshData];
}


- (BOOL)isNotificationMessage:(HDMessage *)message {
    if (message.ext == nil) { //没有扩展
        return NO;
    }
    NSDictionary *weichat = [message.ext objectForKey:kMessageExtWeChat];
    if (weichat == nil || weichat.count == 0 ) {
        return NO;
    }
    if ([weichat objectForKey:@"notification"] != nil && ![[weichat objectForKey:@"notification"] isKindOfClass:[NSNull class]]) {
        BOOL isNotification = [[weichat objectForKey:@"notification"] boolValue];
        if (isNotification) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - HDCallManagerDelegate
- (void)onCallReceivedParameter:(HDKeyCenter *)keyCenter{
    
    [HDLog logI:@"================vec1.2=====onCallReceivedParameter= %@",[NSThread currentThread] ];
    if ([HDClient sharedClient].callManager.isVecVideo) {
       
        [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息: "];
        
        if (keyCenter && keyCenter.isAgentCancelCallbackReceive) {
            [[HDVideoCallViewController sharedManager]  removeView];

            [[HDVideoCallViewController sharedManager] removeSharedManager];
        }else{
        
        [[HDVideoCallViewController sharedManager] showViewWithKeyCenter:keyCenter withType:HDVideoDirectionReceive withVisitornickName:keyCenter.visitorNickName];
        [HDVideoCallViewController sharedManager].hangUpVideoCallback = ^(HDVideoCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
            [[HDVideoCallViewController sharedManager]  removeView];

            [[HDVideoCallViewController sharedManager] removeSharedManager];

        };
        }
//        [[HDCallViewController sharedManager] showViewWithKeyCenter:keyCenter withType:HDVideoCallDirectionReceive];
//        [HDCallViewController sharedManager].hangUpCallback = ^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
//
//            [[HDCallViewController sharedManager]  removeView];
//            [[HDCallViewController sharedManager] removeSharedManager];
//
//           };
    }else{
        
        
        [HDLog logI:@"================vec1.1=====收到坐席回呼cmd消息: "];
        
        [[HDCallViewController sharedManager] showViewWithKeyCenter:keyCenter withType:HDVideoCallDirectionReceive];
        [HDCallViewController sharedManager].hangUpCallback = ^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
        
            [[HDCallViewController sharedManager]  removeView];
            [[HDCallViewController sharedManager] removeSharedManager];
       
           };
    }
    
   
    
}
//声网
- (void)agorademo{
//    
//    HDCloudDiskViewController * cloudDiskVC = [[HDCloudDiskViewController alloc] init];
//    cloudDiskVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:cloudDiskVC animated:YES completion:nil];
//
//    return;
//    HDFastboardViewController * agoraVC = [[HDFastboardViewController alloc] init];
//    [self.navigationController pushViewController:agoraVC animated:YES];
//
//    return;
//    HDKeyCenter * key = [[HDKeyCenter alloc] init];
////
//    
//    HDCallViewController *hdCallVC = [HDCallViewController hasReceivedCallWithKeyCenter:key avatarStr:@"HelpDeskUIResource.bundle/user" nickName:[CSDemoAccountManager shareLoginManager].nickname hangUpCallBack:^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
////        [callVC dismissViewControllerAnimated:YES completion:nil];
//    }];
//        hdCallVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:hdCallVC animated:YES completion:nil];
//
//    
//    return;
    
//    [self lxLogout];
//          [self lxLogin];
//    HDAgoraCallViewController * agoraVC = [[HDAgoraCallViewController alloc] init];
//    [self.navigationController pushViewController:agoraVC animated:YES];
//    HDAgoraCallViewController *hdCallVC = [HDAgoraCallViewController hasReceivedCallWithKeyCenter:nil avatarStr:@"HelpDeskUIResource.bundle/user" nickName:[CSDemoAccountManager shareLoginManager].nickname hangUpCallBack:^(HDAgoraCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
//
//
//        [callVC dismissViewControllerAnimated:YES completion:nil];
//    }];
    
//    [hdCallVC dismissViewControllerAnimated:YES completion:nil];
//        hdCallVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:hdCallVC animated:YES completion:nil];
//    HDFastbordViewController * agoraVC = [[HDFastbordViewController alloc] init];
//        [self.navigationController pushViewController:agoraVC animated:YES];
    
    
    
//   
    
    [HDVideoWindowViewController sharedManager];

    
  
    
  
    
   
    
    
    
    
}
//理想汽车crash
//- (void)lxdemo{
//
//
//    /
//
//
////        [self lxLogout];
////        [self lxLogin];
//
//}

//退出IM【测试】
-(void)lxLogout{
    HDClient *client = [HDClient sharedClient];
    [client logout:YES completion:^(HDError *error) {
        
        if (!error) { //IM登录成功
            NSLog(@"lx ----退出成功");
        } else { //登录失败
            NSLog(@"lx ----退出失败 error code :%d,error description:%@",error.code,error.errorDescription);
        }
    }];
}
//登录IM【测试】
-(void)lxLogin{
    NSString *username = @"shouqian";
    HDClient *client = [HDClient sharedClient];
//    [client loginWithUsername:username password:hxPassWord completion:^(HDError *error) {
//        if (!error) { //IM登录成功
//            NSLog(@"lx ----登录成功");
//            [self lxSendText];
//        } else { //登录失败
//            NSLog(@"lx ----登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
//        }
//    }];
    
   
    
}
//登录绑定【测试】
-(void)lxBindDeviceToken{
    
    
}
//发文本消息【测试】
-(void)lxSendText{
    HDMessage *message = [HDMessage createTxtSendMessageWithContent:@"sendtextfirst33333" to:@"kefuchannelimid_851754"];
    //添加获取会话
    [[HDClient sharedClient].chatManager getConversation:message.conversationId];
    [[HDClient sharedClient].chatManager sendMessage:message progress:^(int progress)
    { //发送消息进度
        
    }
    completion:^(HDMessage *aMessage, HDError *aError)
    { //发送消息完成，aError为空则为发送成功
        if (!aError) { //
            NSLog(@"lx ----发送消息成功");
        } else { //登录失败
            NSLog(@"lx ----发送消息失败 aError code :%d,aError description:%@",aError.code,aError.errorDescription);
        }
    }];
}
//发文件消息【测试】
-(void)sendFile{
    HDMessage *message = [HDMessage createTxtSendMessageWithContent:@"sendtextfirst33333" to:@"kefuchannelimid_851754"];
    //添加获取会话
    [[HDClient sharedClient].chatManager getConversation:message.conversationId];
    [[HDClient sharedClient].chatManager sendMessage:message progress:^(int progress)
    { //发送消息进度
        
    }
    completion:^(HDMessage *aMessage, HDError *aError)
    { //发送消息完成，aError为空则为发送成功
        if (!aError) { //
            NSLog(@"lx ----发送消息成功");
        } else { //登录失败
            NSLog(@"lx ----发送消息失败 aError code :%d,aError description:%@",aError.code,aError.errorDescription);
        }
    }];
}

-(HDCallViewController *)callViewController{
    
    if (!_callViewController) {
        _callViewController = [HDCallViewController alertCallWithView:nil];
        _callViewController.hangUpCallback = ^(HDCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
            [callVC removeView];
            _callViewController = nil;
        };
    }
    
    return _callViewController;
    
}
@end
