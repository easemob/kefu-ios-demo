//
//  UIBarButtonItem+KFAdd.h
//  CustomerSystem-ios
//
//  Created by  afanda on 16/12/13.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (KFAdd)
/**
 *  图
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

/**
 *  文字
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor target:(id)target action:(SEL)action;
@end
