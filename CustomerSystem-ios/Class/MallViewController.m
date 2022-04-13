//
//  MallViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "MallViewController.h"

#import "CommodityViewController.h"
#import "CommodityInfoView.h"

@interface MallViewController () 

{
    UIScrollView *_scrollView;
    NSArray *_infoArray;
}

@property (nonatomic, strong) UIButton *button;

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
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 44);
    
    CGFloat margin = 0;
    CGFloat width = (_scrollView.frame.size.width - 3 * margin) / 2;
    CGFloat height = (_scrollView.frame.size.height - 3 * margin) / 3.5;
//    NSArray *imgUrls = @[
//                         @"http://o8ugkv090.bkt.clouddn.com/em_one.png",
//                         @"http://o8ugkv090.bkt.clouddn.com/em_two.png",
//                         @"http://o8ugkv090.bkt.clouddn.com/em_three.png",
//                         @"http://o8ugkv090.bkt.clouddn.com/em_four.png"
//                         ];
    
    UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/3.5)];
    [headBtn setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"Header.image", @"em_main_introduce")] forState:UIControlStateNormal];
//    [headBtn addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:headBtn];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++){


            
            if ((i==0&&j==1) || (i==1 && j==1)) {
                self.button = [[UIButton alloc] initWithFrame:CGRectMake(i * (margin + width), j * (margin + height) + kScreenHeight/3.5 + height/4, width - 2, height)];
            } else {
                self.button = [[UIButton alloc] initWithFrame:CGRectMake(i * (margin + width), j * (margin + height) + kScreenHeight/3.5, width - 2, height)];
            }

            self.button.tag = i * 2 + j;

            NSString *imageName = [NSString stringWithFormat:@"em_example_image_%d", (int)self.button.tag + 1];
//            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrls[button.tag]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
            [self.button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(mallImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:self.button];
            
            CommodityInfoView *civ = [[CommodityInfoView alloc] initWithFrame:CGRectMake(i * (margin + width),
                                                                                         CGRectGetMaxY(self.button.frame),
                                                                                         width-2,
                                                                                         height/4)
                                                                          tag:self.button.tag];
           
            [_scrollView addSubview:civ];
        }
    }
    _infoArray = [NSArray arrayWithObjects:
  @{@"type":@"track", @"title":NSLocalizedString(@"em_chat_I_focus", @"I focus on"), @"desc":NSLocalizedString(@"em_example1_text", @"Crackie leather bomber"), @"price":@"¥8000", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/hd_one.png", @"item_url":@"http://www.easemob.com"},
  @{@"type":@"order", @"title":NSLocalizedString(@"em_chat_I_focus", @"I focus on"), @"order_title":[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"order_number", @"Order number:"),123], @"desc":NSLocalizedString(@"em_example3_text", @"Jeffrey campbell duice pump"), @"price":@"¥5400", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/hd_three.png", @"item_url":@"http://www.lagou.com/"},
  @{@"type":@"track", @"title":NSLocalizedString(@"em_chat_I_focus", @"I focus on"), @"desc":NSLocalizedString(@"em_example2_text", @"Birkin Bag"), @"price":@"¥15800", @"item_url":@"http://o8ugkv090.bkt.clouddn.com/hd_two.png",@"img_url":@"http://o8ugkv090.bkt.clouddn.com/hd_two.png"},
  @{@"type":@"order", @"title":NSLocalizedString(@"em_chat_I_focus", @"I focus on"), @"order_title":[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"order_number", @"Order number:"),456], @"desc":NSLocalizedString(@"em_example4_text", @"Cartier"), @"price":@"¥160000", @"img_url":@"http://o8ugkv090.bkt.clouddn.com/hd_four.png", @"item_url":@"http://www.baidu.com"}, nil];
    
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
    commodityController.tag = button.tag;
    [self.navigationController pushViewController:commodityController animated:YES];
}

@end
