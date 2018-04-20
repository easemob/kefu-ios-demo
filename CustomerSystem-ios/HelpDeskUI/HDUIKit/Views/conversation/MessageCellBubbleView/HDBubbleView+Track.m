//
//  EaseBubbleView+Track.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/5.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Track.h"

@implementation HDBubbleView (Track)

- (void)_setupTrackBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];

    //trackTitle
    NSLayoutConstraint *trackTitleMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.trackTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *trackTitleMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.trackTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *trackTitleMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.trackTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
     [self.marginConstraints addObject:trackTitleMarginTopConstraint];
     [self.marginConstraints addObject:trackTitleMarginLeftConstraint];
     [self.marginConstraints addObject:trackTitleMarginRightConstraint];
    
    // trackBgView.
    NSLayoutConstraint *trackBgViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.trackBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.trackTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
    NSLayoutConstraint *trackBgViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.trackBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
    NSLayoutConstraint *trackBgViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.trackBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    NSLayoutConstraint *trackBgViewBottomhtConstraint = [NSLayoutConstraint constraintWithItem:self.trackBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    [self.marginConstraints addObject:trackBgViewTopConstraint];
    [self.marginConstraints addObject:trackBgViewLeftConstraint];
    [self.marginConstraints addObject:trackBgViewRightConstraint];
    [self.marginConstraints addObject:trackBgViewBottomhtConstraint];
    
    //cusImageView
    NSLayoutConstraint *cusimageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.cusImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *cusimageViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.cusImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *cusimageViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.cusImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sendButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:cusimageViewTopConstraint];
    [self.marginConstraints addObject:cusimageViewLeftConstraint];
    [self.marginConstraints addObject:cusimageViewBottomConstraint];
    
    //desc
    NSLayoutConstraint *cusDescTopConstraint = [NSLayoutConstraint constraintWithItem:self.cusDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.trackTitleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:self.margin.top + 10];
    NSLayoutConstraint *cusDescLeftConstraint = [NSLayoutConstraint constraintWithItem:self.cusDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cusImageView attribute:NSLayoutAttributeRight multiplier:1 constant:self.margin.left];
    NSLayoutConstraint *cusDescRightConstraint = [NSLayoutConstraint constraintWithItem:self.cusDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeRight multiplier:1 constant:-self.margin.right];
    
    [self.marginConstraints addObject:cusDescTopConstraint];
    [self.marginConstraints addObject:cusDescLeftConstraint];
    [self.marginConstraints addObject:cusDescRightConstraint];
    
    
    //price
    NSLayoutConstraint *trackPriceBottomConstraimt = [NSLayoutConstraint constraintWithItem:self.cusPriceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sendButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10];
    [self.marginConstraints addObject:trackPriceBottomConstraimt];
    
    //send
    NSLayoutConstraint *cusSendLeftConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.margin.left];
    NSLayoutConstraint *cusSendRightConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeRight multiplier:1 constant:-self.margin.left];
    NSLayoutConstraint *cusSendBottomConstraint = [NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.trackBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.margin.bottom];
    [self.marginConstraints addObject:cusSendLeftConstraint];
    [self.marginConstraints addObject:cusSendRightConstraint];
    [self.marginConstraints addObject:cusSendBottomConstraint];
    

    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupTrackBubbleConstraints  {
    [self _setupTrackBubbleMarginConstraints];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.trackTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cusImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.cusImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cusDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cusPriceLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cusPriceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cusDescLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sendButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]];
    
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
    
    [self removeConstraints:self.marginConstraints];
    [self _setupTrackBubbleMarginConstraints];
}



@end
