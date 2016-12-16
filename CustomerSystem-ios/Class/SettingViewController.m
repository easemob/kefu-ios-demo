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
#import "AppDelegate+EaseMob.h"


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
{
    SCLoginManager *_lgM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lgM = [SCLoginManager shareLoginManager];
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
    [self initializePropertys];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChange:) name:KNOTIFICATION_SETTINGCHANGE object:nil];
}

- (void)initializePropertys {
    _appkey = _lgM.appkey;
    _cname = _lgM.cname;
    _tenantId = _lgM.tenantId;
    _projectId = _lgM.projectId;
    _nickname = _lgM.nickname;
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
    return 7;
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
            cell.textLabel.text = NSLocalizedString(@"title.tenantId",@"tenantId");
            tempLabel.text = _tenantId;
        }
            break;
        case 3:
        {
            cell.textLabel.text = NSLocalizedString(@"title.projectId", @"projectId");
            tempLabel.text = _projectId;
        }
            break;
        case 4:
        {
            cell.textLabel.text = NSLocalizedString(@"setNickname", @"setNickname");
            tempLabel.text = _nickname;
        }
            break;
        case 5:
        {
            cell.textLabel.text = NSLocalizedString(@"setting.feedback", @"feedback");
            tempLabel.text = @"";
        }
            break;
            case 6:
        {
            UILabel *commit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
            commit.text = @"确认修改";
            commit.textAlignment = NSTextAlignmentCenter;
            commit.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:commit];
            cell.accessoryType = UITableViewCellAccessoryNone;
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
            editController.title = NSLocalizedString(@"customerUser", @"Customer");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 2:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"tenantId" content:_tenantId];
            editController.title = NSLocalizedString(@"title.tenantId",@"tenantId");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 3:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"projectId" content:_projectId];
            editController.title = NSLocalizedString(@"title.projectId", @"projectId");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 4:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"nickname" content:_nickname];
            editController.title = NSLocalizedString(@"setNickname", @"setNickname");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;                             
        case 5:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:nil];
        }
            break;
            case 6:
        {
//            if ([_appkey isEqualToString:_lgM.appkey]) {
//                UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:@"提示" message:@"appkey未做修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//                return;
//            }
            UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:@"提示" message:@"昵称只有在和appkey同时修改时才起作用,确认修改?" delegate:self cancelButtonTitle:@"暂不修改" otherButtonTitles:@"确认修改", nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) { //修改
         [self commitModify];
    }
}

- (void)commitModify {
    _lgM.appkey = _appkey;
    _lgM.cname = _cname;
    _lgM.nickname = _nickname;
    _lgM.tenantId = _tenantId;
    _lgM.projectId = _projectId;
    [self.tableView reloadData];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate resetCustomerServiceSDK];
}


#pragma mark - private

- (void)settingChange:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)object;
        NSString *type = [dic objectForKey:@"type"];
        NSString *content = [dic objectForKey:@"content"];
        if ([type isEqualToString:@"appkey"]) {
                _appkey = content;
        }
        else if ([type isEqualToString:@"cname"]){
            _cname = content;
        } else if ([type isEqualToString:@"nickname"]) {
            _nickname = content;
        } else if ([type isEqualToString:@"tenantId"]) {
            _tenantId = content;
        } else if ([type isEqualToString:@"projectId"]) {
            _projectId = content;
        }
        [self.tableView reloadData];
    }
}


@end
