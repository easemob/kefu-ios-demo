//
//  AgoraViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/5.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "AgoraViewController.h"

@interface AgoraViewController ()
// 定义 localView 变量
@property (nonatomic, strong) UIView *localView;
// 定义 remoteView 变量
@property (nonatomic, strong) UIView *remoteView;
@end

@implementation AgoraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 调用初始化视频窗口函数
       [self initViews];
       // 后续步骤调用 Agora API 使用的函数
//       [self initializeAgoraEngine];
//       [self setupLocalVideo];
//       [self joinChannel];
}

// 设置视频窗口布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.remoteView.frame = self.view.bounds;
    self.localView.frame = CGRectMake(self.view.bounds.size.width - 90, 0, 90, 160);
}
- (void)initViews {
    // 初始化远端视频窗口
    self.remoteView = [[UIView alloc] init];
    [self.view addSubview:self.remoteView];
    // 初始化本地视频窗口
    self.localView = [[UIView alloc] init];
    [self.view addSubview:self.localView];
}

@end
