//
//  MallViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "MallViewController.h"

#import "CommodityViewController.h"

@interface MallViewController ()
{
    UIScrollView *_scrollView;
    NSArray *_infoArray;
}

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    
    CGFloat margin = 10;
    CGFloat width = (_scrollView.frame.size.width - 3 * margin) / 2;
    CGFloat height = (_scrollView.frame.size.height - 3 * margin) / 2;
    NSArray *imgUrls = @[
                         @"http://o8ugkv090.bkt.clouddn.com/em_one.png",
                         @"http://o8ugkv090.bkt.clouddn.com/em_two.png",
                         @"http://o8ugkv090.bkt.clouddn.com/em_three.png",
                         @"http://o8ugkv090.bkt.clouddn.com/em_four.png"
                         ];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + i * (margin + width), margin + j * (margin + height), width, height)];
            button.tag = i * 2 + j;
//            NSString *imageName = [NSString stringWithFormat:@"mallImage%li", (long)button.tag];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrls[button.tag]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
            [button addTarget:self action:@selector(mallImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
    }
    
    _infoArray = [NSArray arrayWithObjects:@{
    @"type":@"track", @"title":@"测试track1", @"desc":@"2015早春新款高腰复古牛仔裤", @"price":@"￥128", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/em_one.png", @"item_url":@"http://www.easemob.com"},
  @{@"type":@"order", @"title":@"测试order1", @"order_title":@"订单号：123456", @"desc":@"露肩名媛范套装", @"price":@"￥518", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/em_two.png", @"item_url":@"http://www.lagou.com/"},
  @{@"type":@"track", @"title":@"测试track2", @"desc":@"假两件衬衣+V领毛衣上衣", @"price":@"￥235", @"item_url":@"http://www.baidu.com",@"img_url":@"http://o8ugkv090.bkt.clouddn.com/em_three.png"},
  @{@"type":@"order", @"title":@"测试order2", @"order_title":@"订单号：7890", @"desc":@"插肩棒球衫外套", @"price":@"￥162", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/em_four.png", @"item_url":@"http://www.baidu.com"}, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)mallImageAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    CommodityViewController *commodityController = [[CommodityViewController alloc] init];
    commodityController.commodityInfo = [_infoArray objectAtIndex:button.tag];
    [self.navigationController pushViewController:commodityController animated:YES];
}

@end
