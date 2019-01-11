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

#import "HDMessageTimeCell.h"

CGFloat const HDMessageTimeCellPadding = 5;

@interface HDMessageTimeCell()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation HDMessageTimeCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDMessageTimeCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor grayColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setupSubview];
    }
    
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubview
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = _titleLabelColor;
    _titleLabel.font = _titleLabelFont;
    [self.contentView addSubview:_titleLabel];
    
    [self _setupTitleLabelConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupTitleLabelConstraints
{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(HDMessageTimeCellPadding);
        make.left.equalTo(self.contentView.mas_left).offset(HDMessageTimeCellPadding);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-HDMessageTimeCellPadding);
        make.right.equalTo(self.contentView.mas_right).offset(-HDMessageTimeCellPadding);
    }];
}

#pragma mark - setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

#pragma mark - public

+ (NSString *)cellIdentifier
{
    return @"MessageTimeCell";
}

@end
