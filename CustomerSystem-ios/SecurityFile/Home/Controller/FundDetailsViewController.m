//
//  FundDetailsViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/20.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "FundDetailsViewController.h"
#import "HDChatViewController.h"

@interface FundDetailsViewController ()

@end

@implementation FundDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(222, 222, 222, 1);
    [self setupBarButtonItem];
    [self setUI];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:scrollView];
    
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 580)];
    imageVC.image = [UIImage imageNamed:@"Rectangle"];
    [scrollView addSubview:imageVC];
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(imageVC.frame) + 50);
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.alpha = 1;
    [self.view addSubview:footerView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 1)];
    line.backgroundColor = RGBACOLOR(222, 222, 222, 1);
    [footerView addSubview:line];
    
    
    CustomButton * messageButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
    [messageButton setTitle:NSLocalizedString(@"customerChat", @"Customer") forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [messageButton setTitleColor:RGBACOLOR(237, 96, 88, 1) forState:UIControlStateNormal];
//    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    messageButton.imageRect = CGRectMake(15, footerView.height/3, footerView.height/3 + 5 , footerView.height/3);
    messageButton.titleRect = CGRectMake(40, footerView.height/4, 110, footerView.height/2);
    [self.view addSubview:messageButton];
    messageButton.frame = CGRectMake(0, 0, 180, footerView.height/1.5);
    [footerView addSubview:messageButton];
    [messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - (footerView.height/3) * 2, footerView.height/3, footerView.height/3, footerView.height/3)];
    [button setImage:[UIImage imageNamed:@"hd_icon_like_gray"] forState:UIControlStateNormal];
    [footerView addSubview:button];
    [self.view bringSubviewToFront:footerView];
}

- (void)messageAction
{
    
    SCLoginManager *lgM = [SCLoginManager shareLoginManager];
    if ([lgM loginKefuSDK]/*[self loginKefuSDK:shouqian] 测试切换账号使用*/) {
        HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:[SCLoginManager shareLoginManager].cname];
        chat.model = self.model;
        chat.title = @"投资顾问";
        [self.navigationController pushViewController:chat animated:YES];
    } else {
        NSLog(@"登录失败");
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
