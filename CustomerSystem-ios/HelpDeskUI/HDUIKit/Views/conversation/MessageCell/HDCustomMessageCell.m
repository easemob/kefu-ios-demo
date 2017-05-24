/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "HDCustomMessageCell.h"
#import "HDBubbleView+Gif.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "HDIMessageModel.h"

@interface HDCustomMessageCell ()

@end

@implementation HDCustomMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

#pragma mark - HDIModelCell

- (BOOL)isCustomBubbleView:(id<HDIMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<HDIMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<HDIMessageModel>)model
{
    [_bubbleView setupGifBubbleView];
    
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<HDIMessageModel>)model
{
    [_bubbleView updateGifMargin:bubbleMargin];
}

+ (NSString *)cellIdentifierWithModel:(id<HDIMessageModel>)model
{
    return model.isSender?@"EaseMessageCellSendGif":@"EaseMessageCellRecvGif";
}

+ (CGFloat)cellHeightWithModel:(id<HDIMessageModel>)model
{
    return 100;
}

@end
