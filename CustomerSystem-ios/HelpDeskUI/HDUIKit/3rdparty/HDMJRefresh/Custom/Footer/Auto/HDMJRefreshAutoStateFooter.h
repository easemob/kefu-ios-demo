//
//  HDMJRefreshAutoStateFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "HDMJRefreshAutoFooter.h"

@interface HDMJRefreshAutoStateFooter : HDMJRefreshAutoFooter

- (void)setTitle:(NSString *)title forState:(HDMJRefreshState)state;

@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@property (weak, nonatomic, readonly) UILabel *stateLabel;

@end
