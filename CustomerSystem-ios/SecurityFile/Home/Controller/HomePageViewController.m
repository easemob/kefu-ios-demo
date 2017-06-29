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
#import "HomeViewController.h"
@interface HomePageViewController ()
{
    UIWindow *_window;
}
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
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    
    [self setUI];
}

- (void)setUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    [self.view addSubview:self.scrollView];
    
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.191);
    self.topImageView.image = [UIImage imageNamed:@"banner"];
    self.topImageView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    [self.scrollView addSubview:self.topImageView];
    
    self.buttonBgView = [[UIView alloc] init];
    self.buttonBgView.frame = CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), kScreenWidth, 170);
    self.buttonBgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.buttonBgView];
    
    UIView *buttonBgLine = [[UIView alloc] init];
    buttonBgLine.frame = CGRectMake(0, 170, kScreenWidth, 0.5);
    buttonBgLine.backgroundColor = RGBACOLOR(190, 190, 190, 1);
    [self.buttonBgView addSubview:buttonBgLine];
    
    NSArray *titleArray = @[@"大盘行情",@"自选股",@"财经资讯",@"股票交易",@"热销基金",@"新股申购",@"我要开户",@"设置"];
    for (int i = 0; i< 2; i++) {
        for (int j = 0; j< 4; j++) {
            
            self.button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/5 + (50 +( kScreenWidth - 200)/5)*j, i*85 + 10, 48, 48)];
            self.button.tag = i*4 + j + 1;
            self.button.clipsToBounds = YES;
            self.button.layer.cornerRadius = 10;
            [self.button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"homeButton_%d",i*4 + j + 1]] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonBgView addSubview:self.button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.button.frame) - 3.5, CGRectGetMaxY(self.button.frame)+3, 55, 16)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = RGBACOLOR(76, 76, 76, 1);
            label.text = [titleArray objectAtIndex:(i*4+j)];
            label.font = [UIFont systemFontOfSize:13.0];
            [self.buttonBgView addSubview:label];
    
        }
    }
    
    
    self.bottomImageView = [[UIImageView alloc] init];
    self.bottomImageView.frame = CGRectMake(0, CGRectGetMaxY(self.buttonBgView.frame) + 10, kScreenWidth, kScreenHeight * 0.364);
    self.bottomImageView.image = [UIImage imageNamed:@"img1"];
    [self.scrollView addSubview:self.bottomImageView];
    
    UIView *bottomImageTopLine = [[UIView alloc] init];
    bottomImageTopLine.frame = CGRectMake(0, CGRectGetMaxY(self.buttonBgView.frame) + 10, kScreenWidth, 0.5);
    bottomImageTopLine.backgroundColor = RGBACOLOR(190, 190, 190, 1);
    [self.scrollView addSubview:bottomImageTopLine];    
    
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
