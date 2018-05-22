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

#import "HCallViewController.h"

#define kafterSale @"shouhou"
#define kpreSale @"shouqian"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface HomeViewController () <UIAlertViewDelegate,HChatDelegate, HCallManagerDelegate>
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
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) MoreChoiceView *choiceView;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // call
    [HChatClient.sharedClient.callManager addDelegate:self delegateQueue:nil];
    
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

- (void)chatAction:(NSNotification *)notification
{
//    BOOL shouqian = [[notification.object objectForKey:kpreSell] boolValue];
    //登录IM
    if (isLogin == YES) {
        return;
    }
    isLogin = YES;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Contacting...", @"连接客服")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        if ([lgM loginKefuSDK]/*[self loginKefuSDK:shouqian]测试切换账号使用*/ ) {
//            [[EMClient sharedClient] logout:YES];//测试第二通道
//            [self setPushOptions];
            NSString *queue = nil;
            if ([notification.object objectForKey:kpreSell]) {
                queue = [[notification.object objectForKey:kpreSell] boolValue]?kpreSale:kafterSale;
            }
            HQueueIdentityInfo *queueIdentityInfo=nil;
            if (queue) {
                queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:queue];
            }
            HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
            if (queue) {
                chat.queueInfo = queueIdentityInfo;
            }

            chat.visitorInfo = [self visitorInfo];
            chat.commodityInfo = (NSDictionary *)notification.object;
            if ([notification.object objectForKey:kpreSell]) {
//                chat.title = [[notification.object objectForKey:kpreSell] boolValue] ? @"售前":@"售后";
            } else {
//                chat.title = [CSDemoAccountManager shareLoginManager].cname;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                 [self.navigationController pushViewController:chat animated:YES];
            });
           
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"loginFail", @"login fail")];
                [SVProgressHUD dismissWithDelay:1.0];
            });
            NSLog(@"登录失败");
        }
    });
    isLogin = NO;
    
}

- (void)setPushOptions {

    if ([[CSDemoAccountManager shareLoginManager] loginKefuSDK]) {
        HPushOptions *hOptions = [[HChatClient sharedClient] getPushOptionsFromServerWithError:nil];
        hOptions.displayStyle = HPushDisplayStyleMessageSummary;
        HError *error =  [[HChatClient sharedClient] updatePushOptionsToServer:hOptions];
        NSLog(@" error:%@",error.errorDescription);
    }
}

//登录IM【测试切换账号专用】
//- (BOOL)loginKefuSDK:(BOOL)isShouqian {
//    HChatClient *client = [HChatClient sharedClient];
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
////    [[HChatClient sharedClient] registerWithUsername:username password:hxPassWord];
//    HError *error = [[HChatClient sharedClient] loginWithUsername:username password:hxPassWord];
//    if (!error) { //IM登录成功
//        return YES;
//    } else { //登录失败
//        NSLog(@"登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
//        return NO;
//    }
//    return NO;
//}


- (HVisitorInfo *)visitorInfo {
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = @"小明儿";
    visitor.qq = @"12345678";
    visitor.phone = @"13636362637";
    visitor.companyName = @"环信";
    visitor.nickName = [CSDemoAccountManager shareLoginManager].nickname;
    visitor.email = @"abv@126.com";
    visitor.desc = @"环信移动客服";
    return visitor;
}
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
    
    [[HChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[HChatClient sharedClient].chatManager removeDelegate:self];
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
    _mallController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.mall", @"Mall") image:[[UIImage imageNamed:@"em_nav_shop_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]selectedImage:[UIImage imageNamed:@"em_nav_shop_select"]];
    _mallController.tabBarItem.tag = 0;

    [self unSelectedTapTabBarItems:_mallController.tabBarItem];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
    
    //留言
    _leaveMsgVC = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
    _leaveMsgVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.messagebox", @"Message Box") image:nil tag:1];
    [_leaveMsgVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"em_nav_ticket_select"] withFinishedUnselectedImage:[UIImage imageNamed:@"em_nav_ticket_normal"]];
    [self unSelectedTapTabBarItems:_leaveMsgVC.tabBarItem];
    [self selectedTapTabBarItems:_leaveMsgVC.tabBarItem];
    
    //会话列表
    _conversationsVC = [[HConversationsViewController alloc] init];
    _conversationsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.conversationTitle", @"conversationList") image:[UIImage imageNamed:@"list"] selectedImage:[UIImage imageNamed:@"list2"]];
    _conversationsVC.tabBarItem.tag = 2;
    [_conversationsVC viewDidLoad];
    [self unSelectedTapTabBarItems:_conversationsVC.tabBarItem];
    [self selectedTapTabBarItems:_conversationsVC.tabBarItem];
    
    //设置
    _settingController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    _settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.setting", @"Setting") image:nil tag:3];
    [_settingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"em_nav_setting_select"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"em_nav_setting_normal"]];
    _settingController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self unSelectedTapTabBarItems:_settingController.tabBarItem];
    [self selectedTapTabBarItems:_settingController.tabBarItem];
    
    self.viewControllers = @[_mallController, _leaveMsgVC ,_conversationsVC,_settingController];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
    
    _choiceView = [[MoreChoiceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _choiceView.hidden = YES;
    [self.view addSubview:_choiceView];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10], UITextAttributeFont,[UIColor grayColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10],
                                        UITextAttributeFont,RGBACOLOR(184, 22, 22, 1),UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
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
    HPushOptions *options = [[HChatClient sharedClient] hPushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == HPushDisplayStyleMessageSummary) {
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
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
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
// 收到消息回调
- (void)messagesDidReceive:(NSArray *)aMessages {
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

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (HMessage *message in aCmdMessages) {
        NSString *msg = [NSString stringWithFormat:@"%@", message.ext];
        NSLog(@"receive cmd message: %@", msg);
    }
}

- (BOOL)isNotificationMessage:(HMessage *)message {
    if (message.ext == nil) { //没有扩展
        return NO;
    }
    NSDictionary *weichat = [message.ext objectForKey:kMesssageExtWeChat];
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


#pragma mark - HCallManagerDelegate
- (void)onCallReceivedNickName:(NSString *)nickName {
    HCallViewController *hCallVC = [HCallViewController hasReceivedCallWithAgentName:nickName];
    [self presentViewController:hCallVC animated:YES completion:nil];
    hCallVC.callback = ^(HCallViewController *callVC, NSString *timeStr) {
        NSLog(@"通话时长: ---- %@",timeStr);
        [callVC dismissViewControllerAnimated:YES completion:nil];
    };
}
@end
