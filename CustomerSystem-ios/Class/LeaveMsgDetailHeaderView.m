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
    CGRect frame = self.frame;
    frame.size.height = [self heightTest];
    self.frame = frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
        contentLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:contentLabel];
    }
    
    UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:99];
    CGRect frame = tempLabel.frame;
    frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    tempLabel.frame = frame;
    tempLabel.textAlignment = NSTextAlignmentRight;
    tempLabel.numberOfLines = frame.size.height/15;
   if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.mail", @"Mail:");
        tempLabel.text = _msgDetailModel.comment.creator.email;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.theme", @"theme:");
        tempLabel.text = _msgDetailModel.comment.subject;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.content", @"content:");
        
        NSString *name = [_msgDetailModel.comment.content stringByReplacingOccurrencesOfString:@"联系人姓名"withString:@"Contact Name"];
        NSString *phone = [name stringByReplacingOccurrencesOfString:@"联系人电话"withString:@"Contact Phone"];
        NSString *mail = [phone stringByReplacingOccurrencesOfString:@"联系人邮箱"withString:@"Contact Email"];
        
        NSString *nameStr = [mail stringByReplacingOccurrencesOfString:@"Contact Name" withString:NSLocalizedString(@"contact_name", @"Contact_Name")];
        NSString *phoneStr = [nameStr stringByReplacingOccurrencesOfString:@"Contact Phone" withString:NSLocalizedString(@"contact_phone", @"Contact_Phone")];
        NSString *mailStr = [phoneStr stringByReplacingOccurrencesOfString:@"Contact Email" withString:NSLocalizedString(@"contact_email", @"Contact_Email")];
        
        tempLabel.text = mailStr;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.time", @"Time:");
        tempLabel.text = [self dateformatWithTimeStr:_msgDetailModel.comment.created_at];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)dateformatWithTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeStr=[dateFormatter stringFromDate:date];
    return timeStr;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = CGRectZero;
    NSString *text;
    if (_msgDetailModel) {
       if (indexPath.row == 0) {
            text = _msgDetailModel.comment.creator.email;
        } else if (indexPath.row == 1) {
            text = _msgDetailModel.comment.subject;
        } else if (indexPath.row == 2) {
            text = _msgDetailModel.comment.content;
        } else if (indexPath.row == 3) {
            text = _msgDetailModel.comment.created_at;
        }
        
        rect = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 120, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                  context:nil];
    }
    
    if (rect.size.height < 160/4) {
        return 160/4;
    }
    
    return rect.size.height;
}

- (CGFloat)heightTest
{
    CGFloat height=0;
    [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 0; i < 4; i ++) {
        height += [self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return height;
}

#pragma mark - public

- (LeaveMsgDetailModel*)getMsgDetailModel
{
    return _msgDetailModel;
}

@end
