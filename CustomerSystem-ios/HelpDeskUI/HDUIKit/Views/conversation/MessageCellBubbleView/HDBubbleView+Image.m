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


#import "HDBubbleView+Image.h"

@implementation HDBubbleView (Image)

#pragma mark - private

- (void)_setupImageBubbleConstraints
{
    [self.imageView hdmas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(5);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
       
        if (self.transformFigureButton.hidden) {
            make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        }
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
    }];
    
    [self.transformFigureButton hdmas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-self.margin.bottom);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX).offset(0);
    }];
}





#pragma mark - public

- (void)setupImageBubbleView
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.imageView];
    

    self.transformFigureButton = [HDTransformButton buttonWithType:UIButtonTypeCustom];
    kWeakSelf
    self.transformFigureButton.clickTransformBlock = ^(UIButton * _Nonnull btn) {
        
        [[weakSelf nextResponder] routerEventWithName:HRouterEventTapTransform userInfo:nil];
    };

    [self.backgroundImageView addSubview:self.transformFigureButton];
    
    [self _setupImageBubbleConstraints];
}

- (void)updateImageMargin:(UIEdgeInsets)margin
{

    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    [self _setupImageBubbleConstraints];
}

@end
