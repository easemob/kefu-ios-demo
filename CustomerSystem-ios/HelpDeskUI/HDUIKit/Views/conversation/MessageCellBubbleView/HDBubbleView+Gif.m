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

#import "HDBubbleView+Gif.h"

@implementation HDBubbleView (Gif)


#pragma mark - private

- (void)_setupGifBubbleConstraints
{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(self.margin.left);
        make.bottom.equalTo(self.mas_bottom).offset(-self.margin.bottom);
        make.right.equalTo(self.mas_right).offset(-self.margin.right);
    }];
}

#pragma mark - public

- (void)setupGifBubbleView
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundImageView addSubview:self.imageView];
    
    [self _setupGifBubbleConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kBigExpressionHW);
    }];
}

- (void)updateGifMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupGifBubbleConstraints];
}

@end
