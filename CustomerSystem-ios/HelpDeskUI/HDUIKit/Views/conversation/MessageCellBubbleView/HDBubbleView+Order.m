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
    
    
    // orderBgView
    NSLayoutConstraint *orderBgViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderBgViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
    NSLayoutConstraint *orderBgViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    NSLayoutConstraint *orderBgViewBottomhtConstraint = [NSLayoutConstraint constraintWithItem:self.orderBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    [self.marginConstraints addObject:orderBgViewTopConstraint];
    [self.marginConstraints addObject:orderBgViewLeftConstraint];
    [self.marginConstraints addObject:orderBgViewRightConstraint];
    [self.marginConstraints addObject:orderBgViewBottomhtConstraint];
    
    //orderTitle
    NSLayoutConstraint *orderTitleMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *orderTitleMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *orderTitleMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
    [self.marginConstraints addObject:orderTitleMarginTopConstraint];
    [self.marginConstraints addObject:orderTitleMarginLeftConstraint];
    [self.marginConstraints addObject:orderTitleMarginRightConstraint];
    
    
    //horizontalLine
    NSLayoutConstraint *horizontalLineoMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.horizontalLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5];
    NSLayoutConstraint *horizontalLineMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.horizontalLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *horizontalLineMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.horizontalLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.marginConstraints addObject:horizontalLineoMarginTopConstraint];
    [self.marginConstraints addObject:horizontalLineMarginLeftConstraint];
    [self.marginConstraints addObject:horizontalLineMarginRightConstraint];
    
    //verticalLine
    NSLayoutConstraint *verticalLineMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.verticalLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.horizontalLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    NSLayoutConstraint *verticalLineMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.verticalLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:110];
    NSLayoutConstraint *verticalLineMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.verticalLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    [self.marginConstraints addObject:verticalLineMarginTopConstraint];
    [self.marginConstraints addObject:verticalLineMarginLeftConstraint];
    [self.marginConstraints addObject:verticalLineMarginBottomConstraint];

    
    //addLabel
    NSLayoutConstraint *addLabelMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.addLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *addLabelMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.addLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *addLabelMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.addLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-16];
    [self.marginConstraints addObject:addLabelMarginTopConstraint];
    [self.marginConstraints addObject:addLabelMarginLeftConstraint];
    [self.marginConstraints addObject:addLabelMarginRightConstraint];
    
    
    //desc
    NSLayoutConstraint *orderDescTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *orderDescLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.margin.left];
    NSLayoutConstraint *orderDescRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeLeft multiplier:1 constant:-15];
    [self.marginConstraints addObject:orderDescTopConstraint];
    [self.marginConstraints addObject:orderDescLeftConstraint];
    [self.marginConstraints addObject:orderDescRightConstraint];
    
    //typeLeftLabel
    NSLayoutConstraint *typeLeftLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.typeLeftLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *typeLeftLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.typeLeftLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.margin.left];
    NSLayoutConstraint *typeLeftLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.typeLeftLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeLeft multiplier:1 constant:-20];
    NSLayoutConstraint *typeLeftLabeBottomConstraint = [NSLayoutConstraint constraintWithItem:self.typeLeftLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    [self.marginConstraints addObject:typeLeftLabelTopConstraint];
    [self.marginConstraints addObject:typeLeftLabelLeftConstraint];
    [self.marginConstraints addObject:typeLeftLabelRightConstraint];
    [self.marginConstraints addObject:typeLeftLabeBottomConstraint];
    
    //unitLabel
    NSLayoutConstraint *unitLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *unitLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeRight multiplier:1 constant:20];
    NSLayoutConstraint *unitLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.marginConstraints addObject:unitLabelTopConstraint];
    [self.marginConstraints addObject:unitLabelLeftConstraint];
    [self.marginConstraints addObject:unitLabelRightConstraint];
    
    //price
    NSLayoutConstraint *orderPriceLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *orderPriceLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeRight multiplier:1 constant:20];
    NSLayoutConstraint *orderPriceLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    [self.marginConstraints addObject:orderPriceLabelTopConstraint];
    [self.marginConstraints addObject:orderPriceLabelLeftConstraint];
    [self.marginConstraints addObject:orderPriceLabelRightConstraint];
    
    //typeRightLabel
    NSLayoutConstraint *typeRightLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.typeRightLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.typeLeftLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *typeRightLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.typeRightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.verticalLine attribute:NSLayoutAttributeRight multiplier:1 constant:20];
    NSLayoutConstraint *typeRightLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.typeRightLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    NSLayoutConstraint *typeRightLabelBottomConstraint = [NSLayoutConstraint constraintWithItem:self.typeRightLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.orderBgView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    [self.marginConstraints addObject:typeRightLabelTopConstraint];
    [self.marginConstraints addObject:typeRightLabelLeftConstraint];
    [self.marginConstraints addObject:typeRightLabelRightConstraint];
    [self.marginConstraints addObject:typeRightLabelBottomConstraint];

    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupOrderBubbleConstraints  {
    [self _setupOrderBubbleMarginConstraints];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
//    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.orderNoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:224]];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.addLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10]];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.typeLeftLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.verticalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:11]];
//        [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:71]];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.typeRightLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10]];
    
    
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.orderPriceLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.orderPriceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.orderDescLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
}

/*
 @property(nonatomic,strong) UIView *horizontalLine;
 @property(nonatomic,strong) UILabel *addLabel;
 @property(nonatomic,strong) UILabel *typeLeftLabel;
 @property(nonatomic,strong) UIView *verticalLine;
 @property(nonatomic,strong) UILabel *unitLabel;
 @property(nonatomic,strong) UILabel *typeRightLabel;
 RGBACOLOR(216, 216, 216, 1)
 */
- (void)setupOrderBubbleView {
    
    self.orderBgView = [[UIView alloc] init];
    self.orderBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderBgView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    [self.backgroundImageView addSubview:self.orderBgView];
    
    self.orderTitleLabel = [[UILabel alloc] init];
    self.orderTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderTitleLabel.backgroundColor = [UIColor clearColor];
    self.orderTitleLabel.font = [UIFont systemFontOfSize:13];
    [self.orderBgView addSubview:self.orderTitleLabel];
    
//    self.orderNoLabel = [[UILabel alloc] init];
//    self.orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderNoLabel.backgroundColor = [UIColor clearColor];
//    self.orderNoLabel.textAlignment = NSTextAlignmentCenter;
//    self.orderNoLabel.font = [UIFont systemFontOfSize:10];
//    [self.orderBgView addSubview:self.orderNoLabel];
    
    self.horizontalLine = [[UIView alloc] init];
    self.horizontalLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.horizontalLine.backgroundColor = RGBACOLOR(216, 216, 216, 1);
    [self.orderBgView addSubview:self.horizontalLine];
    
    self.addLabel = [[UILabel alloc] init];
    self.addLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addLabel.backgroundColor = [UIColor clearColor];
    self.addLabel.font = [UIFont systemFontOfSize:9];
    self.addLabel.textColor = RGBACOLOR(171, 171, 171, 1);
    self.addLabel.text = @"日涨跌篇 (06-16)";
    [self.orderBgView addSubview:self.addLabel];
    
    self.orderDescLabel = [[UILabel alloc] init];
    self.orderDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderDescLabel.backgroundColor = [UIColor clearColor];
    self.orderDescLabel.font = [UIFont systemFontOfSize:22];
    [self.orderDescLabel setTextColor:RGBACOLOR(288, 91, 91, 1)];
    [self.orderBgView addSubview:self.orderDescLabel];
    
    self.typeLeftLabel = [[UILabel alloc] init];
    self.typeLeftLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.typeLeftLabel.backgroundColor = [UIColor clearColor];
    self.typeLeftLabel.font = [UIFont systemFontOfSize:9];
    self.typeLeftLabel.text = @"基金类型  股票型";
    self.typeLeftLabel.textColor = RGBACOLOR(171, 171, 171, 1);
    [self.orderBgView addSubview:self.typeLeftLabel];
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.verticalLine.backgroundColor = RGBACOLOR(216, 216, 216, 1);
    [self.orderBgView addSubview:self.verticalLine];
    
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.unitLabel.backgroundColor = [UIColor clearColor];
    self.unitLabel.font = [UIFont systemFontOfSize:9];
    self.unitLabel.text = @"单位净值 (06-16)";
    self.unitLabel.textColor = RGBACOLOR(171, 171, 171, 1);
    [self.orderBgView addSubview:self.unitLabel];
    
    self.orderPriceLabel = [[UILabel alloc] init];
    self.orderPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderPriceLabel.backgroundColor = [UIColor clearColor];
    self.orderPriceLabel.font = [UIFont systemFontOfSize:22];
    [self.orderPriceLabel setTextColor:RGBACOLOR(288, 91, 91, 1)];
    [self.orderBgView addSubview:self.orderPriceLabel];
    
    self.typeRightLabel = [[UILabel alloc] init];
    self.typeRightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.typeRightLabel.backgroundColor = [UIColor clearColor];
    self.typeRightLabel.font = [UIFont systemFontOfSize:9];
    self.typeRightLabel.text = @"基金类型  股票型";
    self.typeRightLabel.textColor = RGBACOLOR(171, 171, 171, 1);
    [self.orderBgView addSubview:self.typeRightLabel];

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
