//
//  AppDelegate+EaseMob.m
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate+HelpDesk.h"
#import "LocalDefine.h"
#import "CSDemoAccountManager.h"
#import "HDCustomEmojiManager.h"
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

    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [audioSession setActive:YES error:nil];
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
    HDOptions *option = [[HDOptions alloc] init];
    

    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    
    option.appkey = lgM.appkey;

    option.tenantId = lgM.tenantId;
    option.configId = lgM.configId;
    option.kefuRestServer = @"https://sandbox.kefu.easemob.com";
//    option.kefuRestServer = @"https://helps.live";
    option.enableConsoleLog = YES; // 是否打开日志信息
    option.enableDnsConfig =YES;  //
    option.apnsCertName = apnsCertName; // im 透传参数
    option.visitorWaitCount = YES; // 打开待接入访客排队人数功能
    option.showAgentInputState = YES; // 是否显示坐席输入状态
    option.isAutoLogin = YES;
    option.usingHttpsOnly = NO;
    
    
    HDClient *client = [HDClient sharedClient];
    
    //如果HDOptions 满足使用 initializeSDKWithOptions
//    HDError *initError = [client initializeSDKWithOptions:option] ;
    
    //如果HDOptions 不满足im EMOptions 参数的请使用initializeSDKWithOptions：withToImoptions：
    EMOptions * imOptions =[EMOptions optionsWithAppkey:option.appkey];
//    imOptions.enableFpa = YES;// 设置对应的im参数
    imOptions.usingHttpsOnly = NO; //设置对应的im参数
    HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option withToImoptions:imOptions];
 
    //如果使用了im sdk 提供的demo 一定要初始化这个方法
//    [EaseIMKitManager initWithEMOptions:nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCustomEmojiManager shareManager] cacheBigExpression];
    });
    
    if (initError) {
        UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"initialization_error", @"Initialization error!") message:initError.errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
        [sure addAction:confirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
        return;
    }
    [self registerEaseMobNotification];
    
//    sleep(1);
    
    [client.pushManager getPushNotificationOptionsFromServerWithCompletion:^(HDPushOptions * _Nonnull aOptions, HDError * _Nonnull aError) {

        NSLog(@"==========aErrorcode=%u==%@",aError.code,aError.description);
        NSLog(@"===========displayStyle=%u==%@",aOptions.displayStyle,aOptions.displayName);
    }];
    
    [EMClient.sharedClient addDelegate:self delegateQueue:nil];
    [EMClient.sharedClient.chatManager addDelegate:self delegateQueue:nil];
    
    //添加自定义小表情
#pragma mark smallpngface
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
}

-(void)messagesDidReceive:(NSArray<EMChatMessage *> *)aMessages{
    
    NSLog(@"========%@",aMessages);
    
}
-(void)cmdMessagesDidReceive:(NSArray<EMChatMessage *> *)aCmdMessages{
    
    NSLog(@"========%@",aCmdMessages);
    
}
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    
    NSLog(@"========%@",aError);
    
    
}
//修改关联app后需要重新初始化
- (void)resetCustomerServiceSDK {
    //如果在登录状态,账号要退出
    HDClient *client = [HDClient sharedClient];
    HDError *error = [client logout:NO];
    if (error != nil) {
            NSLog(@"登出出错:%@",error.errorDescription);
    }
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
#warning "changeAppKey 为内部方法，不建议使用"
    HDError *er = [client changeAppKey:lgM.appkey];
    if (er == nil) {
        NSLog(@"appkey 已更新");
    } else {
        NSLog(@"appkey 更新失败,请手动重启");
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
    [[HDClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HDClient sharedClient] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
//    [[HDClient sharedClient] applicationdidfinishLounching];
 //   [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
  //  [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
 //   [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeRecording" object:nil];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"apns.failToRegisterApns", "Fail to register apns") message:error.description preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [sure addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
    
    
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
    [application registerForRemoteNotifications];
#endif
}

#pragma mark - registerEaseMobNotification

- (void)registerEaseMobNotification
{
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[HDClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[HDClient sharedClient] removeDelegate:self];
}

//- (void)messagesDidReceive:(NSArray *)aMessages{
//    
//    
//    HDLogD(@"收到消息");
//    
//    
//}



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
    [self userAccountLogout];
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your login account has been remove from server") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [sure addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
}

- (void)userAccountDidLoginFromOtherDevice {
    [self userAccountLogout];
   
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [sure addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
}


- (void)userDidForbidByServer {
    [self userAccountLogout];
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"userDidForbidByServer", @"your login account has been forbid by server") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [sure addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
}

- (void)userAccountDidForcedToLogout:(HDError *)aError {
    [self userAccountLogout];
    
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"userAccountDidForcedToLogout", @"your login account has been forced logout") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [sure addAction:confirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sure animated:true completion:nil];
}
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    // 处理完成后调用 completionHandler ，用于指示在前台显示通知的形式
//    // completionHandler() 功能：可设置是否在应用内弹出通知
//    // 在 iOS 10 + 中 通知在前台的显示设置：
//    // 1、通知在前台不显示
//    // 如果调用下面代码： 通知不在前台弹出也不在通知栏显示
//    // completionHandler(UNNotificationPresentationOptionNone);
//    // 2、通知在前台显示
//    // 如果调用下面代码： 通知在前台弹出也在通知栏显示
//    // completionHandler(UNNotificationPresentationOptionAlert);
//    // 3、通知在前台显示 并带有声音
//    // 如果调用下面代码：通知弹出，且带有声音、内容和角标
//     completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
//}
//退出当前
- (void)userAccountLogout {
    [[HDClient sharedClient] logout:YES];
    HDChatViewController *chat = [CSDemoAccountManager shareLoginManager].curChat;
    if (chat) {
        [chat backItemClicked];
    }
}
-(void)initKefuAndIm:(HDOptions *)option{
    
    EMOptions * imOptions =[EMOptions optionsWithAppkey:option.appkey];
    imOptions.enableFpa = YES;// 设置对应的im参数
//    HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option withToImoptions:imOptions];
    
    
//    [[HDClient sharedClient] initializeSDKWithOptions:option withToImoptions:imOptions];
    
}
@end
