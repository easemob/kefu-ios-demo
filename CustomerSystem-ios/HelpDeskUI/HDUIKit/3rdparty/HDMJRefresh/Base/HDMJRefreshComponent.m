//  HDMJRefreshComponent.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//

#import "HDMJRefreshComponent.h"
#import "HDMJRefreshConst.h"
#import "UIView+HDMJExtension.h"
#import "UIScrollView+HDMJRefresh.h"

@interface HDMJRefreshComponent()
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation HDMJRefreshComponent
#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self prepare];
        self.state = HDMJRefreshStateIdle;
    }
    return self;
}

- (void)prepare
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self placeSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    if (newSuperview) {
        self.mj_w = newSuperview.mj_w;
        self.mj_x = 0;
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == HDMJRefreshStateWillRefresh) {
        self.state = HDMJRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:HDMJRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:HDMJRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:HDMJRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:HDMJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:HDMJRefreshKeyPathContentSize];;
    [self.pan removeObserver:self forKeyPath:HDMJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:HDMJRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden) return;
    if ([keyPath isEqualToString:HDMJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:HDMJRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)beginRefreshing
{
    [UIView animateWithDuration:HDMJRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    if (self.window) {
        self.state = HDMJRefreshStateRefreshing;
    } else {
        self.state = HDMJRefreshStateWillRefresh;
        [self setNeedsDisplay];
    }
}

- (void)endRefreshing
{
    self.state = HDMJRefreshStateIdle;
}

- (BOOL)isRefreshing
{
    return self.state == HDMJRefreshStateRefreshing || self.state == HDMJRefreshStateWillRefresh;
}

#pragma mark Automatically change the alpha
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    self.automaticallyChangeAlpha = autoChangeAlpha;
}

- (BOOL)isAutoChangeAlpha
{
    return self.isAutomaticallyChangeAlpha;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isRefreshing) return;
    
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark Set the transparency dynamically
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - Internal methods
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            HDMJRefreshMsgSend(HDMJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
    });
}
@end

@implementation UILabel(HDMJRefresh)
+ (instancetype)label
{
    UILabel *label = [[self alloc] init];
    label.font = HDMJRefreshLabelFont;
    label.textColor = HDMJRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end
