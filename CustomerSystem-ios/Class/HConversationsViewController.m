//
//  HConversationsViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HConversationsViewController.h"
#import "HConversationTableViewCell.h"
#import "HDChatViewController.h"

@interface HConversationsViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *dataSource;

@property (nonatomic, strong) SRRefreshView *slimeView;
@end

@implementation HConversationsViewController
{
    BOOL _isLoading;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self refreshData];
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:conversation.conversationId];
    [self.navigationController pushViewController:chat animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 删除会话
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        NSArray *datas = self.dataSource;
        HConversation *conv = [datas objectAtIndex:indexPath.row];
        BOOL delete = [[HChatClient sharedClient].chatManager deleteConversation:conv.conversationId deleteMessages:NO];
        if (delete) {
            [self refreshData];
        }
    }
}

#pragma mark - refreshData

- (void)refreshData {
    NSArray *hConversations = [[HChatClient sharedClient].chatManager loadAllConversations];
    long badgeValue = 0;
    for (HConversation *conv in hConversations) {
        badgeValue += conv.unreadMessagesCount;
    }
    NSString *badge = nil;
    if (badgeValue == 0) {
        badge = nil;
    } else {
        badge = [NSString stringWithFormat:@"%ld",badgeValue];
        if (badgeValue > 99) {
            badge = @"99+";
        }
    }
    self.tabBarItem.badgeValue = badge;
    self.dataSource = hConversations;
    [self.tableView reloadData];
}


#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshData];
    if ([_slimeView loading]) {
        [_slimeView endRefresh];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - UI
- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - dealloc

- (void)dealloc {
    _slimeView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
