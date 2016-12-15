//
//  EaseBubbleView+Transform.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/8.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (Transform)
+ (BOOL)isTransferMessage:(HMessage *)message;

- (void)setupTransformBubbleView;

- (void)updateTransformMargin:(UIEdgeInsets)margin;

- (void)setTransformButtonBackgroundColorWithEnable:(BOOL)enable;
@end
