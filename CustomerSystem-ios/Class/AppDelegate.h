//
//  AppDelegate.h
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMob.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HomeViewController *homeController;

@end

