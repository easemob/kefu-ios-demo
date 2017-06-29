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
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    [self setupBarButtonItem];
    [self setUI];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:scrollView];
    
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.813)];
    imageVC.image = [UIImage imageNamed:@"Rectangle"];
    [scrollView addSubview:imageVC];

    scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(imageVC.frame) + 50);
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 59, self.view.frame.size.width, 59)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = RGBACOLOR(196, 196, 196, 1);
    [footerView addSubview:topLine];
    
    UIButton * messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0.5, kScreenWidth * 0.392, 58.5);
    messageButton.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    [footerView addSubview:messageButton];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(24, 20, 26, 21)];
    image.image = [UIImage imageNamed:@"Group"];
    [messageButton addSubview:image];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 14.5, 22, 62, 18)];
    name.font = [UIFont systemFontOfSize:15];
    name.text = @"立即咨询";
    [name setTextColor:RGBACOLOR(255, 118, 116, 1)];
    [messageButton addSubview:name];
    [footerView addSubview:messageButton];
    
    UILabel *investLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageButton.frame), 0.5, kScreenWidth * 0.309, 58.5)];
    investLabel.text = @"定投";
    investLabel.font = [UIFont systemFontOfSize:15];
    investLabel.textAlignment = NSTextAlignmentCenter;
    investLabel.textColor = RGBACOLOR(100, 100, 100, 1);
    investLabel.backgroundColor = RGBACOLOR(221, 221, 221, 1);
    [footerView addSubview:investLabel];
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(investLabel.frame), 0, kScreenWidth - kScreenWidth * 0.392 - kScreenWidth * 0.309, 59)];
    buyLabel.text = @"购买";
    buyLabel.font = [UIFont systemFontOfSize:15];
    buyLabel.textAlignment = NSTextAlignmentCenter;
    buyLabel.textColor = RGBACOLOR(255, 118, 116, 1);
    [footerView addSubview:buyLabel];
    
    UIView *beforeLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageButton.frame), 0, 0.5, 59)];
    beforeLine.backgroundColor = RGBACOLOR(180, 180, 180, 1);
    [footerView addSubview:beforeLine];
    
    UIView *afterLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(investLabel.frame), 0, 0.5, 59)];
    afterLine.backgroundColor = RGBACOLOR(180, 180, 180, 1);
    [footerView addSubview:afterLine];
    
    [messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view bringSubviewToFront:footerView];
}

- (void)messageAction
{
    
    SCLoginManager *lgM = [SCLoginManager shareLoginManager];
    if ([lgM loginKefuSDK]/*[self loginKefuSDK:shouqian] 测试切换账号使用*/) {
        HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:@"kefuchannelimid_472701"];
        chat.model = self.model;
        HQueueIdentityInfo *queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:@"投资顾问"];
        chat.queueInfo = queueIdentityInfo;
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
