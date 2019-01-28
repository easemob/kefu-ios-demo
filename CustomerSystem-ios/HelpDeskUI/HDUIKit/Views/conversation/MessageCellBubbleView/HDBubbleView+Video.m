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


#import "HDBubbleView+Video.h"

@implementation HDBubbleView (Video)

#pragma mark - private

- (void)_setupVideoBubbleConstraints
{
    [self.fileIconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.height.equalTo(self.fileIconView.mas_width).offset(0);
    }];
    
    [self.fileNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.left.equalTo(self.fileIconView.mas_right).offset(HDMessageCellPadding);
    }];
    
    [self.fileSizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileNameLabel.mas_left).offset(0);
        make.right.equalTo(self.fileNameLabel.mas_right).offset(0);
        make.top.equalTo(self.fileNameLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
    }];
}

#pragma mark - public

- (void)setupVideoBubbleView
{
    self.fileIconView = [[UIImageView alloc] init];
    self.fileIconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileIconView.backgroundColor = [UIColor clearColor];
    self.fileIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundImageView addSubview:self.fileIconView];
    
    self.fileNameLabel = [[UILabel alloc] init];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileNameLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.fileNameLabel];
    
    self.fileSizeLabel = [[UILabel alloc] init];
    self.fileSizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileSizeLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.fileSizeLabel];
    
    [self _setupVideoBubbleConstraints];
}

- (void)updateVideoMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupVideoBubbleConstraints];
}

@end
