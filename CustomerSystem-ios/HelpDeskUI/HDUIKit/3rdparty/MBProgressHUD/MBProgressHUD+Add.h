//
//  HDMBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)dismissInfo:(id)title;
+ (void)dismissInfo:(id)title withWindow:(UIWindow *)window;
+ (void)dismissGlobalHUD;
//全局
+ (void)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)showGlobalHUDWithTitle:(NSString *)title;
@end
