//
//  EaseBubbleView+Transform.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/8.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Transform.h"

@implementation HDBubbleView (Transform)

- (void)_setupTransformBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];
    
    NSLayoutConstraint *transTitleMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.transTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *transTitleMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.transTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *transTitleMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.transTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.left];
    [self.marginConstraints addObject:transTitleMarginTopConstraint];
    [self.marginConstraints addObject:transTitleMarginLeftConstraint];
    [self.marginConstraints addObject:transTitleMarginRightConstraint];
    
    NSLayoutConstraint *transButtonMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.transformButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.transTitle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:3];
    NSLayoutConstraint *transButtonMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.transformButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:transButtonMarginTopConstraint];
    [self.marginConstraints addObject:transButtonMarginBottomConstraint];
    [self addConstraints:self.marginConstraints];
}

- (void)_setupTransformBubbleConstraints {
    [self _setupTransformBubbleMarginConstraints];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.transformButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.transformButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.transformButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)setupTransformBubbleView {
    self.transTitle = [[UILabel alloc] init];
    self.transTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.transTitle.backgroundColor = [UIColor clearColor];
    self.transTitle.font = [UIFont systemFontOfSize:15];
    self.transTitle.numberOfLines = 0;
    [self.backgroundImageView addSubview:self.transTitle];
    
    self.transformButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.transformButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.transformButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.transformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.transformButton.layer.cornerRadius = 5.f;
    [self.transformButton setTitle:NSLocalizedString(@"transfertocs", @"Transfer Kefu") forState:UIControlStateNormal];
    [self.transformButton addTarget:self action:@selector(transformAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:self.transformButton];
    
    [self _setupTransformBubbleConstraints];
}

- (void)transformAction:(UIButton *)sender {
    [[self nextResponder] routerEventWithName:HRouterEventTapTransform userInfo:nil];
}

- (void)updateTransformMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupTransformBubbleMarginConstraints];
}

- (void)setTransformButtonBackgroundColorWithEnable:(BOOL)enable {
    self.transformButton.backgroundColor = enable?[UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0]:[UIColor lightGrayColor];
    self.transformButton.enabled = enable;
}





@end
