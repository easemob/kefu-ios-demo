//
//  InformationViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/19.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 110)];
    [self.view addSubview:scrollView];
    
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.902)];
    imageVC.image = [UIImage imageNamed:@"img6"];
    [scrollView addSubview:imageVC];
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(imageVC.frame) + 50);
    scrollView.showsHorizontalScrollIndicator = NO;
    
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
