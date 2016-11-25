//
//  SCChatViewController.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCChatViewController.h"
#import <UIKit/UIKit.h>
#import "SCLeaveMsgViewController.h"
@interface SCChatViewController ()

@end

@implementation SCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
}


- (void)leaveMsg {
    SCLeaveMsgViewController *leaveMsgVC = [SCLeaveMsgViewController new];
    [self.navigationController pushViewController:leaveMsgVC animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIBarButtonItem *bItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"chatBar_comment"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(leaveMsg)];
    self.navigationItem.rightBarButtonItem = bItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
