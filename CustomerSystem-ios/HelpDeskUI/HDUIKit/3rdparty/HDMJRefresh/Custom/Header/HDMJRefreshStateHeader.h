//
//  HDMJRefreshStateHeader.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "HDMJRefreshHeader.h"

@interface HDMJRefreshStateHeader : HDMJRefreshHeader

@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;
@property (weak, nonatomic, readonly) UILabel *stateLabel;

- (void)setTitle:(NSString *)title forState:(HDMJRefreshState)state;

@end
