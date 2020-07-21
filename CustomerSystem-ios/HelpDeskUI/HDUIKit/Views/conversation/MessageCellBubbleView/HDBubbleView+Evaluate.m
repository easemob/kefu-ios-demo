//
//  EaseBubbleView+Evaluate.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/9.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Evaluate.h"

@implementation HDBubbleView (Evaluate)

- (void)_setupEvaluateBubbleConstraints {
    [self.evaluateTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.bottom.equalTo(self.evaluateButton.mas_top).offset(-3);
    }];
    
    [self.evaluateButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX).offset(0);
    }];
}

- (void)setupEvaluateBubbleView {
    self.evaluateTitle = [[UILabel alloc] init];
    self.evaluateTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.evaluateTitle.backgroundColor = [UIColor clearColor];
    self.evaluateTitle.font = [UIFont systemFontOfSize:15];
    self.evaluateTitle.textColor = [UIColor blackColor];
    self.evaluateTitle.numberOfLines = 0;
    [self.backgroundImageView addSubview:self.evaluateTitle];
    
    self.evaluateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.evaluateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.evaluateButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.evaluateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.evaluateButton.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0];
    self.evaluateButton.layer.cornerRadius = 5.f;
    [self.evaluateButton setTitle:NSLocalizedString(@"to_evaluate", @"To evaluate") forState:UIControlStateNormal];
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
    [self _setupEvaluateBubbleConstraints];
}


@end
