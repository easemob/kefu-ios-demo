//
//  HDMJRefreshBackNormalFooter.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "HDMJRefreshBackStateFooter.h"

@interface HDMJRefreshBackNormalFooter : HDMJRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
