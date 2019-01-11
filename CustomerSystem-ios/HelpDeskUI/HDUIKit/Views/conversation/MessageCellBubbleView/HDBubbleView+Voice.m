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

#import "HDBubbleView+Voice.h"

#define ISREAD_VIEW_SIZE 10.f

@implementation HDBubbleView (Voice)

#pragma mark - private

- (void)_setupVoiceBubbleConstraints
{
    if (self.isSender) {
        self.isReadView.hidden = YES;
    }
    [self.voiceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
    }];
    
    [self.voiceDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
    }];
    
    if(self.isSender){
        [self.voiceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        }];
        
        [self.voiceDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.voiceImageView.mas_left).offset(-HDMessageCellPadding);
            make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        }];
    }
    else{
        [self.voiceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        }];
        
        [self.voiceDurationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.voiceImageView.mas_right).offset(HDMessageCellPadding);
            make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        }];
        
        [self.isReadView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundImageView.mas_top).offset(0);
            make.left.equalTo(self.backgroundImageView.mas_right).offset(-ISREAD_VIEW_SIZE/2);
            make.bottom.equalTo(self.backgroundImageView.mas_top).offset(ISREAD_VIEW_SIZE);
            make.right.equalTo(self.backgroundImageView.mas_right).offset(ISREAD_VIEW_SIZE/2);
        }];
    }
}

#pragma mark - public

- (void)setupVoiceBubbleView
{
    self.voiceImageView = [[UIImageView alloc] init];
    self.voiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceImageView.backgroundColor = [UIColor clearColor];
    self.voiceImageView.animationDuration = 1;
    [self.backgroundImageView addSubview:self.voiceImageView];
    
    self.voiceDurationLabel = [[UILabel alloc] init];
    self.voiceDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceDurationLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.voiceDurationLabel];
    
    self.isReadView = [[UIImageView alloc] init];
    self.isReadView.translatesAutoresizingMaskIntoConstraints = NO;
    self.isReadView.layer.cornerRadius = ISREAD_VIEW_SIZE/2;
    self.isReadView.clipsToBounds = YES;
    self.isReadView.backgroundColor = [UIColor redColor];
    [self.backgroundImageView addSubview:self.isReadView];
    
    [self _setupVoiceBubbleConstraints];
}

- (void)updateVoiceMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupVoiceBubbleConstraints];
}

@end
