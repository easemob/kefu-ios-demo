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


#import "HDBubbleView+Image.h"

@implementation HDBubbleView (Image)

#pragma mark - private

- (void)_setupImageBubbleConstraints
{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(5);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
    }];
}

#pragma mark - public

- (void)setupImageBubbleView
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.imageView];
    
    [self _setupImageBubbleConstraints];
}

- (void)updateImageMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupImageBubbleConstraints];
}

@end
