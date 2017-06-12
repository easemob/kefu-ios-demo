//
//  HConversationTableViewCell.m
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HConversationTableViewCell.h"
#define kHeadImageViewLeft 10.f
#define kHeadImageViewTop 10.f
#define kHeadImageViewWidth 40.f
#define kTimeWidth 120.f
#define kMargin 10.f

@interface HConversationTableViewCell ()
@property (strong, nonatomic) DXTipView *tipView;
@end

@implementation HConversationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, kHeadImageViewWidth, kHeadImageViewWidth)];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = kHeadImageViewWidth/2;
    [self.contentView addSubview:_headerImageView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - kTimeWidth-kMargin, kMargin, kTimeWidth, 16)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = RGBACOLOR(0x99, 0x99, 0x99, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + kMargin, kMargin, self.frame.size.width - CGRectGetMaxX(_headerImageView.frame) - kMargin*2 - kTimeWidth, 16)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor = RGBACOLOR(0x1a, 0x1a, 0x1a, 1);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+5, self.frame.size.width - CGRectGetMaxX(_headerImageView.frame) - kMargin, 12)];
    _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = RGBACOLOR(0x99, 0x99, 0x99, 1);
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_contentLabel];
    
    _tipView = [[DXTipView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) - 15, 5, 30, 20)];
    _tipView.tipNumber = nil;
    [self.contentView addSubview:_tipView];
    [self.contentView bringSubviewToFront:_tipView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _timeLabel.frame = CGRectMake(self.frame.size.width - kTimeWidth - kMargin, kMargin, CGRectGetWidth(_timeLabel.frame), CGRectGetHeight(_timeLabel.frame));
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, kMargin, self.frame.size.width - CGRectGetMaxX(_headerImageView.frame) - 2*kMargin - kTimeWidth, 19);
}

- (void)setModel:(HConversation *)model {
    NSInteger count = model.unreadMessagesCount;
    
    if (count == 0) {
        _tipView.tipNumber = nil;
    }
    else{
        NSString *string = @"";
        if (count > 99) {
            string = [NSString stringWithFormat:@"%i+", 99];
        }
        else{
            string = [NSString stringWithFormat:@"%ld", (long)count];
        }
        _tipView.tipNumber = string;
    }
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.item.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_customer_avatar"]];
    NSString *name = model.conversationId;
    if (model.conversationType == HConversationTypeSYSTEM) {
        name = model.item.officialName;
    }
    _titleLabel.text = name;
    NSString *timeDes = @"";
    if (model.latestMessage.body != nil) {
        timeDes = [self stringFromTimeInterval:model.latestMessage.localTime];
    }
    _timeLabel.text =timeDes;
    
    EMMessageBodyType bodyType = model.latestMessage.body.type;
    NSString *content = @"";
    switch (bodyType) {
        case EMMessageBodyTypeText:
        {
            EMTextMessageBody *body = (EMTextMessageBody*)model.latestMessage.body;
            content = body.text;
            break;
        }
        case EMMessageBodyTypeImage: {
            content = @"[图片]";
            break;
        }
        case EMMessageBodyTypeVoice:{
            content = @"[语音]";
            break;
        }
        case EMMessageBodyTypeFile:{
            content = @"[文件]";
            break;
        }
        case EMMessageBodyTypeLocation:{
            content = @"[位置]";
            break;
        }
        default:
            break;
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[HDEmotionEscape sharedInstance] attStringFromTextForChatting:content textFont:_contentLabel.font]];
    _contentLabel.attributedText = attributedString;
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
