//
//  AppDelegate.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "AppDelegate.h"


#import "LocalDefine.h"
#import "HomeViewController.h"
#import "AppDelegate+HelpDesk.h"
#import "HCallManager.h"

@interface AppDelegate ()
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化环信客服SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.homeController = [[HomeViewController alloc] init];
    
    [[HCallManager sharedInstance] setMainViewController:self.homeController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeController];
    [self configureNavigationController:navigationController];
    self.window.rootViewController = navigationController;
    
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    for(UIWindow *window in windows) {
        
        if(window.rootViewController == nil){
            
            UIViewController* vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
            
            window.rootViewController = vc;
            
        }
        
    }
    
    
    //添加自定义小表情
#pragma mark smallpngface
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowRotation == YES)
    {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //
}

- (void)configureNavigationController:(UINavigationController *)navigationController
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        // Courier-Bold  Helvetica
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(61, 67, 83, 1)];
        // 关闭导航半透明
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Courier-Bold" size:19.0], NSFontAttributeName, nil]];
    }
    //设置7.0以下的导航栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"] forBarMetrics: UIBarMetricsDefault];
        [navigationController.navigationBar.layer setMasksToBounds:YES];
    }
    
    
}


@end
