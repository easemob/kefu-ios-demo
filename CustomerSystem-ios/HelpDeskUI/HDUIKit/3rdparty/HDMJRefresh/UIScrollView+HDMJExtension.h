//  UIScrollView+Extension.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HDMJExtension)

@property (assign, nonatomic) CGFloat mj_insetT;
@property (assign, nonatomic) CGFloat mj_insetB;
@property (assign, nonatomic) CGFloat mj_insetL;
@property (assign, nonatomic) CGFloat mj_insetR;
@property (assign, nonatomic) CGFloat mj_offsetX;
@property (assign, nonatomic) CGFloat mj_offsetY;
@property (assign, nonatomic) CGFloat mj_contentW;
@property (assign, nonatomic) CGFloat mj_contentH;

@end
