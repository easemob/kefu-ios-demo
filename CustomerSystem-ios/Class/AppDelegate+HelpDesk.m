//
//  AppDelegate+EaseMob.m
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate+HelpDesk.h"
#import "LocalDefine.h"

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (HelpDesk)
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ios8注册apns
    [self registerRemoteNotification];
    //初始化环信客服sdk
    [self initializeCustomerServiceSdk];
    /*
     注册IM用户【注意:注册建议在服务端创建，而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器。】
     */
    // 注册环信监听
    [self setupNotifiers];
}



//初始化客服sdk
- (void)initializeCustomerServiceSdk {
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"customer_dev";
#else
    apnsCertName = @"customer";
#endif
    //注册kefu_sdk
    SCLoginManager *lgM = [SCLoginManager shareLoginManager]; //
    HOptions *option = [[HOptions alloc] init];
    option.appkey = lgM.appkey; 
    option.tenantId = lgM.tenantId;
    option.enableConsoleLog = YES;
    option.apnsCertName = apnsCertName;
    HChatClient *client = [HChatClient sharedClient];
    HError *initError = [client initializeSDKWithOptions:option];
    if (initError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重要提示[初始化错误]" message:initError.errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self registerEaseMobNotification];
}

//修改关联app后需要重新初始化
- (void)resetCustomerServiceSDK {
    //如果在登录状态,账号要退出
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore) {
        HError *error = [client logout:YES];
        if (error) {
            NSLog(@"error.code:%u,error.errorDescription :%@",error.code,error.errorDescription);
        } else {
            exit(0);
        }
    } else {
        exit(0);
    }
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[HChatClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HChatClient sharedClient] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
//    [[HChatClient sharedClient] applicationdidfinishLounching];
 //   [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
  //  [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
 //   [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
 //   [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
//    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[HChatClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - registerEaseMobNotification

- (void)registerEaseMobNotification
{
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[HChatClient sharedClient] addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[HChatClient sharedClient] removeDelegate:self];
}


#pragma mark - IChatManagerDelegate

- (void)connectionStateDidChange:(HConnectionState)aConnectionState {
    switch (aConnectionState) {
        case HConnectionConnected: {
            break;
        }
        case HConnectionDisconnected: {
            break;
        }
        default:
            break;
    }
}

- (void)userAccountDidRemoveFromServer {
    
}

- (void)userAccountDidLoginFromOtherDevice {
    [[HChatClient sharedClient] logout:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    alertView.tag = 100;
    [alertView show];
}


@end
