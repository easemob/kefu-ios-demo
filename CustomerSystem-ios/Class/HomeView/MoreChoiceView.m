/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "MoreChoiceView.h"

#import "LocalDefine.h"

@interface MoreChoiceView()

@property (nonatomic, strong) UIButton *preSaleButton;
@property (nonatomic, strong) UIButton *afterSaleButton;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *cutView;

@end

@implementation MoreChoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupviews];
    }
    return self;
}

- (void)_setupviews
{
    _buttonView = [[UIView alloc] init];
    _buttonView.backgroundColor = [UIColor whiteColor];
    _buttonView.frame = CGRectMake(CGRectGetWidth(self.frame) - 125, 0, 120, 100);
    [self addSubview:_buttonView];

    _preSaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_preSaleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_preSaleButton setTitle:NSLocalizedString(@"choice.preSale", @"pre Sale") forState:UIControlStateNormal];
    _preSaleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_preSaleButton addTarget:self action:@selector(preSellAction) forControlEvents:UIControlEventTouchUpInside];
//    [_preSaleButton setBackgroundImage:[[UIImage imageNamed:@"button_demo_department"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
//    [_preSaleButton setBackgroundImage:[[UIImage imageNamed:@"button_demo_department_select"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateHighlighted];
    _preSaleButton.frame = CGRectMake(10, 5, 100, 40);
    [_buttonView addSubview:_preSaleButton];
    
    _afterSaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_afterSaleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_afterSaleButton setTitle:NSLocalizedString(@"choice.afterSale", @"after Sales") forState:UIControlStateNormal];
    _afterSaleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_afterSaleButton addTarget:self action:@selector(afterSaleAction) forControlEvents:UIControlEventTouchUpInside];
//    [_afterSaleButton setBackgroundImage:[[UIImage imageNamed:@"button_demo_department"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
//    [_afterSaleButton setBackgroundImage:[[UIImage imageNamed:@"button_demo_department_select"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateHighlighted];
    _afterSaleButton.frame = CGRectMake(10, CGRectGetMaxY(_preSaleButton.frame) + 10, 100, 40);
    [_buttonView addSubview:_afterSaleButton];
    
    _cutView = [[UIView alloc] init];
    _cutView.backgroundColor = RGBACOLOR(184, 22, 22, 1);
    _cutView.frame = CGRectMake(0, _buttonView.frame.size.height/2 - 0.5, _buttonView.frame.size.width, 1);
    [_buttonView addSubview:_cutView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - action
- (void)afterSaleAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignWindow" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:@{kpreSell:[NSNumber numberWithBool:NO]}];
    self.hidden = YES;
}

- (void)preSellAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignWindow" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT object:@{kpreSell:[NSNumber numberWithBool:YES]}];
    self.hidden = YES;
}

- (void)hideAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignWindow" object:nil];
    self.hidden = YES;
}

@end
