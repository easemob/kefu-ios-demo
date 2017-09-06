//
//  HConversationTableViewCell.m
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HConversationTableViewCell.h"
#import "HDArticleDataControl.h"
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
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+5, self.frame.size.width - CGRectGetMaxX(_headerImageView.frame) - CGRectGetWidth(_titleLabel.frame), 12)];
    _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = RGBACOLOR(0x99, 0x99, 0x99, 1);
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:_contentLabel];
    
    _tipView = [[DXTipView alloc] initWithFrame:CGRectMake(kScreenWidth-kMargin-30, CGRectGetMaxY(_timeLabel.frame)+5, 20, 20)];
    _tipView.tipNumber = nil;
    [self.contentView addSubview:_tipView];
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
    if (model.conversationType == HConversationTypeCUSTOM) {
        name = model.item.officialName;
    }
    _titleLabel.text = name;
    NSString *timeDes = @"";
    if (model.latestMessage.body != nil) {
        timeDes = [self stringFromTimeInterval:model.latestMessage.messageTime];
    }
    _timeLabel.text =timeDes;
    
    EMMessageBodyType bodyType = model.latestMessage.body.type;
    NSString *content = @"";
    switch (bodyType) {
        case EMMessageBodyTypeText:
        {
            EMTextMessageBody *body = (EMTextMessageBody*)model.latestMessage.body;
            content = body.text;
            if ([HjudgeTextMessageSubType isMenuMessage:model.latestMessage]) {
                content = NSLocalizedString(@"robot_menu", @"[Robot Menu]");
            }else if ([HjudgeTextMessageSubType isOrderMessage:model.latestMessage]) {
                content = NSLocalizedString(@"order_menu", @"[Order Menu]");
            }else if ([HjudgeTextMessageSubType isTrackMessage:model.latestMessage]) {
                content = NSLocalizedString(@"track_message", @"[Track Message]");
            }else if ([HjudgeTextMessageSubType isEvaluateMessage:model.latestMessage]) {
                content = NSLocalizedString(@"evaluation_of_invitation", @"[Evaluation Invitation]");
            }else if ([HDArticleDataControl isArticleMessage:model.latestMessage]) {
                content = NSLocalizedString(@"graphic_message", @"[Graphic Message]");
            }else if ([HjudgeTextMessageSubType isFormMessage:model.latestMessage]) {
                content = NSLocalizedString(@"form_message", @"[Form Message]");
            }else{
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[HDEmotionEscape sharedInstance] attStringFromTextForChatting:content textFont:_contentLabel.font]];
                _contentLabel.attributedText = attributedString;
                return;
            }
            break;
        }
        case EMMessageBodyTypeImage: {
            content = NSLocalizedString(@"cov_picture", @"[Picture]");
            break;
        }
        case EMMessageBodyTypeVoice:{
            content = NSLocalizedString(@"cov_voice", @"[Vioce]");
            break;
        }
        case EMMessageBodyTypeFile:{
            content = NSLocalizedString(@"cov_file", @"[File]");
            break;
        }
        case EMMessageBodyTypeLocation:{
            content = NSLocalizedString(@"cov_location", @"[Location]");
            break;
        }
        default:
            break;
    }
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:content];
    _contentLabel.attributedText = attStr;
    
}



- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat =@"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(long long)timeInterval/1000];
    NSString *timeStr = [matter stringFromDate:date];
    return timeStr;
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
