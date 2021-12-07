//
//  HDMJRefreshBackStateFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "HDMJRefreshBackFooter.h"

@interface HDMJRefreshBackStateFooter : HDMJRefreshBackFooter

@property (weak, nonatomic, readonly) UILabel *stateLabel;

- (void)setTitle:(NSString *)title forState:(HDMJRefreshState)state;
- (NSString *)titleForState:(HDMJRefreshState)state;

@end
