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


#import "HDBubbleView+Location.h"

@implementation HDBubbleView (Location)

#pragma mark - private

- (void)_setupLocationBubbleConstraints
{
    [self.locationImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
    }];
    
    [self.locationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationImageView.mas_bottom).offset(0);
        make.left.equalTo(self.locationImageView.mas_left).offset(0);
        make.right.equalTo(self.locationImageView.mas_right).offset(0);
        make.height.equalTo(self.locationImageView.mas_height).offset(0).multipliedBy(0.3);
    }];
}

#pragma mark - public

- (void)setupLocationBubbleView
{
    self.locationImageView = [[UIImageView alloc] init];
    self.locationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationImageView.backgroundColor = [UIColor clearColor];
    self.locationImageView.clipsToBounds = YES;
    [self.backgroundImageView addSubview:self.locationImageView];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationLabel.numberOfLines = 2;
    self.locationLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    [self.locationImageView addSubview:self.locationLabel];
    
    [self _setupLocationBubbleConstraints];
}

- (void)updateLocationMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupLocationBubbleConstraints];
}

@end
