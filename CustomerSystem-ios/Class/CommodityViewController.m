//
//  CommodityViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "CommodityViewController.h"

#import "LocalDefine.h"

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
    self.title = NSLocalizedString(@"title.commodity", @"Commodity Info");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = YES;
    
    UIImage *commodityImage = [UIImage imageNamed:@"commodity"];
    CGFloat height = (commodityImage.size.height / commodityImage.size.width) * _scrollView.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, height)];
    imageView.image = commodityImage;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height + 40);
    [_scrollView addSubview:imageView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.alpha = 0.8;
    [self.view addSubview:footerView];
    
    UIView *footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, footerView.frame.size.width, 0.5)];
    footerLine.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:footerLine];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.5, footerView.frame.size.width, footerView.frame.size.height - 0.5)];
    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"customerChat", @" Customer")] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
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

@end
