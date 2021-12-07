//  HDMJRefreshHeader.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.

#import "HDMJRefreshComponent.h"

@interface HDMJRefreshHeader : HDMJRefreshComponent

+ (instancetype)headerWithRefreshingBlock:(HDMJRefreshComponentRefreshingBlock)refreshingBlock;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@end
