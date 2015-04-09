//
//  HomeViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "HomeViewController.h"

#import "EaseMob.h"
#import "MallViewController.h"
#import "SettingViewController.h"
#import "ChatViewController.h"
#import "UIViewController+HUD.h"
#import "LocalDefine.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface HomeViewController () <UIAlertViewDelegate, IChatManagerDelegate>
{
    MallViewController *_mallController;
    SettingViewController *_settingController;
    ChatViewController *_chatController;
    
    UIBarButtonItem *_chatItem;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

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
    self.title = NSLocalizedString(@"title.mall", @"Mall");
    
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    
    _chatItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"customerChat", @"Customer") style:UIBarButtonItemStylePlain target:self action:@selector(chatAction)];
    _chatItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _chatItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - private action

- (void)chatAction
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cuname = [userDefaults objectForKey:kCustomerName];
    if ([cuname length] == 0) {
        cuname = kDefaultCustomerName;
        [userDefaults setObject:cuname forKey:kCustomerName];
    }
    
    if (_chatController == nil) {
        _chatController = [[ChatViewController alloc] initWithChatter:cuname isGroup:NO];
    }
    else{
        if (![_chatController.chatter isEqualToString:cuname]) {
            _chatController = nil;
            _chatController = [[ChatViewController alloc] initWithChatter:cuname isGroup:NO];
        }
    }
    
    [self.navigationController pushViewController:_chatController animated:YES];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = NSLocalizedString(@"title.mall", @"Mall");
    }
    else if (item.tag == 1){
        self.title = NSLocalizedString(@"title.setting", @"Setting");
    }
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)setupSubviews
{
    _mallController = [[MallViewController alloc] initWithNibName:nil bundle:nil];
    _mallController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.mall", @"Mall") image:nil tag:0];
    [_mallController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_mallHL"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_mall"]];
    [self unSelectedTapTabBarItems:_mallController.tabBarItem];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
    
    _settingController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    _settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.setting", @"Setting") image:nil tag:1];
    [_settingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_settingHL"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_setting"]];
    _settingController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self unSelectedTapTabBarItems:_settingController.tabBarItem];
    [self selectedTapTabBarItems:_settingController.tabBarItem];
    
    self.viewControllers = @[_mallController, _settingController];
    [self selectedTapTabBarItems:_mallController.tabBarItem];
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
                                        UITextAttributeFont,[UIColor colorWithRed:104 / 255 green:144 / 255 blue:1.0 alpha:1.000],UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
}

- (void)networkChanged:(EMConnectionState)connectionState
{
//    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
}

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
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

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

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    [self _playSoundAndVibration];
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    NSString *msg = [NSString stringWithFormat:@"%@", message.ext];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"receiveCmdMessage", @"CMD message") message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];

    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect
{
    [self hideHud];
    [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    [self hideHud];
    if (error) {
        [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
    }else{
        [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if(_chatController)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatController];
    }
}

@end
