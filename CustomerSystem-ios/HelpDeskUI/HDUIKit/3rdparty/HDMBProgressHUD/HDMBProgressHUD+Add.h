//
//  HDMBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "HDMBProgressHUD.h"

@interface HDMBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (HDMBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end
