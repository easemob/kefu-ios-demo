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

@interface EditViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>
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

//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:243 / 255.0 alpha:1.0];
    
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    NSString *name = nil;
    if ([_type isEqualToString:@"appkey"]) {
        name = @"AppKey";
    } else if ([_type isEqualToString:@"cname"]) {
        name = NSLocalizedString(@"customernumber", @"IM service No.");
    } else if ([_type isEqualToString:@"nickname"]){
        name = NSLocalizedString(@"login_user_nick", @"User Nick");
    } else if ([_type isEqualToString:@"tenantId"]){
        name = NSLocalizedString(@"set_tenantId", @"TenantId");
    } else if ([_type isEqualToString:@"projectId"]){
        name = NSLocalizedString(@"set_leave_messageid", @"Leave Message ID");
    }

    [backButton setTitle:name forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 163, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 200, 29);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _editField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, contentView.frame.size.width - 20, contentView.frame.size.height)];
    _editField.backgroundColor = [UIColor whiteColor];
    _editField.text = _content;
    _editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _editField.returnKeyType = UIReturnKeyDone;
    _editField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if ([_type isEqualToString:@"projectId"] || [_type isEqualToString:@"tenantId"]) {
        _editField.keyboardType = UIKeyboardTypeNumberPad;
    }
    _editField.delegate = self;
    [contentView addSubview:_editField];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114 - iPhoneXBottomHeight, kScreenWidth, 50)];
    view.backgroundColor = RGBACOLOR(184, 22, 22, 1);
    [self.view addSubview:view];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 5, 40, 40)];
    [saveButton setTitle:NSLocalizedString(@"save", @"Save") forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveButton addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveButton];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (void)saveButton
{
    [self.view endEditing:YES];
    if ([_editField.text length] == 0) {
        _editField.text = _content;
    }
    if (![_editField.text isEqualToString:_content]) {
        if ([_type isEqualToString:@"appkey"]) {
            [self restarTheApp];
        } else if([_type isEqualToString:@"tenantId"]) {
            [self changeTenantId];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SETTINGCHANGE object:@{@"type":_type, @"content":_editField.text}];
            NSLog(@"text---%@", _editField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restarTheApp
{
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    lgM.appkey = _editField.text;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate resetCustomerServiceSDK];
}

- (void)changeTenantId {
    CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
    lgM.tenantId = _editField.text;
    NSLog(@"new tenantId :%@",lgM.tenantId);
    [[HDClient sharedClient] changeTenantId:lgM.tenantId];
}

-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    [_editField endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_editField endEditing:YES];
    return YES;
}

@end
