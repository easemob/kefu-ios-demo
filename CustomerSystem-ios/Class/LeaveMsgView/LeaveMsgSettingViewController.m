//
//  LeaveMsgSettingViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/6.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgSettingViewController.h"

#import "EditViewController.h"
#import "EMIMHelper.h"

@interface LeaveMsgSettingViewController ()
{
    NSString *_tenantId;
    NSString *_projectId;
}
@end

@implementation LeaveMsgSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tenantId = [EMIMHelper defaultHelper].tenantId;
    _projectId = [EMIMHelper defaultHelper].projectId;
    
    self.title = NSLocalizedString(@"title.leavemsgsetting", @"Leave Message Setting");
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    [self setupBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChange:) name:KNOTIFICATION_SETTINGCHANGE object:nil];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
            cell.textLabel.text =@"TenantId";
            tempLabel.text = _tenantId;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"ProjectId";
            tempLabel.text = _projectId;
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
    topLineView.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
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
            EditViewController *editController = [[EditViewController alloc] initWithType:@"tenantId" content:_tenantId];
            editController.title = @"TenantId";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 1:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"projectId" content:_projectId];
            editController.title = @"ProjectId";
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - notification

- (void)settingChange:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)object;
        NSString *type = [dic objectForKey:@"type"];
        NSString *content = [dic objectForKey:@"content"];
        
        if ([type isEqualToString:@"tenantId"]) {
            _tenantId = content;
            [EMIMHelper defaultHelper].tenantId = content;
        } else if ([type isEqualToString:@"projectId"]){
            _projectId = content;
            [EMIMHelper defaultHelper].projectId = content;
        }
        [self.tableView reloadData];
    }
}

@end;