//
//  EditViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EditViewController.h"

#import "LocalDefine.h"

@interface EditViewController ()
{
    UITextField *_editField;
    NSString *_type;
    NSString *_content;
}

@end

@implementation EditViewController

- (instancetype)initWithType:(NSString *)type content:(NSString *)content
{
    self = [super init];
    if (self) {
        _type = type;
        _content = content;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:243 / 255.0 alpha:1.0];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _editField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, contentView.frame.size.width - 20, contentView.frame.size.height)];
    _editField.backgroundColor = [UIColor whiteColor];
    _editField.text = _content;
    _editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _editField.returnKeyType = UIReturnKeyDone;
    _editField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contentView addSubview:_editField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)back
{
    if ([_editField.text length] == 0) {
        _editField.text = _content;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SETTINGCHANGE object:@{@"type":_type, @"content":_editField.text}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
