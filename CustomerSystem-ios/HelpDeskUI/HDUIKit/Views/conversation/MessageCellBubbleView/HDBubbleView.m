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


#import "HDBubbleView.h"

#import "HDBubbleView+Text.h"
#import "HDBubbleView+Image.h"
#import "HDBubbleView+Location.h"
#import "HDBubbleView+Voice.h"
#import "HDBubbleView+Video.h"
#import "HDBubbleView+File.h"
#import "HDBubbleView+Track.h"
#import "HDBubbleView+Form.h"

NSString *const HRouterEventTapMenu = @"HRouterEventTapMenu";
NSString *const HRouterEventTapArticle = @"HRouterEventTapArticle";
NSString *const HRouterEventTapTransform = @"HRouterEventTapTransform";
NSString *const HRouterEventTapEvaluate = @"HRouterEventTapEvaluate";
NSString *const HRouterEventTextURLTapEventName = @"HRouterEventTextURLTapEventName";
NSString *const HRouterEventTransformURLTapEventName = @"HRouterEventTransformURLTapEventName";
@interface HDBubbleView()

@end

@implementation HDBubbleView

@synthesize backgroundImageView = _backgroundImageView;
@synthesize margin = _margin;

- (instancetype)initWithMargin:(UIEdgeInsets)margin
                      isSender:(BOOL)isSender
{
    self = [super init];
    if (self) {
        _isSender = isSender;
        _margin = margin;
        _marginConstraints = [NSMutableArray array];
        [self addSubview:self.backgroundImageView];
        [self _setupBackgroundImageViewConstraints];
    }
    
    return self;
}

#pragma mark - Setup Constraints

- (void)_setupBackgroundImageViewConstraints
{
    
    [_backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
    }];
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundImageView.userInteractionEnabled = YES;
    }
    
    return _backgroundImageView;
}
// 删除轨迹消息
- (void)sendDeleteTrackMsg:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(deleteTrackMessage:)]) {
        [self.delegate deleteTrackMessage:button];
    }
}

@end
