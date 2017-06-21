//
//  HomePageViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/19.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HomePageViewController.h"
#import "SettingViewController.h"
#import "HotFundViewController.h"
@interface HomePageViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *buttonBgView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUI];
}

- (void)setUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.backgroundColor = RGBACOLOR(213, 213, 213, 1);
    [self.view addSubview:self.scrollView];
    
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    self.topImageView.image = [UIImage imageNamed:@"banner"];
    [self.scrollView addSubview:self.topImageView];
    
    self.buttonBgView = [[UIView alloc] init];
    self.buttonBgView.frame = CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), kScreenWidth, 180);
    self.buttonBgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.buttonBgView];
    
    NSArray *titleArray = @[@"大盘行情",@"自选股",@"财经资讯",@"股票交易",@"热销基金",@"新股申购",@"我要开户",@"设置"];
    for (int i = 0; i< 2; i++) {
        for (int j = 0; j< 4; j++) {
            
            self.button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/5 + (50 +( kScreenWidth - 200)/5)*j, i*85 + 10, 50, 50)];
            self.button.tag = i*4 + j + 1;
            self.button.clipsToBounds = YES;
            self.button.layer.cornerRadius = 10;
            [self.button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"homeButton_%d",i*4 + j + 1]] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonBgView addSubview:self.button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.button.frame), CGRectGetMaxY(self.button.frame)+5, 50, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [titleArray objectAtIndex:(i*4+j)];
            label.font = [UIFont systemFontOfSize:12];
            [self.buttonBgView addSubview:label];
        
        }
    }
    
    self.bottomImageView = [[UIImageView alloc] init];
    self.bottomImageView.frame = CGRectMake(0, CGRectGetMaxY(self.buttonBgView.frame) + 10, kScreenWidth, 230);
    self.bottomImageView.image = [UIImage imageNamed:@"img1"];
    [self.scrollView addSubview:self.bottomImageView];
    
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.bottomImageView.frame) + 100);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}
    
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 5) {
        HotFundViewController *hotFundVC = [[HotFundViewController alloc] init];
        [self.navigationController pushViewController:hotFundVC animated:YES];
    } else if(button.tag == 8){
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        settingVC.title = @"设置";
        [self.navigationController pushViewController:settingVC animated:YES];
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
