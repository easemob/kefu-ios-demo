//
//  HDMJRefreshBackGifFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "HDMJRefreshBackStateFooter.h"

@interface HDMJRefreshBackGifFooter : HDMJRefreshBackStateFooter

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(HDMJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(HDMJRefreshState)state;

@end
