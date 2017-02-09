//
//  HomeViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "HomeViewController.h"

//#import "EMIMHelper.h"
#import "MallViewController.h"
#import "SettingViewController.h"
//#import "UIViewController+HUD.h"
//#import "EMCDDeviceManager.h"
#import "LocalDefine.h"
#import "MoreChoiceView.h"
#import "SCLoginManager.h"
#import "MessageViewController.h"
#import "HDMessageViewController.h"
#import "ChatViewController.h"
#import "QRCodeViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface HomeViewController () <UIAlertViewDelegate,HChatDelegate>
{
    MallViewController *_mallController;
    SettingViewController *_settingController;
    MessageViewController *_leaveMsgVC;
    UIBarButtonItem *_chatItem;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) MoreChoiceView *choiceView;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.title = NSLocalizedString(@"title.mall", @"Mall");
    
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    
    UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [chatButton setTitle:NSLocalizedString(@"customerChat", @"Customer") forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(chatItemAction) forControlEvents:UIControlEventTouchUpInside];
    [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chatItem = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.rightBarButtonItem = _chatItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatAction:) name:KNOTIFICATION_CHAT object:nil];
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
    } else {
        _choiceView.hidden = YES;
    }
//    [self chatAction:nil];
}

- (void)chatAction:(NSNotification *)notification
{
    //登录IM
    SCLoginManager *lgM = [SCLoginManager shareLoginManager];
    if ([[SCLoginManager shareLoginManager] loginKefuSDK]) {
        ChatViewController *chat = [[ChatViewController alloc] initWithConversationChatter:lgM.cname saleType:[[notification.object objectForKey:kpreSell] boolValue]?hPreSaleType:hAfterSaleType];
        chat.commodityInfo = (NSDictionary *)notification.object;
        if ([notification.object objectForKey:kpreSell]) {
            chat.title =[[notification.object objectForKey:kpreSell] boolValue] ? @"售前":@"售后";
        } else {
            chat.title = [SCLoginManager shareLoginManager].cname;
        }
         [self.navigationController pushViewController:chat animated:YES];
    } else {
        NSLog(@"网络异常");
    }
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = NSLocalizedString(@"title.mall", @"Mall");
        self.navigationItem.rightBarButtonItem = _chatItem;
    }
    else if (item.tag == 1){
        self.title = NSLocalizedString(@"title.messagebox", @"Message Box");
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if (item.tag == 2){
        self.title = NSLocalizedString(@"title.setting", @"Setting");
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"扫一扫" titleColor:[UIColor whiteColor] selectedTitleColor:[UIColor lightGrayColor] target:self action:@selector(scan)];
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
    
    [[HChatClient sharedClient].chat addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[HChatClient sharedClient].chat removeDelegate:self];
}

- (void)setupSubviews
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
    {
        self.tabBar.tintColor = RGBACOLOR(242, 83, 131, 1);
    }
    else{
        self.tabBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    
    _mallController = [[MallViewController alloc] initWithNibName:nil bundle:nil];
    _mallController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.mall", @"Mall") image:nil tag:0];
    [_mallController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_mallHL"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_mall"]];
    [self unSelectedTapTabBarItems:_mallController.tabBarItem];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
    
    _leaveMsgVC = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
    _leaveMsgVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.messagebox", @"Message Box") image:nil tag:1];
    [_leaveMsgVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_message_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_message"]];
    [self unSelectedTapTabBarItems:_leaveMsgVC.tabBarItem];
    [self selectedTapTabBarItems:_leaveMsgVC.tabBarItem];
    
    _settingController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    _settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.setting", @"Setting") image:nil tag:2];
    [_settingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_settingHL"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_setting"]];
    _settingController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self unSelectedTapTabBarItems:_settingController.tabBarItem];
    [self selectedTapTabBarItems:_settingController.tabBarItem];
    
    self.viewControllers = @[_mallController, _leaveMsgVC ,_settingController];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
    
    _choiceView = [[MoreChoiceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _choiceView.hidden = YES;
    [self.view addSubview:_choiceView];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor grayColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        UITextAttributeFont,RGBACOLOR(242, 83, 131, 1),UITextAttributeTextColor,
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
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)_showNotificationWithMessage:(NSArray *)messages
{
    HPushOptions *options = [[HChatClient sharedClient] getPushOptionsFromServerWithError:nil ];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == HPushDisplayStyleMessageSummary) {
        id<HDIMessageModel> messageModel  = messages.firstObject;
        NSString *messageStr = nil;
        switch (messageModel.bodyType) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageModel).text;
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
        
        NSString *title = messageModel.message.from;
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
#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self _showNotificationWithMessage:aMessages];
    }else {
        [self _playSoundAndVibration];
    }
#endif
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    for (HMessage *message in aCmdMessages) {
        NSString *msg = [NSString stringWithFormat:@"%@", message.ext];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"receiveCmdMessage", @"CMD message") message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//-(void)didReceiveCmdMessage:(EMMessage *)message
//{
//    NSString *msg = [NSString stringWithFormat:@"%@", message.ext];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"receiveCmdMessage", @"CMD message") message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}



@end
