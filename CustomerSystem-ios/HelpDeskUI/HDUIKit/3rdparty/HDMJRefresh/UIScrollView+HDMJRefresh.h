//  UIScrollView+HDMJRefresh.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.

#import <UIKit/UIKit.h>
#import "HDMJRefreshConst.h"

@class HDMJRefreshHeader, HDMJRefreshFooter;

@interface UIScrollView (HDMJRefresh)

@property (strong, nonatomic) HDMJRefreshHeader *mj_header;
@property (strong, nonatomic) HDMJRefreshHeader *header HDMJRefreshDeprecated("hdmj_header");
@property (strong, nonatomic) HDMJRefreshFooter *mj_footer;
@property (strong, nonatomic) HDMJRefreshFooter *footer HDMJRefreshDeprecated("hdmj_footer");
@property (copy, nonatomic) void (^hdmj_reloadDataBlock)(NSInteger totalDataCount);

- (NSInteger)mj_totalDataCount;

@end
