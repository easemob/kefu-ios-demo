//
//  EditViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EditViewController.h"
#import "AppDelegate+HelpDesk.h"
#import "LocalDefine.h"

@interface EditViewController ()
{
    UITextField *_editField;
    NSString *_type;
    NSString *_content;
    NSString *_name;
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
    
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:_type forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.imageRect = CGRectMake(10, 10, 20, 18);
    backButton.titleRect = CGRectMake(40, 10, 200, 18);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(self.view.width * 0.5 - 80, 250, 220, 40);
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
    [self.view endEditing:YES];
    if ([_editField.text length] == 0) {
        _editField.text = _content;
    }
    if (![_editField.text isEqualToString:_content]) {
        if ([_type isEqualToString:@"AppKey"]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改appkey之后需要重启" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"重启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                SCLoginManager *lgM = [SCLoginManager shareLoginManager];
                lgM.appkey = _editField.text;
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [appDelegate resetCustomerServiceSDK];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SETTINGCHANGE object:@{@"type":_type, @"content":_editField.text}];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
