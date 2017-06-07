//
//  LeaveMessageCell.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/4.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "LeaveMessageCell.h"
#import "LeaveMsgDetailModel.h"
#define SubjectFont [UIFont systemFontOfSize:18]
#define DetailsFont [UIFont systemFontOfSize:14]
#define TimeFont [UIFont systemFontOfSize:15]
@interface LeaveMessageCell ()
// 主题
@property (nonatomic, weak) UILabel *subjectLabel;
// 内容
@property (nonatomic, weak) UILabel *detailsLabel;
// 时间
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation LeaveMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *subjectLabel = [[UILabel alloc] init];
        subjectLabel.font = SubjectFont;
        subjectLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:subjectLabel];
        self.subjectLabel = subjectLabel;
        
        UILabel *detailsLabel = [[UILabel alloc] init];
        detailsLabel.font = DetailsFont;
        detailsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:detailsLabel];
        self.detailsLabel = detailsLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = TimeFont;
        timeLabel.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
//        self.backgroundColor = [UIColor re];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.subjectLabel.frame = CGRectMake(10, 0, kScreenWidth/2, self.frame.size.height/2);
    self.detailsLabel.frame = CGRectMake(10, CGRectGetMaxY(self.subjectLabel.frame) + 5, kScreenWidth/2, self.frame.size.height/2 - 10);
    self.timeLabel.frame = CGRectMake(kScreenWidth/2 + 10, (self.frame.size.height - self.frame.size.height/3)/2, kScreenWidth/2 - 20, self.frame.size.height/3);
    
}

- (void)setLeaveMessageModel:(LeaveMsgCommentModel *)leaveMessageModel
{
    _leaveMessageModel = leaveMessageModel;
    self.subjectLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"ticket_theme", @"Theme"),leaveMessageModel.subject];
    
    if (leaveMessageModel.attachments) {
        self.detailsLabel.text = [NSString stringWithFormat:@"%@:%@-[%@]",NSLocalizedString(@"leaveMessage.content", @"Content"),leaveMessageModel.content,NSLocalizedString(@"leaveMessage.leavemsg.attachment", @"Attachment")];
    } else {
        self.detailsLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"leaveMessage.content", @"Content"),leaveMessageModel.content];
    }
    self.timeLabel.text = [self dateformatWithTimeStr:leaveMessageModel.created_at];
}


- (NSString *)dateformatWithTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeStr=[dateFormatter stringFromDate:date];
    return timeStr;
}

@end
