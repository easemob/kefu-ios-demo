//
//  CommodityViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "CommodityViewController.h"
#import "CustomButton.h"
#import "LocalDefine.h"
#import "CustomButton.h"

@interface CommodityViewController ()
{
    UIScrollView *_scrollView;
}

@end

@implementation CommodityViewController

@synthesize commodityInfo = _commodityInfo;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"title.commodity", @"Detail") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 83, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 120, 29);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = - 16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
    
    // 不设置自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = YES;
    // [NSString stringWithFormat:@"em_example_image_%d", (int)button.tag + 1  product_details_1_zh.png
    UIImage *commodityImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"em_example1_text_detail", @"em_example_image_"), self.tag + 1]];
    CGFloat height = (commodityImage.size.height / commodityImage.size.width) * _scrollView.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, height)];
    imageView.image = commodityImage;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    [_scrollView addSubview:imageView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.alpha = 1;
    [self.view addSubview:footerView];
    
    
    CustomButton * messageButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"hd_chat_icon_red"] forState:UIControlStateNormal];
    [messageButton setTitle:NSLocalizedString(@"customerChatNew", @"Customer") forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [messageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    messageButton.imageRect = CGRectMake(30, footerView.height/3, footerView.height/3, footerView.height/3);
    messageButton.titleRect = CGRectMake(55, footerView.height/4, 100, footerView.height/2);
    [self.view addSubview:messageButton];
    messageButton.frame = CGRectMake(0, 0, footerView.width/2, footerView.height);
    messageButton.layer.borderWidth =1;
    messageButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [footerView addSubview:messageButton];
    
    [messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    CustomButton * vecButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [vecButton setImage:[UIImage imageNamed:@"hd_chat_icon_red"] forState:UIControlStateNormal];
    [vecButton setTitle:NSLocalizedString(@"customerVEC", @"Customer") forState:UIControlStateNormal];
    vecButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [vecButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [vecButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    vecButton.imageRect = CGRectMake(30, footerView.height/3, footerView.height/3, footerView.height/3);
    vecButton.titleRect = CGRectMake(55, footerView.height/4, 100, footerView.height/2);
    vecButton.layer.borderWidth =1;
    vecButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.view addSubview:vecButton];
    vecButton.frame = CGRectMake(messageButton.size.width, 0, footerView.width/2, footerView.height);
    [footerView addSubview:vecButton];
    [vecButton addTarget:self action:@selector(vecAction) forControlEvents:UIControlEventTouchUpInside];
    
    
//
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - (footerView.height/3) * 2, footerView.height/3, footerView.height/3, footerView.height/3)];
//    [button setImage:[UIImage imageNamed:@"hd_icon_like_gray"] forState:UIControlStateNormal];
//    [footerView addSubview:button];
    [self.view bringSubviewToFront:footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messageAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:self.commodityInfo];
}
- (void)vecAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_VEC object:self.commodityInfo];
}
@end
