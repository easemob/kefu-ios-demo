//
//  HDMBProgressHUD+Add.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import "HDAppSkin.h"
@implementation MBProgressHUD (Add)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"HDMBProgressHUD.bundle/%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:0.7];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)dismissInfo:(id)title
{
    if(title&&title!=nil&&[title isKindOfClass:[NSString class]]&&title!=[NSNull null]&&[title length]>0&&[NSThread isMainThread]){
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        [MBProgressHUD hideHUDForView:window animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2];
    }
}
+ (void)dismissInfo:(id)title withWindow:(UIWindow *)window
{
    if(title&&title!=nil&&[title isKindOfClass:[NSString class]]&&title!=[NSNull null]&&[title length]>0&&[NSThread isMainThread]){

        [MBProgressHUD hideHUDForView:window animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2];
    }
}

+ (void)dismissGlobalHUD
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
   
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+ (void)showGlobalProgressHUDWithTitle:(NSString *)title{
    
    // TODO:TSW title参数先保留，等需求确定后再改方法名
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
}
+ (void)showGlobalHUDWithTitle:(NSString *)title{
    
    // TODO:TSW title参数先保留，等需求确定后再改方法名
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = title;
    [hud showAnimated:YES];
}


@end
