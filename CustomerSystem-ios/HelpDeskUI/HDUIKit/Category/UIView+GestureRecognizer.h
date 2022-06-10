//
//  UIView+GestureRecognizer.h
//  WSGameCenter
//
//  Created by lcyu on 2017/7/21.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GestureRecognizer)
- (void)setTapActionWithBlock:(void (^)(void))block;
- (UIGestureRecognizer *)getGR;
+(instancetype)viewFromXib;
+(instancetype)viewFromBundleXib;
@end
