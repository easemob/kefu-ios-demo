//
//  HDUploadListViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDUploadListViewController.h"

@interface HDUploadListViewController ()
@property (nonatomic, strong) UIView *navView;
@end

@implementation HDUploadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(22);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(44);
        
        
    }];
}

#pragma mark - event
- (void)dismissViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - lzye

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        UIButton * backBtn = [[UIButton alloc] init];
        [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navView.mas_centerY);
            make.leading.offset(20);
            make.width.height.offset(44);
        }];
        
      
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.text = @"上传列表";
        [_navView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navView.mas_centerY);
            make.centerX.mas_equalTo(_navView.mas_centerX);
        }];
        
    }
    
    return _navView;
}

@end
