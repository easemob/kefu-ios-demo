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
    _editField.delegate = self;
    [contentView addSubview:_editField];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, kScreenWidth, 50)];
    view.backgroundColor = RGBACOLOR(184, 22, 22, 1);
    [self.view addSubview:view];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 45, 5, 40, 40)];
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
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SETTINGCHANGE object:@{@"type":_type, @"content":_editField.text}];
            NSLog(@"text---%@", _editField.text);
        }
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
    if (![_editField.text isEqualToString:_content]) {
        if ([_type isEqualToString:@"appkey"]) {
            [self restarTheApp];
        } else {

        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restarTheApp
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"app_key_modifya", @"Appkey modify Need Restart") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancela", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"restarta", @"Restart") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        SCLoginManager *lgM = [SCLoginManager shareLoginManager];
        lgM.appkey = _editField.text;
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate resetCustomerServiceSDK];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
