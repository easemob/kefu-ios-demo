//
//  LeaveMsgCell.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgCell.h"

#import "LeaveMsgAttatchmentView.h"
#import "LeaveMsgDetailModel.h"
#import "HDMessageReadManager.h"

#define kDefaultLeft 65.f

@interface LeaveMsgCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
    UIView *_lineView2;
    UIView *_attchmentView;
    
    LeaveMsgCommentModel *_model;
}

@end

@implementation LeaveMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 200, 7, 190, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45, CGRectGetMaxY(_timeLabel.frame) + 5.f, 20, 20)];
        _unreadLabel.backgroundColor = RGBACOLOR(242, 83, 131, 1);
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _attchmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _attchmentView.userInteractionEnabled = YES;
        [self.contentView addSubview:_attchmentView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:_lineView];
        
        _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(65, 0, kScreenWidth - 65, 1)];
        _lineView2.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = RGBACOLOR(242, 83, 131, 1);
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = RGBACOLOR(242, 83, 131, 1);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    self.imageView.frame = CGRectMake(10, 7, 45, 45);
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)/2;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.layer.masksToBounds = YES;
    
    self.textLabel.text = _name;
    self.textLabel.frame = CGRectMake(65, 7, 175, 20);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    CGFloat height = [LeaveMsgCell _heightForContent:_detailMsg];
    if (_model && height > 0) {
        frame = _detailLabel.frame;
        frame.size.height = height + 20;
        _detailLabel.frame = frame;
        _detailLabel.numberOfLines = (height + 20) / 15;
    } else {
        frame = _detailLabel.frame;
        frame.size.height = 20;
        _detailLabel.frame = frame;
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
    
    frame = _lineView2.frame;
    frame.origin.y = 60 + height;
    _lineView2.frame = frame;
    
    frame = _attchmentView.frame;
    frame.origin.y = 60 + height;
    _attchmentView.frame = frame;
}

- (void)setModel:(LeaveMsgCommentModel*)model
{
    self.name = model.creator.name;
    self.placeholderImage = [UIImage imageNamed:@"customer"];
    self.detailMsg = model.content;
    [self _setAttachments:model.attachments];
    if (model.attachments) {
        [self.contentView addSubview:_lineView2];
    } else {
        [_lineView2 removeFromSuperview];
    }
    
    _model = model;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

+(CGFloat)tableView:(UITableView *)tableView model:(LeaveMsgCommentModel*)model
{
    return 60.f + [LeaveMsgCell _heightForModel:model];
}

- (void)_setAttachments:(NSArray *)attachments
{
    _attachments = attachments;
    for (UIView *subView in [_attchmentView subviews]) {
        [subView removeFromSuperview];
    }
    
    if (attachments == nil || [attachments count] == 0) {
        return;
    }
    
    [self.contentView addSubview:_lineView2];
    
    CGFloat left = kDefaultLeft;
    CGFloat height = 40;
    NSInteger index = 0;
    for (LeaveMsgAttachmentModel *attachment in attachments) {
        if (left + [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] >= kScreenWidth) {
            left = kDefaultLeft;
            height += 40;
        }
        LeaveMsgAttatchmentView *attatchmentView = [[LeaveMsgAttatchmentView alloc] initWithFrame:CGRectMake(left, height - 30, [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10], 30)
                                                                                             edit:NO
                                                                                            model:attachment];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAttatchmentAction:)];
        [attatchmentView addGestureRecognizer:tap];
        attatchmentView.tag = index;
        [_attchmentView addSubview:attatchmentView];
        index ++;
        left += [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] + 10;
    }
    
    CGRect frame = _attchmentView.frame;
    frame.size.height = height + 10.f;
    _attchmentView.frame = frame;
}

- (void)tapAttatchmentAction:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    NSInteger index = tap.view.tag;
    if ([_attachments count] > index) {
        LeaveMsgAttachmentModel *attachment = [_attachments objectAtIndex:index];
        if ([attachment.type isEqualToString:@"image"]) {
            [[HDMessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:attachment.url]]];
        } else if([attachment.type isEqualToString:@"audio"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(didSelectAudioAttachment:touchImage:)]) {
                [_delegate didSelectAudioAttachment:attachment touchImage:(LeaveMsgAttatchmentView *)tap.view];
            }
        } else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectFileAttachment:)]) {
                [self.delegate didSelectFileAttachment:attachment];
            }
        }
    }
}


+ (CGFloat)_heightForContent:(NSString*)content
{
    if (content.length == 0) {
        return 0.f;
    }
    
    CGFloat height = 0;
    CGRect rect = [content boundingRectWithSize:CGSizeMake(175.f, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                        context:nil];
    if (rect.size.height > 20) {
        height = rect.size.height - 20;
    } else {
        height = 0.f;
    }
    return height;
}

+ (CGFloat)_heightForModel:(LeaveMsgCommentModel*)model
{
    CGFloat height = 0;
    height += [self _heightForContent:model.content];
    height += [self _heightForAttachments:model.attachments];
    return height;
}

+ (CGFloat)_heightForAttachments:(NSArray*)attachments
{
    if ([attachments count] > 0) {
        CGFloat left = kDefaultLeft;
        CGFloat height = 40;
        for (LeaveMsgAttachmentModel *attachment in attachments) {
            if (left + [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] >= kScreenWidth) {
                left = kDefaultLeft;
                height += 40;
            }
            left += [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] + 10;
        }
        return height + 10.f;
    } else {
        return 0.f;
    }
}

@end
