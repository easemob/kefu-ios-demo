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
#import <Bugly/Bugly.h>
@interface AppDelegate ()<BuglyDelegate>
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化bugly
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelWarn;
    config.delegate = self;
    [Bugly startWithAppId:@"d6498f1c9a" config:config];

    // 初始化环信客服SDK，详细内容在AppDelegate+HelpDesk.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.homeController = [[HomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeController];
    [self configureNavigationController:navigationController];
    self.window.rootViewController = navigationController;
    
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
    
    NSLog(@"===didReceiveRemoteNotification===%@",userInfo);
    
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
        if (@available(iOS 13.0, *)) {
               UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
               barApp.backgroundColor = RGBACOLOR(184, 22, 22, 1);
               #//基于backgroundColor或backgroundImage的磨砂效果
               barApp.backgroundEffect = nil;
               #//阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
               barApp.shadowColor = [UIColor whiteColor];
               //标题文字颜色
               barApp.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0], NSFontAttributeName, nil];
               navigationController.navigationBar.scrollEdgeAppearance = barApp;
               navigationController.navigationBar.standardAppearance = barApp;
        }else{
            [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(184, 22, 22, 1)];
            [[UINavigationBar appearance] setTitleTextAttributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0], NSFontAttributeName, nil]];
        }
       
        // 关闭导航半透明
        [[UINavigationBar appearance] setTranslucent:NO];
        
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
