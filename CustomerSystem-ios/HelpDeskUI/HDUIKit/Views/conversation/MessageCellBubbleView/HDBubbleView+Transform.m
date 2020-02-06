//
//  EaseBubbleView+Transform.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/8.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Transform.h"

@implementation HDBubbleView (Transform)

- (void)_setupTransformBubbleConstraints {
    [self.transTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.left);
    }];
    [self.transformButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.top.equalTo(self.transTitle.mas_bottom).offset(3);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX).offset(0);
    }];
}

- (void)setupTransformBubbleView {
    self.transTitle = [[UILabel alloc] init];
    self.transTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.transTitle.backgroundColor = [UIColor clearColor];
    self.transTitle.font = [UIFont systemFontOfSize:15];
    self.transTitle.numberOfLines = 0;
    self.transTitle.textColor = UIColor.blackColor;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transfransBubbleViewPressed:)];
    [self addGestureRecognizer:tap];
}

- (void)transfransBubbleViewPressed:(UITapGestureRecognizer *)aTap {
    [[self nextResponder] routerEventWithName:HRouterEventTransformURLTapEventName
                                     userInfo:@{@"url":self.transTitle.text}];
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
    [self _setupTransformBubbleConstraints];
}

- (void)setTransformButtonBackgroundColorWithEnable:(BOOL)enable {
    self.transformButton.backgroundColor = enable?[UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0]:[UIColor lightGrayColor];
    self.transformButton.enabled = enable;
}

@end
