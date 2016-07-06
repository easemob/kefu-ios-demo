//
//  LeaveMsgDetailHeaderView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgDetailHeaderView.h"

#import "LeaveMsgDetailModel.h"

@interface LeaveMsgDetailHeaderView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LeaveMsgDetailModel *msgDetailModel;

@end

@implementation LeaveMsgDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)setDetail:(NSDictionary*)dictionary
{
    _msgDetailModel = [[LeaveMsgDetailModel alloc] initWithDictionary:dictionary];
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"DetailListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, tableView.frame.size.width - 120, CGRectGetHeight(self.frame)/8)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.tag = 99;
        contentLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:contentLabel];
    }
    
    UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:99];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"NO.%@",_msgDetailModel.comment.ticketId];
        tempLabel.text = @"";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.theme", @"theme:");
        tempLabel.text = _msgDetailModel.comment.subject;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.nickname", @"nickname:");
        tempLabel.text = _msgDetailModel.comment.creator.username;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.content", @"content:");
        tempLabel.text = _msgDetailModel.comment.content;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.phone", @"phone:");
        tempLabel.text = _msgDetailModel.comment.creator.phone;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.qq", @"QQ:");
        tempLabel.text = _msgDetailModel.comment.creator.qq;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.weibo", @"Weibo:");
//        tempLabel.text = _msgDetailModel.ticketId;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.mail", @"Mail:");
        tempLabel.text = _msgDetailModel.comment.creator.email;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.frame)/8;
}

@end
