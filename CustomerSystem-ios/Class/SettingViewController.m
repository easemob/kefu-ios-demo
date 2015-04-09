//
//  SettingViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "SettingViewController.h"

#import "AppDelegate+EaseMob.h"
#import "UIViewController+HUD.h"
#import "EaseMob.h"
#import "LocalDefine.h"

@interface SettingViewController ()

@property (nonatomic, strong) UITextField *appkeyField;
@property (nonatomic, strong) UITextField *cunameField;

@end

@implementation SettingViewController

@synthesize appkeyField = _appkeyField;
@synthesize cunameField = _cunameField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    footerView.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:234 / 255.0 alpha:1.0];
    self.tableView.tableFooterView = footerView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, footerView.frame.size.width, 50)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(@"edit", @"Edit") forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"save", @"Save") forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [userDefaults objectForKey:kAppKey];
    if ([appKey length] == 0) {
        appKey = kDefaultAppKey;
        [userDefaults setObject:appKey forKey:kAppKey];
    }
    NSString *cuname = [userDefaults objectForKey:kCustomerName];
    if ([cuname length] == 0) {
        cuname = kDefaultCustomerName;
        [userDefaults setObject:cuname forKey:kCustomerName];
    }
    
    CGFloat width = self.tableView.frame.size.width - 100 - 30;
    _appkeyField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, width, 40)];
    _appkeyField.text = appKey;
    _appkeyField.layer.cornerRadius = 3.0;
    _appkeyField.layer.borderWidth = 0;
    _appkeyField.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:0.8] CGColor];
    _appkeyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _appkeyField.leftViewMode = UITextFieldViewModeAlways;
    UIView *appkeyLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _appkeyField.frame.size.height)];
    appkeyLeftView.backgroundColor = [UIColor clearColor];
    [_appkeyField setLeftView:appkeyLeftView];
    _appkeyField.enabled = NO;
    
    _cunameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, width, 40)];
    _cunameField.text = cuname;
    _cunameField.layer.cornerRadius = 3.0;
    _cunameField.layer.borderWidth = 0;
    _cunameField.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:0.8] CGColor];
    _cunameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cunameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *nameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _cunameField.frame.size.height)];
    nameLeftView.backgroundColor = [UIColor clearColor];
    [_cunameField setLeftView:nameLeftView];
    _cunameField.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            cell.textLabel.text = @"AppKey:";
            [cell.contentView addSubview:self.appkeyField];
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"title.customer", @"Customer");
            [cell.contentView addSubview:self.cunameField];
        }
            break;
    
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 10)];
    topLineView.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:234 / 255.0 alpha:1.0];

    return topLineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - private

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [self showHint:NSLocalizedString(@"saveSetting", @"save setting...")];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *appKey = [userDefaults objectForKey:kAppKey];
        if ([self.appkeyField.text length] == 0) {
            self.appkeyField.text = kDefaultAppKey;
        }
        else{
            NSArray *tmpArray = [self.appkeyField.text componentsSeparatedByString:@"#"];
            if ([tmpArray count] != 2) {
                [self hideHud];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:NSLocalizedString(@"appkeyError", @"appkey error") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        
        if (![self.appkeyField.text isEqualToString:appKey]) {
            [userDefaults setObject:self.appkeyField.text forKey:kAppKey];
            
            //退出
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
                //重新设置appkey
                [[EaseMob sharedInstance] registerSDKWithAppKey:self.appkeyField.text
                                                   apnsCertName:nil];
                
                //重新登录
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"username"];
                [userDefaults removeObjectForKey:@"password"];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate loginEasemobSDK];
                [self hideHud];
            } onQueue:nil];
        }
        
        if ([self.cunameField.text length] == 0) {
            self.cunameField.text = kDefaultCustomerName;
        }
        NSString *cuname = [userDefaults objectForKey:kCustomerName];
        if (![self.cunameField.text isEqualToString:cuname]) {
            [userDefaults setObject:self.cunameField.text forKey:kCustomerName];
        }
        
        _appkeyField.layer.borderWidth = 0;
        _cunameField.layer.borderWidth = 0;
        _appkeyField.enabled = NO;
        _cunameField.enabled = NO;
        [_appkeyField resignFirstResponder];
        [_cunameField resignFirstResponder];
    }
    else{
        _appkeyField.layer.borderWidth = 1;
        _cunameField.layer.borderWidth = 1;
        _appkeyField.enabled = YES;
        _cunameField.enabled = YES;
    }
    
    button.selected = !button.selected;
    
//    self.navigationItem.rightBarButtonItem.enabled = button.selected;
}

@end
