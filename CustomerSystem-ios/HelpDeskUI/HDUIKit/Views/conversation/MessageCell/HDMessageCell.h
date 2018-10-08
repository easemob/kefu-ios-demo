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

#import <UIKit/UIKit.h>
#import "HDIModelChatCell.h"
#import "HDIMessageModel.h"

#import "HDBubbleView.h"

#define kEMMessageImageSizeWidth 120
#define kEMMessageImageSizeHeight 120
#define kEMMessageLocationHeight 95
#define kEMMessageVoiceHeight 23

extern CGFloat const HDMessageCellPadding;

typedef enum{
    HDMessageCellEvenVideoBubbleTap,
    HDMessageCellEventLocationBubbleTap,
    HDMessageCellEventImageBubbleTap,
    HDMessageCellEventAudioBubbleTap,
    HDMessageCellEventFileBubbleTap,
    HDMessageCellEventCustomBubbleTap,
}HDMessageCellTapEventType;


@protocol TransmitDeleteTrackMsgDelegate <NSObject>

- (void)transmitDelegateTrackMessage:(id<HDIMessageModel>)model sendButton:(UIButton *)sendButton;

@end

@protocol HDMessageCellDelegate;
@interface HDMessageCell : UITableViewCell<HDIModelChatCell>
{
    UIButton *_statusButton;
    UILabel *_hasRead;
    HDBubbleView *_bubbleView;
    UIActivityIndicatorView *_activity;

    
    NSLayoutConstraint *_statusWidthConstraint;
}

@property (weak, nonatomic) id<HDMessageCellDelegate> delegate;

@property (weak, nonatomic) id<TransmitDeleteTrackMsgDelegate> deleteTrackMsgdelegate;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (strong, nonatomic) UIImageView *avatarView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) UILabel *hasRead;

@property (strong, nonatomic) HDBubbleView *bubbleView;

@property (strong, nonatomic) id<HDIMessageModel> model;

@property (nonatomic) CGFloat statusSize UI_APPEARANCE_SELECTOR; //default 20;

@property (nonatomic) CGFloat activitySize UI_APPEARANCE_SELECTOR; //default 20;

@property (nonatomic) CGFloat bubbleMaxWidth UI_APPEARANCE_SELECTOR; //default 200;

@property (nonatomic) UIEdgeInsets bubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 0, 8, 0);

@property (nonatomic) UIEdgeInsets leftBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 15, 8, 10);

@property (nonatomic) UIEdgeInsets rightBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 10, 8, 15);

@property (strong, nonatomic) UIImage *sendBubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIImage *recvBubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *messageTextFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:15];

@property (nonatomic) UIColor *messageTextColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageLocationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIColor *messageLocationColor UI_APPEARANCE_SELECTOR; //default [UIColor whiteColor];

@property (nonatomic) NSArray *sendMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSArray *recvMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *messageVoiceDurationColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

@property (nonatomic) UIFont *messageVoiceDurationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIFont *messageFileNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:13];

@property (nonatomic) UIColor *messageFileNameColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageFileSizeFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:11];

@property (nonatomic) UIColor *messageFileSizeColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

@property (nonatomic) UIFont *messageFormDescSizeFont UI_APPEARANCE_SELECTOR; // default [UIFont systemFontOfSize11];

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<HDIMessageModel>)model;

+ (NSString *)cellIdentifierWithModel:(id<HDIMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<HDIMessageModel>)model;

+ (NSString*)_getMessageContent:(HDMessage*)message;

@end

@protocol HDMessageCellDelegate <NSObject>

@optional

- (void)messageCellSelected:(id<HDIMessageModel>)model;

- (void)statusButtonSelcted:(id<HDIMessageModel>)model withMessageCell:(HDMessageCell*)messageCell;

- (void)avatarViewSelcted:(id<HDIMessageModel>)model;

@end

