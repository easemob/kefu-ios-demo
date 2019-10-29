/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "HDBaseMessageCell.h"
#import "UIImageView+HDWebCache.h"
#import "HDBubbleView+Transform.h"
#import "HDBubbleView+Evaluate.h"

@interface HDBaseMessageCell()
@property (strong, nonatomic) UILabel *nameLabel;
@end

@implementation HDBaseMessageCell

@synthesize nameLabel = _nameLabel;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDBaseMessageCell *cell = [self appearance];
    cell.avatarSize = 30;
    cell.avatarCornerRadius = 0;
    
    cell.messageNameColor = [UIColor grayColor];
    cell.messageNameFont = [UIFont systemFontOfSize:10];
    cell.messageNameHeight = 15;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        cell.messageNameIsHidden = NO;
    }
    
//    cell.bubbleMargin = UIEdgeInsetsMake(8, 15, 8, 10);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<HDIMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if ([HDMessageHelper getMessageExtType:model.message] != HDExtArticleMsg) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _nameLabel.backgroundColor = [UIColor clearColor];
            _nameLabel.font = _messageNameFont;
            _nameLabel.textColor = _messageNameColor;
            [self.contentView addSubview:_nameLabel];
        }
        
        [self configureLayoutConstraintsWithModel:model];
        self.messageNameHeight = 15;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bubbleView.backgroundImageView.image = self.model.isSender ? self.sendBubbleBackgroundImage : self.recvBubbleBackgroundImage;
    switch ([HDMessageHelper getMessageExtType:self.model.message]) {
        case HDExtArticleMsg: {
            _bubbleView.backgroundImageView.image = nil;
            _bubbleView.backgroundImageView.layer.borderWidth = 0.5;
            _bubbleView.backgroundImageView.layer.masksToBounds = YES;
            _bubbleView.backgroundImageView.layer.cornerRadius = 5;
            _bubbleView.backgroundImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            break;
        }
        case HDExtBigExpressionMsg: {
            _bubbleView.backgroundImageView.image = nil;
            break;
        }
            
        default:
            break;
    }
    switch (self.model.bodyType) {
        case EMMessageBodyTypeText: {
            HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:self.model.message];
            switch (extMsgType) {
                case HDExtToCustomServiceMsg:
                case HDExtEvaluationMsg:
                case HDExtRobotMenuMsg:
                case HDExtOrderMsg:
                case HDExtTrackMsg:
                {
                    
                }
    
                    break;
                default:break;
            }
            
        }
            break;
        case EMMessageBodyTypeImage:
        {
            CGSize retSize = self.model.thumbnailImageSize;
            if (retSize.width == 0 || retSize.height == 0) {
                retSize.width = kEMMessageImageSizeWidth;
                retSize.height = kEMMessageImageSizeHeight;
            }
            else if (retSize.width > retSize.height) {
                CGFloat height =  kEMMessageImageSizeWidth / retSize.width * retSize.height;
                retSize.height = height;
                retSize.width = kEMMessageImageSizeWidth;
            }
            else {
                CGFloat width = kEMMessageImageSizeHeight / retSize.height * retSize.width;
                retSize.width = width;
                retSize.height = kEMMessageImageSizeHeight;
            }
            
            CGFloat margin = [HDMessageCell appearance].leftBubbleMargin.left + [HDMessageCell appearance].leftBubbleMargin.right;
            
            [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(retSize.width + margin);
            }];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
        }
            break;
        case EMMessageBodyTypeVoice:
        {
        }
            break;
        case EMMessageBodyTypeVideo:
        {
        }
            break;
        case EMMessageBodyTypeFile:
        {
        }
            break;
        default:
            break;
    }
}

- (void)configureLayoutConstraintsWithModel:(id<HDIMessageModel>)model
{
    if ([HDMessageHelper getMessageExtType:model.message] == HDExtArticleMsg) {
        [self configArticleConstraints];
    } else {
        if (model.isSender) {
            [self configureSendLayoutConstraints];
        } else {
            [self configureRecvLayoutConstraints];
        }
    }
}

- (void)configArticleConstraints {
    //bubble view
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(HDMessageCellPadding);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(HDMessageCellPadding);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
        make.width.equalTo(kScreenWidth - 20);
    }];
}

- (void)configureSendLayoutConstraints
{
    [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(HDMessageCellPadding);
        make.right.equalTo(self.contentView.mas_right).offset(-HDMessageCellPadding);
        make.width.equalTo(self.avatarSize);
        make.height.equalTo(self.avatarView.mas_width);
    }];

    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.right.equalTo(self.avatarView.mas_left).offset(-HDMessageCellPadding);
        make.height.equalTo(self.messageNameHeight);
    }];
    
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarView.mas_left).offset(-HDMessageCellPadding);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
    }];
    
    [self.statusButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubbleView.mas_left).offset(-HDMessageCellPadding);
    }];
    
    [self.activity mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubbleView.mas_left).offset(-HDMessageCellPadding);
    }];
    
    [self.hasRead mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubbleView.mas_left).offset(-HDMessageCellPadding);
    }];
}

- (void)configureRecvLayoutConstraints
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(HDMessageCellPadding);
        make.left.equalTo(self.contentView.mas_left).offset(HDMessageCellPadding);
        make.width.equalTo(self.avatarSize);
        make.height.equalTo(self.avatarView.mas_width);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.avatarView.mas_right).offset(HDMessageCellPadding);
        make.height.equalTo(self.messageNameHeight);
    }];
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(HDMessageCellPadding);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
    }];
}

#pragma mark - Update Constraint

- (void)_updateAvatarViewWidthConstraint
{
    if (self.avatarView) {
        [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.avatarSize);
        }];
    }
}

- (void)_updateNameHeightConstraint
{
    if (_nameLabel) {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.messageNameHeight);
        }];
    }
}

#pragma mark - setter

- (void)setModel:(id<HDIMessageModel>)model
{
    [super setModel:model];
    
    if (model.avatarURLPath) {
        [self.avatarView hdSD_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }

    _nameLabel.text = model.nickname;
    
    if (self.model.isSender) {
        _hasRead.hidden = YES;
        switch (self.model.messageStatus) {
            case HDMessageStatusPending:
            {
                _statusButton.hidden = YES;
                [_activity setHidden:NO];
                [_activity startAnimating];
            }
                break;
            case HDMessageStatusDelivering:
            {
                _statusButton.hidden = YES;
                [_activity setHidden:NO];
                [_activity startAnimating];
            }
                break;
            case HDMessageStatusSuccessed:
            {
                _statusButton.hidden = YES;
                [_activity stopAnimating];
                if (self.model.isMessageRead) {
                    _hasRead.hidden = NO;
                }
            }
                break;
            
            case HDMessageStatusFailed:
            {
                [_activity stopAnimating];
                [_activity setHidden:YES];
                _statusButton.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setMessageNameFont:(UIFont *)messageNameFont
{
    _messageNameFont = messageNameFont;
    if (_nameLabel) {
        _nameLabel.font = _messageNameFont;
    }
}

- (void)setMessageNameColor:(UIColor *)messageNameColor
{
    _messageNameColor = messageNameColor;
    if (_nameLabel) {
        _nameLabel.textColor = _messageNameColor;
    }
}

- (void)setMessageNameHeight:(CGFloat)messageNameHeight
{
    _messageNameHeight = messageNameHeight;
    if (_nameLabel) {
        [self _updateNameHeightConstraint];
    }
}

- (void)setAvatarSize:(CGFloat)avatarSize
{
    _avatarSize = avatarSize;
    if (self.avatarView) {
        [self _updateAvatarViewWidthConstraint];
    }
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius
{
    _avatarCornerRadius = avatarCornerRadius;
    if (self.avatarView){
        self.avatarView.layer.cornerRadius = avatarCornerRadius;
    }
}

- (void)setMessageNameIsHidden:(BOOL)messageNameIsHidden
{
    _messageNameIsHidden = messageNameIsHidden;
    if (_nameLabel) {
        _nameLabel.hidden = messageNameIsHidden;
    }
}

#pragma mark - public

+ (CGFloat)cellHeightWithModel:(id<HDIMessageModel>)model
{
    HDBaseMessageCell *cell = [self appearance];
    
    CGFloat minHeight = cell.avatarSize + HDMessageCellPadding * 2;
    CGFloat height = cell.messageNameHeight;
    if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
        height = 15;
    }
    height += - HDMessageCellPadding + [HDMessageCell cellHeightWithModel:model];
    height = height > minHeight ? height : minHeight;
    
    return height;
}

@end
