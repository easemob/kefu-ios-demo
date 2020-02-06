//
//  EaseBubbleView+Track.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/5.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Track.h"

@implementation HDBubbleView (Track)

- (void)_setupTrackBubbleConstraints  {
    
    [self.trackTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.height.equalTo(15);
    }];
    
    [self.trackBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(5);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-10.0);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-5);
    }];
    
    [self.cusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackBgView.mas_top).offset(5);
        make.left.equalTo(self.trackBgView.mas_left).offset(self.margin.left);
        make.bottom.equalTo(self.sendButton.mas_top).offset(-self.margin.bottom);
        make.width.equalTo(self.cusImageView.mas_height).offset(0);
    }];
    
    [self.cusDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trackBgView.mas_top).offset(10);
        make.left.equalTo(self.cusImageView.mas_right).offset(self.margin.left);
        make.right.equalTo(self.trackBgView.mas_right).offset(-self.margin.right);
    }];
    
    [self.cusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sendButton.mas_top).offset(-10);
        make.left.equalTo(self.cusDescLabel.mas_left).offset(0);
        make.right.equalTo(self.cusDescLabel.mas_right).offset(0);
    }];
    
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trackBgView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.trackBgView.mas_right).offset(-self.margin.left);
        make.bottom.equalTo(self.trackBgView.mas_bottom).offset(-self.margin.bottom);
        make.height.equalTo(30);
    }];
}

- (void)setupTrackBubbleView {
    
    self.trackBgView = [[UIView alloc] init];

    self.trackBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.trackBgView.backgroundColor = [UIColor whiteColor];
    [self.backgroundImageView addSubview:self.trackBgView];
    
    self.trackTitleLabel = [[UILabel alloc] init];
    self.trackTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trackTitleLabel.backgroundColor = [UIColor clearColor];
    self.trackTitleLabel.font = [UIFont systemFontOfSize:13];
    self.trackTitleLabel.textColor = UIColor.blackColor;
    [self.trackBgView addSubview:self.trackTitleLabel];
    
    self.cusImageView = [[UIImageView alloc] init];
    self.cusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusImageView.backgroundColor = [UIColor clearColor];
    self.cusImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.trackBgView addSubview:self.cusImageView];
    
    self.cusDescLabel = [[UILabel alloc] init];
    self.cusDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusDescLabel.backgroundColor = [UIColor clearColor];
    self.cusDescLabel.font = [UIFont systemFontOfSize:13];
    self.cusDescLabel.textColor = UIColor.blackColor;
    self.cusDescLabel.numberOfLines = 2;
    [self.trackBgView addSubview:self.cusDescLabel];
    
    self.cusPriceLabel = [[UILabel alloc] init];
    self.cusPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cusPriceLabel.backgroundColor = [UIColor clearColor];
    self.cusPriceLabel.font = [UIFont systemFontOfSize:15];
    self.cusPriceLabel.textColor = [UIColor redColor];
    [self.trackBgView addSubview:self.cusPriceLabel];
    
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sendButton.backgroundColor = RGBACOLOR(209, 224, 224, 1);
    self.sendButton.layer.cornerRadius = 10;
    [self.sendButton addTarget:self action:@selector(sendDeleteTrackMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [self.backgroundImageView addSubview:self.sendButton];
    
    
    [self _setupTrackBubbleConstraints];
}

- (void)updateTrackMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;

    [self _setupTrackBubbleConstraints];
}



@end
