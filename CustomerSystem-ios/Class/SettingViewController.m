//
//  SettingViewController.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate+HelpDesk.h"
#import "EditViewController.h"
#import "LocalDefine.h"
#import "HDChatViewController.h"


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
    UIScrollView *_scrollview;
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
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

- (void)setvalueWithDic:(NSDictionary *)dic {
    NSString *newAppkey = [dic valueForKey:@"appkey"];
    if (![_appkey isEqualToString:newAppkey]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt")  message:NSLocalizedString(@"app_key_modifya", @"Appkey modify Need Restart") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancela", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        __weak typeof(self) weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"restarta", @"Restart") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _appkey = [dic valueForKey:@"appkey"];
            _cname = [dic valueForKey:@"imservicenum"];
            _tenantId = [dic valueForKey:@"tenantid"];
            _projectId = [dic valueForKey:@"projectId"];
            [weakSelf commitModify];
        }]];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        _cname = [dic valueForKey:@"imservicenum"];
        _tenantId = [dic valueForKey:@"tenantid"];
        _projectId = [dic valueForKey:@"projectId"];
        _lgM.cname = _cname;
        _lgM.tenantId = _tenantId;
        _lgM.projectId = _projectId;
    }
    
    [self.tableView reloadData];
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
        UILabel *contentLabel = nil;
        if (indexPath.section ==3 || indexPath.section == 4) {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, tableView.frame.size.width - 100 - 20 - 30, 25)];
        } else {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, tableView.frame.size.width - 100 - 20 - 30, 25)];
        }
        

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
            cell.textLabel.text = NSLocalizedString(@"setNickname", @"setNickname");
            tempLabel.text = nil;
        }
            break;
        case 3:
        {
            cell.textLabel.text = NSLocalizedString(@"title.tenantId",@"tenantId");
            tempLabel.text = _tenantId;
        }
            break;
        case 4:
        {
            cell.textLabel.text = NSLocalizedString(@"title.projectId", @"projectId");
            tempLabel.text = _projectId;
        }
            break;
        case 5:
        {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *build = [NSString stringWithFormat:@"(%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            NSString *fullVersion = [version stringByAppendingString:build];
            cell.textLabel.text = NSLocalizedString(@"setting.feedback", @"feedback");
//            tempLabel.text = [NSString stringWithFormat:@"Version:%@",fullVersion];
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
{    return 45;
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
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 1:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"cname" content:_cname];
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 2:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"nickname" content:_nickname];
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 3:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"tenantId" content:_tenantId];
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 4:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"projectId" content:_projectId];
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;

        case 5:
        {
            HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:_cname];
            [self.navigationController pushViewController:chat animated:YES];

        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

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
        NSLog(@"content--%@",content);
        
        if ([type isEqualToString:@"appkey"]) {
            _appkey = content;
            _lgM.appkey = content;
        }
        else if ([type isEqualToString:@"cname"]){
            _cname = content;
            _lgM.cname = content;
        } else if ([type isEqualToString:@"nickname"]) {
            _nickname = content;
            _lgM.nickname = content;
        } else if ([type isEqualToString:@"tenantId"]) {
            _tenantId = content;
            _lgM.tenantId = content;
        } else if ([type isEqualToString:@"projectId"]) {
            _projectId = content;
            _lgM.projectId = content;
        }
        [self.tableView reloadData];
    }
}


@end
