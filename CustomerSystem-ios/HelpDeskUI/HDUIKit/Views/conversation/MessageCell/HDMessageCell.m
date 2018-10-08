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

#import "HDMessageCell.h"
#import "HDBubbleView+Text.h"
#import "HDBubbleView+Image.h"
#import "HDBubbleView+Track.h"
#import "HDBubbleView+Order.h"
#import "HDBubbleView+RobotMenu.h"
#import "HDBubbleView+Transform.h"
#import "HDBubbleView+Evaluate.h"
#import "HDBubbleView+Location.h"
#import "HDBubbleView+Voice.h"
#import "HDBubbleView+Video.h"
#import "HDBubbleView+File.h"
#import "HDBubbleView+Form.h"
#import "HDBubbleView+Article.h"
#import "HDBubbleView+Gif.h"
#import "UIImageView+WebCache.h"
#import "HDEmotionEscape.h"
#import "HDLocalDefine.h"
#import "NSString+HDValid.h"

#define kImageWidth 40
#define kImageHeight 70
#define kTitleHeight 20

CGFloat const HDMessageCellPadding = 10;

NSString *const HDMessageCellIdentifierRecvText = @"HDMessageCellRecvText";
NSString *const HDMessageCellIdentifierRecvTrack = @"HDMessageCellRecvTrack";
NSString *const HDMessageCellIdentifierRecvOrder = @"HDMessageCellRecvOrder";
NSString *const HDMessageCellIdentifierRecvMenu = @"HDMessageCellRecvMenu";
NSString *const HDMessageCellIdentifierRecvArticle = @"HDMessageCellRecvArticle";
NSString *const HDMessageCellIdentifierRecvTransform = @"HDMessageCellRecvTransform";
NSString *const HDMessageCellIdentifierRecvEvaluate = @"HDMessageCellRecvEvaluate";
NSString *const HDMessageCellIdentifierRecvBigExpression = @"HDMessageCellRecvBigExpression";
NSString *const HDMessageCellIdentifierRecvLocation = @"HDMessageCellRecvLocation";
NSString *const HDMessageCellIdentifierRecvVoice = @"HDMessageCellRecvVoice";
NSString *const HDMessageCellIdentifierRecvVideo = @"HDMessageCellRecvVideo";
NSString *const HDMessageCellIdentifierRecvImage = @"HDMessageCellRecvImage";
NSString *const HDMessageCellIdentifierRecvFile = @"HDMessageCellRecvFile";
NSString *const HDMessageCellIdentifierRecvForm = @"HDMessageCelRecvForm";

NSString *const HDMessageCellIdentifierSendText = @"HDMessageCellSendText";
NSString *const HDMessageCellIdentifierSendTrack = @"HDMessageCellSendTrack";
NSString *const HDMessageCellIdentifierSendBigExpression = @"HDMessageCellSendBigExpression";
NSString *const HDMessageCellIdentifierSendOrder = @"HDMessageCellSendOrder";
NSString *const HDMessageCellIdentifierSendLocation = @"HDMessageCellSendLocation";
NSString *const HDMessageCellIdentifierSendVoice = @"HDMessageCellSendVoice";
NSString *const HDMessageCellIdentifierSendVideo = @"HDMessageCellSendVideo";
NSString *const HDMessageCellIdentifierSendImage = @"HDMessageCellSendImage";
NSString *const HDMessageCellIdentifierSendFile = @"HDMessageCellSendFile";


@interface HDMessageCell() <SendDeleteTrackMsgDelegate>
{
    EMMessageBodyType _messageType;
}

@property (nonatomic) NSLayoutConstraint *statusWidthConstraint;
@property (nonatomic) NSLayoutConstraint *activtiyWidthConstraint;
@property (nonatomic) NSLayoutConstraint *hasReadWidthConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleMaxWidthConstraint;

@end

@implementation HDMessageCell
{
    NSDataDetector *_detector;
    NSArray *_urlMatches;
}

@synthesize statusButton = _statusButton;
@synthesize bubbleView = _bubbleView;
@synthesize hasRead = _hasRead;
@synthesize activity = _activity;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDMessageCell *cell = [self appearance];
    cell.statusSize = 20;
    cell.activitySize = 20;
    cell.bubbleMaxWidth = 200.0;
    cell.leftBubbleMargin = UIEdgeInsetsMake(8, 15, 8, 10);
    cell.rightBubbleMargin = UIEdgeInsetsMake(8, 10, 8, 15);
    cell.bubbleMargin = UIEdgeInsetsMake(8, 0, 8, 0);
    
    cell.messageTextFont = [UIFont systemFontOfSize:15];
    cell.messageTextColor = [UIColor blackColor];
    
    cell.messageLocationFont = [UIFont systemFontOfSize:10];
    cell.messageLocationColor = [UIColor whiteColor];
    
    cell.messageVoiceDurationColor = [UIColor grayColor];
    cell.messageVoiceDurationFont = [UIFont systemFontOfSize:12];
    
    cell.messageFileNameColor = [UIColor blackColor];
    cell.messageFileNameFont = [UIFont systemFontOfSize:13];
    cell.messageFileSizeColor = [UIColor grayColor];
    cell.messageFileSizeFont = [UIFont systemFontOfSize:11];
    cell.messageFormDescSizeFont = [UIFont systemFontOfSize:11];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<HDIMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _messageType = model.bodyType;
        [self _setupSubviewsWithType:_messageType
                            isSender:model.isSender
                               model:model];
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - setup subviews

- (void)_setupSubviewsWithType:(EMMessageBodyType)messageType
                      isSender:(BOOL)isSender
                         model:(id<HDIMessageModel>)model
{
    _statusButton = [[UIButton alloc] init];
    _statusButton.translatesAutoresizingMaskIntoConstraints = NO;
    _statusButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_statusButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/messageSendFail"] forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.hidden = YES;
    [self.contentView addSubview:_statusButton];
    
    UIEdgeInsets edge = isSender?_rightBubbleMargin:_leftBubbleMargin;
    if ([HDMessageHelper getMessageExtType:model.message] == HDExtArticleMsg) {
        edge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    _bubbleView = [[HDBubbleView alloc] initWithMargin:edge isSender:model.isSender];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    _bubbleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bubbleView];
    if ([HDMessageHelper getMessageExtType:model.message] != HDExtArticleMsg) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarView.backgroundColor = [UIColor yellowColor];
        _avatarView.clipsToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatarView];
    } else {
        self.bubbleMaxWidth = kScreenWidth;
    }
    
    
    _hasRead = [[UILabel alloc] init];
    _hasRead.translatesAutoresizingMaskIntoConstraints = NO;
    _hasRead.text = NSEaseLocalizedString(@"hasRead", @"Read");
    _hasRead.textAlignment = NSTextAlignmentCenter;
    _hasRead.font = [UIFont systemFontOfSize:12];
    _hasRead.hidden = YES;
    [_hasRead sizeToFit];
    [self.contentView addSubview:_hasRead];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.translatesAutoresizingMaskIntoConstraints = NO;
    _activity.backgroundColor = [UIColor clearColor];
    _activity.hidden = YES;
    [self.contentView addSubview:_activity];
    
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:model]) {
        [self setCustomBubbleView:model];
    } else {
        switch (messageType) {
            case EMMessageBodyTypeText: {
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                switch (extMsgType) {
                    case HDExtTrackMsg:
                        [_bubbleView setupTrackBubbleView];
                        _bubbleView.delegate = self;
                        break;
                    case HDExtOrderMsg:
                        [_bubbleView setupOrderBubbleView];
                        break;
                    case HDExtRobotMenuMsg:
                        if (model.isSender) {
                            [_bubbleView setupTextBubbleView];
                            _bubbleView.textLabel.font = _messageTextFont;
                            _bubbleView.textLabel.textColor = _messageTextColor;
                        } else {
                            [_bubbleView setupRobotMenuBubbleView];
                        }
                        break;
                    case HDExtArticleMsg:
                        [_bubbleView setupArticleuBubbleView];
                        break;
                    case HDExtFormMsg:
                        [_bubbleView setupFormBubbleView];
                        _bubbleView.formTitleLabel.textColor = _messageFileNameColor;
                        _bubbleView.formDescLabel.font = _messageFileSizeFont;
                        break;
                    case HDExtToCustomServiceMsg:
                        [_bubbleView setupTransformBubbleView];
                        break;
                    case HDExtEvaluationMsg:
                        [_bubbleView setupEvaluateBubbleView];
                        break;
                    case HDExtBigExpressionMsg:  {
                        [_bubbleView setupGifBubbleView];
                        break;
                    }
                    default:
                        [_bubbleView setupTextBubbleView];
                        _bubbleView.textLabel.font = _messageTextFont;
                        _bubbleView.textLabel.textColor = _messageTextColor;
                        break;
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                [_bubbleView setupImageBubbleView];
                
                _bubbleView.imageView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/imageDownloadFail"];
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                [_bubbleView setupLocationBubbleView];
                
                _bubbleView.locationImageView.image = [[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_location_preview"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
                _bubbleView.locationLabel.font = _messageLocationFont;
                _bubbleView.locationLabel.textColor = _messageLocationColor;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                [_bubbleView setupVoiceBubbleView];
                
                _bubbleView.voiceDurationLabel.textColor = _messageVoiceDurationColor;
                _bubbleView.voiceDurationLabel.font = _messageVoiceDurationFont;
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                [_bubbleView setupVideoBubbleView];
                
                _bubbleView.videoTagView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/messageVideo"];
            }
                break;
            case EMMessageBodyTypeFile:
            {
                [_bubbleView setupFileBubbleView];
                
                _bubbleView.fileNameLabel.font = _messageFileNameFont;
                _bubbleView.fileNameLabel.textColor = _messageFileNameColor;
                _bubbleView.fileSizeLabel.font = _messageFileSizeFont;
            }
                break;
            default:
                break;
        }
    }
    
    [self _setupConstraints];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
    tapRecognizer.delegate = self;
    [_bubbleView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapAction:)];
    [_avatarView addGestureRecognizer:tapRecognizer2];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class])isEqualToString:@"UITableViewCellContentView" ]) {
        return NO;
    }
    
    if (_model.bodyType == EMMessageBodyTypeText) {
        if (touch.view.tag == 1991) {
            return YES; // tag in Cell+Form.h
        }
        
        return NO;
    }
    
    return YES;
}
// 删除轨迹消息
- (void)deleteTrackMessage:(UIButton *)sendButton
{
    if ([self.deleteTrackMsgdelegate respondsToSelector:@selector(transmitDelegateTrackMessage:sendButton:)]) {
        [self.deleteTrackMsgdelegate transmitDelegateTrackMessage:_model sendButton:sendButton];
    }
    
}

#pragma mark - Setup Constraints

- (void)_setupConstraints
{
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-HDMessageCellPadding]];
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bubbleMaxWidth];
    [self addConstraint:self.bubbleMaxWidthConstraint];
    //    self.bubbleMaxWidthConstraint.active = YES;
    
    //status button
    self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.statusSize];
    [self addConstraint:self.statusWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    //activtiy
    self.activtiyWidthConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.activitySize];
    [self addConstraint:self.activtiyWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.activity attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self _updateHasReadWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.activity attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
}

#pragma mark - Update Constraint

- (void)_updateHasReadWidthConstraint
{
    if (_hasRead) {
        [self removeConstraint:self.hasReadWidthConstraint];
        
        self.hasReadWidthConstraint = [NSLayoutConstraint constraintWithItem:_hasRead attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
        [self addConstraint:self.hasReadWidthConstraint];
    }
}

- (void)_updateStatusButtonWidthConstraint
{
    if (_statusButton) {
        [self removeConstraint:self.statusWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.statusSize];
        [self addConstraint:self.statusWidthConstraint];
    }
}

- (void)_updateActivityWidthConstraint
{
    if (_activity) {
        [self removeConstraint:self.activtiyWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.activitySize];
        [self addConstraint:self.activtiyWidthConstraint];
    }
}

- (void)_updateBubbleMaxWidthConstraint
{
    [self removeConstraint:self.bubbleMaxWidthConstraint];
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bubbleMaxWidth];
    [self addConstraint:self.bubbleMaxWidthConstraint];
}

#pragma mark - setter

- (void)setModel:(id<HDIMessageModel>)model
{
    _model = model;
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:model]) {
        [self setCustomModel:model];
    } else {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
            {
                _detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                switch (extMsgType) {
                    case HDExtOrderMsg:
                    {
                        NSDictionary * itemDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"order"];
                        NSString *url = [itemDic objectForKey:@"img_url"];
                        [_bubbleView.orderImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
                        _bubbleView.orderTitleLabel.text = [itemDic objectForKey:@"title"];
                        _bubbleView.orderNoLabel.text = [itemDic objectForKey:@"order_title"];
                        _bubbleView.orderDescLabel.text = [itemDic objectForKey:@"desc"];
                        _bubbleView.orderPriceLabel.text = [itemDic objectForKey:@"price"];
                        
                        
                    }
                        break;
                    case HDExtTrackMsg:
                    {
                        NSDictionary * itemDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"track"];
                        NSString *imageName = [model.message.ext objectForKey:@"imageName"];
                        if ([imageName length] > 0) {
                            _bubbleView.cusImageView.image = [UIImage imageNamed:imageName];
                        } else {
                            _bubbleView.cusImageView.image = [UIImage imageNamed:@"imageDownloadFail.png"];
                        }
                        NSString *url = [itemDic objectForKey:@"img_url"];
                        [_bubbleView.cusImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
                        _bubbleView.trackTitleLabel.text = [itemDic objectForKey:@"title"];
                        _bubbleView.cusDescLabel.text = [itemDic objectForKey:@"desc"];
                        _bubbleView.cusPriceLabel.text = [itemDic objectForKey:@"price"];
                    }
                        break;
                    case HDExtRobotMenuMsg:
                    {
                        if (self.model.isSender) {
                            NSString *content = model.text;
                            _urlMatches = [_detector matchesInString:content options:0 range:NSMakeRange(0, content.length)];
                            _bubbleView.textLabel.attributedText = [self highlightLinksWithIndex:0 attributedString:[[HDEmotionEscape sharedInstance] attStringFromTextForChatting:content textFont:self.messageTextFont]];
                        } else {
                            NSDictionary *choiceDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"choice"];
                            NSArray *menus = [NSArray array];
                            NSMutableArray *array = [NSMutableArray array];
                            menus = [choiceDic objectForKey:@"list"];
                            for (NSString *string in menus) {
                                [array addObject:string];
                            }
                            //机器人菜单更新
                            if ([choiceDic.allKeys containsObject:@"items"]) {
                                [array removeAllObjects];
                                menus = [choiceDic objectForKey:@"items"];
                                for (NSDictionary *itemDic in menus) {
                                    HDMenuItem *item = [HDMenuItem new];
                                    item.menuId = [itemDic valueForKey:@"id"];
                                    item.name = [itemDic valueForKey:@"name"];
                                    [array addObject:item];
                                }
                            }
                            _bubbleView.options = array;
                            _bubbleView.menuTitle = [choiceDic objectForKey:@"title"];
                            [_bubbleView reloadData];
                        }
                    }
                        break;
                    case HDExtArticleMsg:
                    {
                        NSArray *articles = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"articles"];
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *articleDic in articles) {
                            HDSubItem *item = [[HDSubItem alloc] initWithDictionary:articleDic];
                            [arr addObject:item];
                        }
                        _bubbleView.subModels = arr.copy;
                        [_bubbleView reloadArticleData];
                    }
                        break;
                    case HDExtEvaluationMsg:
                    {
                        _bubbleView.evaluateTitle.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"satisfaction.message", @"please evaluate my service")];
                    }
                        break;
                    case HDExtToCustomServiceMsg: {
                        _bubbleView.transTitle.attributedText = [[HDEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:self.messageTextFont];
                        BOOL hasTransfer = [model.message.ext[kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer] boolValue];
                        [_bubbleView setTransformButtonBackgroundColorWithEnable:!hasTransfer];
                    }
                        break;
                    case HDExtFormMsg:
                    {
                        NSDictionary *msgTypeDic = [model.message.ext objectForKey:@"msgtype"];
                        _bubbleView.formIconView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_item_form"];
                        @try {
                            _bubbleView.formDescLabel.text = [[msgTypeDic objectForKey:@"html"] objectForKey:@"desc"];
                            _bubbleView.formTitleLabel.text = [[msgTypeDic objectForKey:@"html"] objectForKey:@"topic"];
                        } @catch (NSException *ignored) {}
                    }
                        break;
                    case HDExtBigExpressionMsg: {
                        NSDictionary *msgTypeDic = [model.message.ext objectForKey:@"msgtype"];
                        NSDictionary *emojiDic = nil;
                        NSString *emojiUrl = nil;
                        if (msgTypeDic) {
                            emojiDic = [msgTypeDic objectForKey:@"customMagicEmoji"];
                        }
                        if (emojiDic) {
                            emojiUrl = [emojiDic objectForKey:@"url"];
                        }
                        [_bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:emojiUrl] placeholderImage:[UIImage imageNamed:_model.failImageName]];
                        break;
                    }
                    default:
                    {
                        NSString *content = model.text;
                        _urlMatches = [_detector matchesInString:content options:0 range:NSMakeRange(0, content.length)];
                        _bubbleView.textLabel.attributedText = [self highlightLinksWithIndex:0 attributedString:[[HDEmotionEscape sharedInstance] attStringFromTextForChatting:content textFont:self.messageTextFont]];
                    }
                        break;
                }
                
            }
                break;
            case EMMessageBodyTypeImage:
            {
                UIImage *image = _model.thumbnailImage;
                if (!image) {
                    image = _model.image;
                    if (!image) {
                        [_bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.fileURLPath] placeholderImage:[UIImage imageNamed:_model.failImageName]];
                    } else {
                        _bubbleView.imageView.image = image;
                    }
                } else {
                    _bubbleView.imageView.image = image;
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                _bubbleView.locationLabel.text = _model.address;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                if (_bubbleView.voiceImageView) {
                    if ([self.sendMessageVoiceAnimationImages count] > 0 && [self.recvMessageVoiceAnimationImages count] > 0) {
                        self.bubbleView.voiceImageView.image = self.model.isSender ?[self.sendMessageVoiceAnimationImages objectAtIndex:0] : [self.recvMessageVoiceAnimationImages objectAtIndex:0];
                        _bubbleView.voiceImageView.animationImages = self.model.isSender ? self.sendMessageVoiceAnimationImages:self.recvMessageVoiceAnimationImages;
                    } else {
                        self.bubbleView.voiceImageView.image = self.model.isSender ?[UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_sender_audio_playing_full"]: [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_receiver_audio_playing_full"];
                    }
                }
                if (!self.model.isSender) {
                    if([self.model.message isListened]){
                        _bubbleView.isReadView.hidden = YES;
                    }else{
                        _bubbleView.isReadView.hidden = NO;
                    }
                }
                
                if (_model.isMediaPlaying) {
                    [_bubbleView.voiceImageView startAnimating];
                }
                else{
                    [_bubbleView.voiceImageView stopAnimating];
                }
                
                _bubbleView.voiceDurationLabel.text = [NSString stringWithFormat:@"%d''",(int)_model.mediaDuration];
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                UIImage *image = _model.isSender ? _model.image : _model.thumbnailImage;
                if (!image) {
                    image = _model.image;
                    if (!image) {
                        [_bubbleView.videoImageView sd_setImageWithURL:[NSURL URLWithString:_model.fileURLPath] placeholderImage:[UIImage imageNamed:_model.failImageName]];
                    } else {
                        _bubbleView.videoImageView.image = image;
                    }
                } else {
                    _bubbleView.videoImageView.image = image;
                }
            }
                break;
            case EMMessageBodyTypeFile:
            {
                _bubbleView.fileIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"HelpDeskUIResource.bundle/%@",_model.fileIconName]];
                _bubbleView.fileNameLabel.text = _model.fileName;
                _bubbleView.fileSizeLabel.text = _model.fileSizeDes;
            }
                break;
            default:
                break;
        }
    }
}

- (NSMutableAttributedString *)highlightLinksWithIndex:(CFIndex)index attributedString:(NSAttributedString *)attributedString1{
    NSMutableAttributedString *attributedString = [attributedString1 mutableCopy] ;
    for (NSTextCheckingResult *match in _urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink ) {
            
            NSRange matchRange = [match range];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(242)/255.0 green:(83)/255.0 blue:(131)/255.0 alpha:(1)] range:matchRange];
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    return attributedString;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range
{
    return index >= range.location && index <= range.location+range.length;
}


- (void)setStatusSize:(CGFloat)statusSize
{
    _statusSize = statusSize;
    [self _updateStatusButtonWidthConstraint];
}

- (void)setActivitySize:(CGFloat)activitySize
{
    _activitySize = activitySize;
    [self _updateActivityWidthConstraint];
}

- (void)setSendBubbleBackgroundImage:(UIImage *)sendBubbleBackgroundImage
{
    _sendBubbleBackgroundImage = sendBubbleBackgroundImage;
}

- (void)setRecvBubbleBackgroundImage:(UIImage *)recvBubbleBackgroundImage
{
    _recvBubbleBackgroundImage = recvBubbleBackgroundImage;
}

- (void)setBubbleMaxWidth:(CGFloat)bubbleMaxWidth
{
    _bubbleMaxWidth = bubbleMaxWidth;
    [self _updateBubbleMaxWidthConstraint];
}

- (void)setRightBubbleMargin:(UIEdgeInsets)rightBubbleMargin
{
    _rightBubbleMargin = rightBubbleMargin;
}

- (void)setLeftBubbleMargin:(UIEdgeInsets)leftBubbleMargin
{
    _leftBubbleMargin = leftBubbleMargin;
}

- (void)setBubbleMargin:(UIEdgeInsets)bubbleMargin
{
    _bubbleMargin = bubbleMargin;
    _bubbleMargin = self.model.isSender ? _rightBubbleMargin:_leftBubbleMargin;
    if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:_model]) {
        [self updateCustomBubbleViewMargin:_bubbleMargin model:_model];
    } else {
        if (_bubbleView) {
            switch (_messageType) {
                case EMMessageBodyTypeText: {
                    HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:_model.message];
                    switch (extMsgType) {
                        case HDExtOrderMsg:
                            [_bubbleView updateOrderMargin:_bubbleMargin];
                            break;
                        case HDExtTrackMsg:
                            [_bubbleView updateTrackMargin:_bubbleMargin];
                            break;
                        case HDExtRobotMenuMsg:
                            if (_model.isSender) {
                                [_bubbleView updateTextMargin:_bubbleMargin];
                            } else {
                                [_bubbleView updateRobotMenuMargin:_bubbleMargin];
                                [_bubbleView reloadData];
                            }
                            break;
                        case HDExtArticleMsg:
                            [_bubbleView updateArticleMargin:UIEdgeInsetsMake(0, 0, 0, 0)];
                            break;
                        case HDExtFormMsg:
                            [_bubbleView updateFormMargin:_bubbleMargin];
                            break;
                        case HDExtToCustomServiceMsg:
                            [_bubbleView updateTransformMargin:_bubbleMargin];
                            break;
                        case HDExtEvaluationMsg:
                            [_bubbleView updateEvaluateMargin:_bubbleMargin];
                            break;
                        case HDExtBigExpressionMsg:
                            [_bubbleView updateGifMargin:_bubbleMargin];
                            break;
                        default:
                            [_bubbleView updateTextMargin:_bubbleMargin];
                            break;
                    }
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    [_bubbleView updateImageMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    [_bubbleView updateLocationMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    [_bubbleView updateVoiceMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    [_bubbleView updateVideoMargin:_bubbleMargin];
                }
                    break;
                case EMMessageBodyTypeFile:
                {
                    [_bubbleView updateFileMargin:_bubbleMargin];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
}

- (void)setMessageTextFont:(UIFont *)messageTextFont
{
    _messageTextFont = messageTextFont;
    if (_bubbleView.textLabel) {
        _bubbleView.textLabel.font = messageTextFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    _messageTextColor = messageTextColor;
    if (_bubbleView.textLabel) {
        _bubbleView.textLabel.textColor = _messageTextColor;
    }
}

- (void)setMessageLocationColor:(UIColor *)messageLocationColor
{
    _messageLocationColor = messageLocationColor;
    if (_bubbleView.locationLabel) {
        _bubbleView.locationLabel.textColor = _messageLocationColor;
    }
}

- (void)setMessageLocationFont:(UIFont *)messageLocationFont
{
    _messageLocationFont = messageLocationFont;
    if (_bubbleView.locationLabel) {
        _bubbleView.locationLabel.font = _messageLocationFont;
    }
}

- (void)setSendMessageVoiceAnimationImages:(NSArray *)sendMessageVoiceAnimationImages
{
    _sendMessageVoiceAnimationImages = sendMessageVoiceAnimationImages;
}

- (void)setRecvMessageVoiceAnimationImages:(NSArray *)recvMessageVoiceAnimationImages
{
    _recvMessageVoiceAnimationImages = recvMessageVoiceAnimationImages;
}

- (void)setMessageVoiceDurationColor:(UIColor *)messageVoiceDurationColor
{
    _messageVoiceDurationColor = messageVoiceDurationColor;
    if (_bubbleView.voiceDurationLabel) {
        _bubbleView.voiceDurationLabel.textColor = _messageVoiceDurationColor;
    }
}

- (void)setMessageVoiceDurationFont:(UIFont *)messageVoiceDurationFont
{
    _messageVoiceDurationFont = messageVoiceDurationFont;
    if (_bubbleView.voiceDurationLabel) {
        _bubbleView.voiceDurationLabel.font = _messageVoiceDurationFont;
    }
}

- (void)setMessageFileNameFont:(UIFont *)messageFileNameFont
{
    _messageFileNameFont = messageFileNameFont;
    if (_bubbleView.fileNameLabel) {
        _bubbleView.fileNameLabel.font = _messageFileNameFont;
    }
}

- (void)setMessageFileNameColor:(UIColor *)messageFileNameColor
{
    _messageFileNameColor = messageFileNameColor;
    if (_bubbleView.fileNameLabel) {
        _bubbleView.fileNameLabel.textColor = _messageFileNameColor;
    }
}

- (void)setMessageFileSizeFont:(UIFont *)messageFileSizeFont
{
    _messageFileSizeFont = messageFileSizeFont;
    if (_bubbleView.fileSizeLabel) {
        _bubbleView.fileSizeLabel.font = _messageFileSizeFont;
    }
}

- (void)setMessageFileSizeColor:(UIColor *)messageFileSizeColor
{
    _messageFileSizeColor = messageFileSizeColor;
    if (_bubbleView.fileSizeLabel) {
        _bubbleView.fileSizeLabel.textColor = _messageFileSizeColor;
    }
}

-(void)setMessageFormDescSizeFont:(UIFont *)messageFormDescSizeFont
{
    _messageFormDescSizeFont = messageFormDescSizeFont;
    if (_bubbleView.formDescLabel) {
        _bubbleView.formDescLabel.font = _messageFormDescSizeFont;
    }
}


#pragma mark - action

- (void)bubbleViewTapAction:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!_delegate) {
            return;
        }
        
        if ([self respondsToSelector:@selector(isCustomBubbleView:)] && [self isCustomBubbleView:_model]) {
            if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                [_delegate messageCellSelected:_model];
                return;
            }
        }
        switch (_model.bodyType) {
            case EMMessageBodyTypeText: {
                if ([HDMessageHelper getMessageExtType:_model.message] == HDExtFormMsg) {
                    if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                        [_delegate messageCellSelected:_model];
                    }
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            case EMMessageBodyTypeFile:
            {
                if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
                    [_delegate messageCellSelected:_model];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)avatarViewTapAction:(UITapGestureRecognizer *)tapRecognizer
{
    if ([_delegate respondsToSelector:@selector(avatarViewSelcted:)]) {
        [_delegate avatarViewSelcted:_model];
    }
}

- (void)statusAction
{
    if ([_delegate respondsToSelector:@selector(statusButtonSelcted:withMessageCell:)]) {
        [_delegate statusButtonSelcted:_model withMessageCell:self];
    }
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:HRouterEventTapTransform] || [eventName isEqualToString:HRouterEventTapEvaluate]) {
        userInfo = @{@"HDMessage":_model.message};
    }
    if ([eventName isEqualToString:HRouterEventTextURLTapEventName]) {
        CFIndex charIndex = [[userInfo objectForKey:@"charIndex"] longValue];
        for (NSTextCheckingResult *match in _urlMatches) {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSRange matchRange = [match range];
                if ([self isIndex:charIndex inRange:matchRange]) {
                    [self.nextResponder routerEventWithName:HRouterEventTextURLTapEventName userInfo:@{@"HDMessage":_model.message, @"url":match.URL}];
                    break;
                }
            }
        }
    } else {
        [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
    }
    
}

#pragma mark - public

+ (NSString *)cellIdentifierWithModel:(id<HDIMessageModel>)model
{
    NSString *cellIdentifier = nil;
    if (model.isSender) {
        switch (model.bodyType) {
            case EMMessageBodyTypeText: {
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                switch (extMsgType) {
                    case HDExtOrderMsg:
                        cellIdentifier = HDMessageCellIdentifierSendOrder;
                        break;
                    case HDExtTrackMsg:
                        cellIdentifier = HDMessageCellIdentifierSendTrack;
                        break;
                    case HDExtBigExpressionMsg:
                        cellIdentifier = HDMessageCellIdentifierSendBigExpression;
                        break;
                    default:
                        cellIdentifier = HDMessageCellIdentifierSendText;
                        break;
                }
            }
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = HDMessageCellIdentifierSendImage;
                break;
            case EMMessageBodyTypeVideo:
                cellIdentifier = HDMessageCellIdentifierSendVideo;
                break;
            case EMMessageBodyTypeLocation:
                cellIdentifier = HDMessageCellIdentifierSendLocation;
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = HDMessageCellIdentifierSendVoice;
                break;
            case EMMessageBodyTypeFile:
                cellIdentifier = HDMessageCellIdentifierSendFile;
                break;
            default:
                break;
        }
    }
    else{
        switch (model.bodyType) {
            case EMMessageBodyTypeText: {
                HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
                switch (extMsgType) {
                    case HDExtOrderMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvOrder;
                        break;
                    case HDExtTrackMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvTrack;
                        break;
                    case HDExtRobotMenuMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvMenu;
                        break;
                    case HDExtArticleMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvArticle;
                        break;
                    case HDExtFormMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvForm;
                        break;
                    case HDExtToCustomServiceMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvTransform;
                        break;
                    case HDExtEvaluationMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvEvaluate;
                        break;
                    case HDExtBigExpressionMsg:
                        cellIdentifier = HDMessageCellIdentifierRecvBigExpression;
                        break;
                    default:
                        cellIdentifier = HDMessageCellIdentifierRecvText;
                        break;
                }
            }
                break;
            case EMMessageBodyTypeImage:
                cellIdentifier = HDMessageCellIdentifierRecvImage;
                break;
            case EMMessageBodyTypeVideo:
                cellIdentifier = HDMessageCellIdentifierRecvVideo;
                break;
            case EMMessageBodyTypeLocation:
                cellIdentifier = HDMessageCellIdentifierRecvLocation;
                break;
            case EMMessageBodyTypeVoice:
                cellIdentifier = HDMessageCellIdentifierRecvVoice;
                break;
            case EMMessageBodyTypeFile:
                cellIdentifier = HDMessageCellIdentifierRecvFile;
                break;
            default:
                break;
        }
    }
    
    return cellIdentifier;
}

+ (CGFloat)cellHeightWithModel:(id<HDIMessageModel>)model
{
    if (model.cellHeight > 0) {
        return model.cellHeight;
    }
    
    HDMessageCell *cell = [self appearance];
    CGFloat bubbleMaxWidth = cell.bubbleMaxWidth;
    bubbleMaxWidth -= (cell.leftBubbleMargin.left + cell.leftBubbleMargin.right + cell.rightBubbleMargin.left + cell.rightBubbleMargin.right)/2;
    CGFloat height = HDMessageCellPadding + cell.bubbleMargin.top + cell.bubbleMargin.bottom;
    
    switch (model.bodyType) {
        case EMMessageBodyTypeText: {
            CGFloat tableWidth = 200-cell.bubbleMargin.left-cell.bubbleMargin.right;
            HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
            switch (extMsgType) {
                case HDExtRobotMenuMsg:{
                    NSDictionary *choiceDic = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"choice"];
                    NSArray *menu = [choiceDic objectForKey:@"list"];
                    NSString *menuTitle = [choiceDic objectForKey:@"title"];
                    if ([choiceDic objectForKey:@"items"]) {
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *dic in [choiceDic objectForKey:@"items"]) {
                            [arr addObject:[dic valueForKey:@"name"]];
                        }
                        menu = arr.copy;
                    }
                    int leftPadding = 15, rightPadding = 10;
                    int topMargin = 8;
                    int bottomMargin = 8;
                    int allPadding = leftPadding + rightPadding;
                    int rowPaddingTopAndBottom = 5;
                    // 修改订单，轨迹类消息宽度
                    height += [menuTitle boundingRectWithSize:CGSizeMake(tableWidth - allPadding , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
                    for (NSString *string in menu) {
                        height += [string boundingRectWithSize:CGSizeMake(tableWidth - allPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height + rowPaddingTopAndBottom;
                    }
                    height += (topMargin + bottomMargin);
                    return height;
                }
                case HDExtArticleMsg:{
                    NSArray *articles = [[model.message.ext objectForKey:@"msgtype"] objectForKey:@"articles"];
                    return [self getArticleCellHeight:articles];
                }
                case HDExtTrackMsg:
                    // 修改轨迹消息的高度
                    return 2*HDMessageCellPadding + kImageHeight + kTitleHeight + 60;
                case HDExtOrderMsg:
                    return 2*HDMessageCellPadding + kImageHeight + 2*kTitleHeight + 20;
                case HDExtFormMsg:
                    return kImageHeight;
                case HDExtBigExpressionMsg:
                    return kBigExpressionHW;
                case HDExtToCustomServiceMsg:
                {
                    NSAttributedString *text = [[HDEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:cell.messageTextFont];
                    CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 25, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil];
                    height += (rect.size.height > 20 ? rect.size.height : 20) + 21;
                    height += 50;
                    return height;
                }
                case HDExtEvaluationMsg:
                {
                    NSAttributedString *text = [[NSAttributedString alloc] initWithString: NSLocalizedString(@"satisfaction.message", @"please evaluate my service")];
                    CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth - 25, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil];
                    height += (rect.size.height > 20 ? rect.size.height : 20) + 21;
                    height += 50;
                    return height;
                }
                default:
                {
                    NSAttributedString *text = [[HDEmotionEscape sharedInstance] attStringFromTextForChatting:model.text textFont:cell.messageTextFont];
                    CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil];
                    height += (rect.size.height > 20 ? rect.size.height : 20) + 20;
                    return height;
                }
            }
            
        }
            break;
        case EMMessageBodyTypeImage:
        case EMMessageBodyTypeVideo:
        {
            CGSize retSize = model.thumbnailImageSize;
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
            
            height += retSize.height;
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            height += kEMMessageLocationHeight;
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            height += kEMMessageVoiceHeight;
        }
            break;
        case EMMessageBodyTypeFile:
        {
            NSString *text = model.fileName;
            UIFont *font = cell.messageFileNameFont;
            CGRect nameRect;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                nameRect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            } else {
                nameRect.size = [text sizeWithFont:font constrainedToSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            }
            height += (nameRect.size.height > 20 ? nameRect.size.height : 20);
            
            text = model.fileSizeDes;
            font = cell.messageFileSizeFont;
            CGRect sizeRect;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                sizeRect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            } else {
                sizeRect.size = [text sizeWithFont:font constrainedToSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            }
            height += (sizeRect.size.height > 15 ? sizeRect.size.height : 15);
        }
            break;
        default:
            break;
    }
    
    height += HDMessageCellPadding;
    model.cellHeight = height;
    
    return height;
}

+ (CGFloat)getArticleCellHeight:(NSArray *)subs {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *articleDic in subs) {
        HDSubItem *item = [[HDSubItem alloc] initWithDictionary:articleDic];
        [arr addObject:item];
    }
    if (arr.count == 1) {
        HDSubItem *item = [arr firstObject];
        CGSize size = CGSizeMake(kScreenWidth-2*kLeftMargin - 2*kLeftMargin, MAXFLOAT);
        CGFloat titleH = kTitleFontSize;
        CGFloat timeH = kTimeFontSize;
        CGFloat imageH = kTitleImageHeight;
        CGFloat digistH = [NSString rectOfString:item.digest fontSize:kDigistFontSize size:size].size.height;
        CGFloat h = titleH+timeH+imageH+digistH+6*kMarginNormal+44+kMarginNormal;
        return h;
    } else {
        return kTitleImageHeight+(arr.count-1)*70+kTopMargin;
    }
}

+ (NSString*)_getMessageContent:(HDMessage*)message
{
    NSString *content = @"";
    NSDictionary *choice = [[message.ext objectForKey:@"msgtype"] objectForKey:@"choice"];
    NSArray *items = [choice objectForKey:@"items"];
    NSArray *menu = [choice objectForKey:@"list"];
    content = [choice objectForKey:@"title"];
    if (menu) {
        for (NSString *string in menu) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
        }
    }
    if (items) {
        for (NSDictionary *item  in items) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@"\n%@",[item valueForKey:@"name"]]];
        }
    }
    return content;
}

@end
