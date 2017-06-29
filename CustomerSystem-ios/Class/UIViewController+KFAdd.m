//
//  UIViewController+KFAdd.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/14.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "UIViewController+KFAdd.h"

@implementation UIViewController (KFAdd)

- (void)setLeftBarButtonItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
}
@end
