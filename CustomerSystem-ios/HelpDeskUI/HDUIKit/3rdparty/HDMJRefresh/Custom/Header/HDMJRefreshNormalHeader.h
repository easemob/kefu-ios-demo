//
//  HDMJRefreshNormalHeader.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "HDMJRefreshStateHeader.h"

@interface HDMJRefreshNormalHeader : HDMJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
