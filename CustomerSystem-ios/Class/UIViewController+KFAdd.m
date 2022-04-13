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
    
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"qrcode", @"QR Code") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 80, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 110, 29);
    
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = - 16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
    
}
@end
