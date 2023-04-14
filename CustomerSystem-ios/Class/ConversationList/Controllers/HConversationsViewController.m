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

@interface HConversationsViewController ()
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
    self.showRefreshHeader = YES;
    [self.view addSubview:self.tableView];
    [self refreshData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
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
        NSArray *datas = self.dataArray;
        HDConversation *conv = [datas objectAtIndex:indexPath.row];
        BOOL delete = [[HDClient sharedClient].chatManager deleteConversation:conv.conversationId deleteMessages:NO];
        if (delete) {
            [self tableViewDidTriggerHeaderRefresh];
        }
    }
}

#pragma mark - refreshData

- (void)refreshData {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)tableViewDidTriggerHeaderRefresh {
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    
//    for (HDConversation *mo in hConversations) {
//
//
//        NSLog(@"======%@",mo.latestMessage.ext);
//
//    }
    long badgeValue = 0;
    for (HDConversation *conv in hConversations) {
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
    self.dataArray = [hConversations mutableCopy];
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
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
