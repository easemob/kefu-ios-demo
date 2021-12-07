//  HDMJRefreshFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/5.

#import "HDMJRefreshComponent.h"

@interface HDMJRefreshFooter : HDMJRefreshComponent

+ (instancetype)footerWithRefreshingBlock:(HDMJRefreshComponentRefreshingBlock)refreshingBlock;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData HDMJRefreshDeprecated("Please use endRefreshingWithNoMoreData");
- (void)resetNoMoreData;

@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;

@end
