//
//  HDMJRefreshAutoGifFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "HDMJRefreshAutoStateFooter.h"

@interface HDMJRefreshAutoGifFooter : HDMJRefreshAutoStateFooter

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(HDMJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(HDMJRefreshState)state;

@end
