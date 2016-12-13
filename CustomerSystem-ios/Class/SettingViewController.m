//
//  SettingViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate+easemob.h"
#import "EditViewController.h"
#import "LocalDefine.h"

@interface SettingViewController ()<UIAlertViewDelegate>
{
    NSString *_appkey;
    NSString *_cname;
    NSString *_tenantId;
    NSString *_projectId;
    NSString *_nickname;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7)
    {
        self.tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:243 / 255.0 alpha:1.0];
    }
    else{
        self.tableView.scrollEnabled = NO;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 300)];
        footerView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:243 / 255.0 alpha:1.0];
        self.tableView.tableFooterView = footerView;
    }
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _appkey = [[SCLoginManager shareLoginManager] appkey];
    _cname = [[SCLoginManager shareLoginManager] cname];
    _tenantId = [[SCLoginManager shareLoginManager] tenantId];
    _projectId = [[SCLoginManager shareLoginManager] projectId];
    _nickname = [[SCLoginManager shareLoginManager] nickname];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChange:) name:KNOTIFICATION_SETTINGCHANGE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, tableView.frame.size.width - 100 - 20 - 30, 25)];
        contentLabel.font = [UIFont systemFontOfSize:17.0];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.tag = 99;
        contentLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:contentLabel];
    }
    
    UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:99];
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            cell.textLabel.text = @"AppKey";
            tempLabel.text = _appkey;
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"customerUser", @"Customer");
            tempLabel.text = _cname;
        }
            break;
        
            break;
        case 2:
        {
            cell.textLabel.text = @"tenantId";
            tempLabel.text = _tenantId;
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"projectId";
            tempLabel.text = _projectId;
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"设置昵称";
            tempLabel.text = _nickname;
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"意见反馈";
            tempLabel.text = @"";
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
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 15)];
    topLineView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:243 / 255.0 alpha:1.0];

    return topLineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"appkey" content:_appkey];
            editController.title = @"Appkey";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 1:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"cname" content:_cname];
            editController.title = @"IM 服务号";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 2:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"tenantId" content:_tenantId];
            editController.title = @"租户ID";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 3:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"projectId" content:_projectId];
            editController.title = @"留言ID";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 4:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"nickname" content:_nickname];
            editController.title = @"昵称";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;                             
        case 5:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        //[self showHint:NSLocalizedString(@"restart", @"restart...")];
        //退出
        /*
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
            EMIMHelper *helper = [EMIMHelper defaultHelper];
            [helper refreshHelperData];
            //重新设置appkey
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
            NSString *apnsCertName = nil;
#if DEBUG
            apnsCertName = @"chatdemoui_dev";
#else
            apnsCertName = @"chatdemoui";
#endif
            [[EaseMob sharedInstance] registerSDKWithAppKey:helper.appkey
                                               apnsCertName:apnsCertName];
            
            //重新登录
            [helper loginEasemobSDK];
            [self hideHud];
        } onQueue:nil];
         */
    }
}

#pragma mark - private

- (void)settingChange:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)object;
        NSString *type = [dic objectForKey:@"type"];
        NSString *content = [dic objectForKey:@"content"];
        
        BOOL needRestart = NO;
        if ([type isEqualToString:@"appkey"]) {
            needRestart = ![content isEqualToString:_appkey];
            if (needRestart) {
                _appkey = content;
                [SCLoginManager shareLoginManager].appkey = _appkey;
            }
        }
        else if ([type isEqualToString:@"cname"]){
            _cname = content;
            [SCLoginManager shareLoginManager].cname = _cname;
        } else if ([type isEqualToString:@"nickname"]) {
            _nickname = content;
            [SCLoginManager shareLoginManager].nickname = content;
        } else if ([type isEqualToString:@"tenantId"]) {
            _tenantId = content;
            [SCLoginManager shareLoginManager].tenantId = _tenantId;
        } else if ([type isEqualToString:@"projectId"]) {
            _projectId = content;
            [SCLoginManager shareLoginManager].projectId = _projectId;
        }
        
        [self.tableView reloadData];
        if (needRestart) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"restart", @"Restart") message:NSLocalizedString(@"restartInfo", @"Configuration information need to reboot to take effect") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert show];
            });
            
        }
    }
}

//- (void)buttonAction:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    if (button.selected) {
//        [self showHint:NSLocalizedString(@"saveSetting", @"save setting...")];
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *appKey = [userDefaults objectForKey:kAppKey];
//        if ([self.appkeyField.text length] == 0) {
//            self.appkeyField.text = kDefaultAppKey;
//        }
//        else{
//            NSArray *tmpArray = [self.appkeyField.text componentsSeparatedByString:@"#"];
//            if ([tmpArray count] != 2) {
//                [self hideHud];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:NSLocalizedString(@"appkeyError", @"appkey error") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
//                return;
//            }
//        }
//        
//        if (![self.appkeyField.text isEqualToString:appKey]) {
//            [userDefaults setObject:self.appkeyField.text forKey:kAppKey];
//            
//            //退出
//            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//                //重新设置appkey
//                [[EaseMob sharedInstance] registerSDKWithAppKey:self.appkeyField.text
//                                                   apnsCertName:nil];
//                
//                //重新登录
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults removeObjectForKey:@"username"];
//                [userDefaults removeObjectForKey:@"password"];
//                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [delegate loginEasemobSDK];
//                [self hideHud];
//            } onQueue:nil];
//        }
//        
//        if ([self.cunameField.text length] == 0) {
//            self.cunameField.text = kDefaultCustomerName;
//        }
//        NSString *cuname = [userDefaults objectForKey:kCustomerName];
//        if (![self.cunameField.text isEqualToString:cuname]) {
//            [userDefaults setObject:self.cunameField.text forKey:kCustomerName];
//        }
//        
//        _appkeyField.layer.borderWidth = 0;
//        _cunameField.layer.borderWidth = 0;
//        _appkeyField.enabled = NO;
//        _cunameField.enabled = NO;
//        [_appkeyField resignFirstResponder];
//        [_cunameField resignFirstResponder];
//    }
//    else{
//        _appkeyField.layer.borderWidth = 1;
//        _cunameField.layer.borderWidth = 1;
//        _appkeyField.enabled = YES;
//        _cunameField.enabled = YES;
//    }
//    
//    button.selected = !button.selected;
//    
//    self.navigationItem.rightBarButtonItem.enabled = button.selected;
//}

@end
