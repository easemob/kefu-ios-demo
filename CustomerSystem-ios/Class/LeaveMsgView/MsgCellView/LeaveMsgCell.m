//
//  LeaveMsgCell.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgCell.h"

#import "UIImageView+EMWebCache.h"

@interface LeaveMsgCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation LeaveMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 7, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
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
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
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
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
