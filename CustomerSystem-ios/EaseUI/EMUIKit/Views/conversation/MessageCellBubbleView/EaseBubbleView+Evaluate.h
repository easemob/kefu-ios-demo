//
//  EaseBubbleView+Evaluate.h
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/12/9.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (Evaluate)
//判断是否为评价消息
+ (BOOL)isEvaluateMessage:(HMessage *)message;

- (void)setupEvaluateBubbleView;

- (void)updateEvaluateMargin:(UIEdgeInsets)margin;

@end
