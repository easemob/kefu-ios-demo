//  HDMJRefreshComponent.h
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.

#import <UIKit/UIKit.h>
#import "HDMJRefreshConst.h"
#import "UIView+HDMJExtension.h"
#import "UIScrollView+HDMJExtension.h"
#import "UIScrollView+HDMJRefresh.h"

typedef NS_ENUM(NSInteger, HDMJRefreshState) {
    HDMJRefreshStateIdle = 1,
    HDMJRefreshStatePulling,
    HDMJRefreshStateRefreshing,
    HDMJRefreshStateWillRefresh,
    HDMJRefreshStateNoMoreData
};

typedef void (^HDMJRefreshComponentRefreshingBlock)();

@interface HDMJRefreshComponent : UIView
{
    UIEdgeInsets _scrollViewOriginalInset;
    __weak UIScrollView *_scrollView;
}
#pragma mark - Call backs

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (copy, nonatomic) HDMJRefreshComponentRefreshingBlock refreshingBlock;
@property (weak, nonatomic) id refreshingTarget;
@property (assign, nonatomic) SEL refreshingAction;
- (void)executeRefreshingCallback;

#pragma mark - State management

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@property (assign, nonatomic) HDMJRefreshState state;
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - Overwritten by subclass

- (void)prepare NS_REQUIRES_SUPER;
- (void)placeSubviews NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark - Extra
@property (assign, nonatomic) CGFloat pullingPercent;
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha HDMJRefreshDeprecated("Please use automaticallyChangeAlpha property");
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(HDMJRefresh)
+ (instancetype)label;
@end
