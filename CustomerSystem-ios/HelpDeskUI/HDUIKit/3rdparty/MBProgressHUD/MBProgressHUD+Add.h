//
//  HDMBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD.h"
#define kShowTimeOut 15 //设置弹窗转圈 超时时间
@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;


+ (MBProgressHUD *)showTitle:(NSString *)message toView:(UIView *)view withTimeOut:(NSInteger)timeout;

+ (void)dismissInfo:(id)title;
+ (void)dismissInfo:(id)title withWindow:(UIWindow *)window;
+ (void)dismissGlobalHUD;
//全局
+ (void)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)showGlobalHUDWithTitle:(NSString *)title;
@end
