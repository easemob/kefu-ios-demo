//
//  EaseBubbleView+Order.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/6.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+Order.h"

@implementation HDBubbleView (Order)

- (void)_setupOrderBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];
    
    //orderTitle
    NSLayoutConstraint *orderTitleMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *orderTitleMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *orderTitleMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:orderTitleMarginTopConstraint];
    [self.marginConstraints addObject:orderTitleMarginLeftConstraint];
    [self.marginConstraints addObject:orderTitleMarginRightConstraint];
    
    
    // orderBgView
    NSLayoutConstraint *orderBgViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderBgViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderBgViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    NSLayoutConstraint *orderBgViewBottomhtConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    [self.marginConstraints addObject:orderBgViewTopConstraint];
    [self.marginConstraints addObject:orderBgViewLeftConstraint];
    [self.marginConstraints addObject:orderBgViewRightConstraint];
    [self.marginConstraints addObject:orderBgViewBottomhtConstraint];
    
    //cusImageView
    NSLayoutConstraint *orderImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderImageViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *orderImageViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.orderImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:orderImageViewTopConstraint];
    [self.marginConstraints addObject:orderImageViewLeftConstraint];
    [self.marginConstraints addObject:orderImageViewBottomConstraint];
    
    //orderNo
    NSLayoutConstraint *orderNoMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderNoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
    NSLayoutConstraint *orderNoMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderNoLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderNoMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderNoLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:orderNoMarginTopConstraint];
    [self.marginConstraints addObject:orderNoMarginLeftConstraint];
    [self.marginConstraints addObject:orderNoMarginRightConstraint];
    
    //desc
    NSLayoutConstraint *orderDescTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderNoLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:8.0];
    NSLayoutConstraint *orderDescLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderImageView attribute:NSLayoutAttributeRight multiplier:1 constant:5.0];
    NSLayoutConstraint *orderDescRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1 constant:-self.margin.right];
    
    [self.marginConstraints addObject:orderDescTopConstraint];
    [self.marginConstraints addObject:orderDescLeftConstraint];
    [self.marginConstraints addObject:orderDescRightConstraint];
    
    //price
    NSLayoutConstraint *orderPriceBottomConstraimt = [NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.margin.bottom];
    
    [self.marginConstraints addObject:orderPriceBottomConstraimt];
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupOrderBubbleConstraints  {
    [self _setupOrderBubbleMarginConstraints];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:15]];
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.orderNoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:13]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.orderImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderPriceLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
}

- (void)setupOrderBubbleView {
    
    self.orderBgView = [[UIView alloc] init];
    self.orderBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderBgView.backgroundColor = [UIColor whiteColor];
    [self.backgroundImageView addSubview:self.orderBgView];
    
    self.orderTitleLabel = [[UILabel alloc] init];
    self.orderTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderTitleLabel.backgroundColor = [UIColor clearColor];
    self.orderTitleLabel.font = [UIFont systemFontOfSize:13];
    [self.orderBgView addSubview:self.orderTitleLabel];
    
    self.orderNoLabel = [[UILabel alloc] init];
    self.orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderNoLabel.backgroundColor = [UIColor clearColor];
    self.orderNoLabel.font = [UIFont systemFontOfSize:10];
    [self.orderBgView addSubview:self.orderNoLabel];
    
    self.orderImageView = [[UIImageView alloc] init];
    self.orderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderImageView.backgroundColor = [UIColor clearColor];
    self.orderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.orderBgView addSubview:self.orderImageView];
    
    self.orderDescLabel = [[UILabel alloc] init];
    self.orderDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderDescLabel.backgroundColor = [UIColor clearColor];
    self.orderDescLabel.font = [UIFont systemFontOfSize:13];
    self.orderDescLabel.numberOfLines = 3;
    [self.orderBgView addSubview:self.orderDescLabel];
    
    self.orderPriceLabel = [[UILabel alloc] init];
    self.orderPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderPriceLabel.backgroundColor = [UIColor clearColor];
    self.orderPriceLabel.font = [UIFont systemFontOfSize:15];
    self.orderPriceLabel.textColor = [UIColor redColor];
    [self.orderBgView addSubview:self.orderPriceLabel];
    [self _setupOrderBubbleConstraints];
}




- (void)updateOrderMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupOrderBubbleMarginConstraints];
}
@end
