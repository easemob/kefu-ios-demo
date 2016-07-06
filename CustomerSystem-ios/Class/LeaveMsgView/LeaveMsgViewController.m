//
//  LeaveMsgViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgViewController.h"

#import "EditViewController.h"
#import "EaseMob.h"
#import "EMHttpManager.h"
#import "MBProgressHUD+Add.h"
#import "EMIMHelper.h"

@interface LeaveMsgViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *_name;
    NSString *_phone;
    NSString *_mail;
    NSString *_content;
}
@end

@implementation LeaveMsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.leavemsg", @"Leave Message");
    
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
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
}

#pragma mark - action

- (void)leaveMessage
{
    /*
     创建一个新的留言
     请求body：
     {
        subject: "ticket的主题, 可选, 如果没有的话, 那么默认是content的前10个字",
        content: "ticket的主要内容",
        status_id: "可选, 如果没有则使用project定义的默认的status, 如果没有定义默认的status则留空",
        priority_id: "可选, 如果没有则使用project定义的默认的priority, 如果没有定义默认的priority则留空",
        category_id: "可选, 如果没有则使用project定义的默认的category, 如果没有定义默认的priority则留空",
        creator: {
            name: "创建这个ticket的人的name",
            avatar: "创建这个ticket的人的头像"//可选
            email: "电子邮件地址",
            phone: "电话号码",
            qq: "qq号码",
            company: "公司",
            description: "具体的描述信息"
        },
        attachments:[{
            name: "该附件的名称",
            url: "该附件的url",
            type: "附件的类型, 当前支持image和file"
        }]
     }
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (_content.length > 10) {
        [parameters setObject:[_content substringWithRange:NSMakeRange(0, 10)] forKey:@"subject"];
    }
    [parameters setObject:_content.length>0?_content:@"" forKey:@"content"];
    [parameters setObject:@"" forKey:@"status_id"];
    [parameters setObject:@"" forKey:@"priority_id"];
    [parameters setObject:@"" forKey:@"category_id"];
    
    //creator
     NSMutableDictionary *creator = [NSMutableDictionary dictionary];
    [creator setObject:_name.length>0?_name:@"" forKey:@"name"];
    [creator setObject:@"" forKey:@"avatar"];
    [creator setObject:_mail.length>0?_mail:@"" forKey:@"email"];
    [creator setObject:_phone.length>0?_phone:@"" forKey:@"phone"];
    [creator setObject:@"" forKey:@"qq"];
    [creator setObject:@"" forKey:@"company"];
    [creator setObject:@"" forKey:@"description"];
    [parameters setObject:creator forKey:@"creator"];
    
    //attachments
    NSMutableArray *attachments = [NSMutableArray array];
    [parameters setObject:attachments forKey:@"attachments"];
    
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.sending", "Sending...") toView:self.view];
    __weak MBProgressHUD *weakHud = hud;
    [[EMHttpManager sharedInstance] asyncCreateMessageWithTenantId:[EMIMHelper defaultHelper].tenantId
                                                         projectId:[EMIMHelper defaultHelper].projectId
                                                        parameters:parameters
                                                        completion:^(id responseObject, NSError *error) {
                                                            if (error == nil) {
                                                                [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavesucceed", "Send succeed")];
                                                                [weakHud hide:YES afterDelay:0.5];
                                                                [weakSelf back];
                                                            } else {
                                                                [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavefailed", "Send failed")];
                                                                [weakHud hide:YES afterDelay:0.5];
                                                            }
                                                        }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
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
            cell.textLabel.text = NSLocalizedString(@"leaveMessage.name", @"Name");
            tempLabel.text = _name;
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"leaveMessage.phone", @"Phone");
            tempLabel.text = _phone;
        }
            break;
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"leaveMessage.mail", @"Mail");
            tempLabel.text = _mail;
        }
            break;
        case 3:
        {
            cell.textLabel.text = NSLocalizedString(@"leaveMessage.content", @"Content");
            tempLabel.text = _content;
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
            EditViewController *editController = [[EditViewController alloc] initWithType:@"name" content:_name];
            editController.title = NSLocalizedString(@"leaveMessage.name", @"Name");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 1:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"phone" content:_phone];
            editController.title = NSLocalizedString(@"leaveMessage.phone", @"Phone");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 2:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"mail" content:_mail];
            editController.title = NSLocalizedString(@"leaveMessage.mail", @"Mail");
            [self.navigationController pushViewController:editController animated:YES];
        }
            break;
        case 3:
        {
            EditViewController *editController = [[EditViewController alloc] initWithType:@"content" content:_content];
            editController.title = NSLocalizedString(@"leaveMessage.content", @"Content");
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
        
        if ([type isEqualToString:@"name"]) {
            _name = content;
        } else if ([type isEqualToString:@"phone"]){
            _phone = content;
        } else if ([type isEqualToString:@"mail"]) {
            _mail = content;
        } else if ([type isEqualToString:@"content"]) {
            _content = content;
        }
        [self.tableView reloadData];
    }
}


@end
