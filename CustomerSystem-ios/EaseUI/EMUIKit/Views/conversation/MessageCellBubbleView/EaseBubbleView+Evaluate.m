//
//  EaseBubbleView+Evaluate.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/12/9.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EaseBubbleView+Evaluate.h"

@implementation EaseBubbleView (Evaluate)
+ (BOOL)isEvaluateMessage:(HMessage *)message
{
    NSString  *userName = [[HChatClient sharedClient] currentUsername];
    BOOL isSender = [userName isEqualToString:message.from] ? YES : NO;
    if ([message.ext objectForKey:kMesssageExtWeChat] && !isSender) {
        NSDictionary *dic = [message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_inviteEnquiry]) {
            return YES;
        }
    }
    return NO;
}

- (void)_setupEvaluateBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];
    
    NSLayoutConstraint *transTitleMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.evaluateTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *transTitleMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.evaluateTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *transTitleMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.evaluateTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:transTitleMarginTopConstraint];
    [self.marginConstraints addObject:transTitleMarginLeftConstraint];
    [self.marginConstraints addObject:transTitleMarginRightConstraint];
    
    NSLayoutConstraint *transButtonMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.evaluateButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom- 10];
    [self.marginConstraints addObject:transButtonMarginBottomConstraint];
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupEvaluateBubbleConstraints {
    [self _setupEvaluateBubbleMarginConstraints];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.evaluateButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.evaluateButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.evaluateButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)setupEvaluateBubbleView {
    self.evaluateTitle = [[UILabel alloc] init];
    self.evaluateTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.evaluateTitle.backgroundColor = [UIColor clearColor];
    self.evaluateTitle.font = [UIFont systemFontOfSize:15];
    self.evaluateTitle.numberOfLines = 0;
    [self.backgroundImageView addSubview:self.evaluateTitle];
    
    self.evaluateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.evaluateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.evaluateButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.evaluateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.evaluateButton.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.evaluateButton.layer.cornerRadius = 5.f;
    [self.evaluateButton setTitle:@"去评价" forState:UIControlStateNormal];
    [self.evaluateButton addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:self.evaluateButton];
    
    [self _setupEvaluateBubbleConstraints];
}

- (void)evaluateAction:(UIButton *)sender {
    [[self nextResponder] routerEventWithName:HRouterEventTapEvaluate userInfo:nil];
}

- (void)updateEvaluateMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupEvaluateBubbleMarginConstraints];
}


@end
