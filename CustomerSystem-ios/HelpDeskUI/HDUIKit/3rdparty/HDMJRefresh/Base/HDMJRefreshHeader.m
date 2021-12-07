//  HDMJRefreshHeader.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//

#import "HDMJRefreshHeader.h"

@interface HDMJRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation HDMJRefreshHeader

#pragma mark - Constructor methods
+ (instancetype)headerWithRefreshingBlock:(HDMJRefreshComponentRefreshingBlock)refreshingBlock
{
    HDMJRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    HDMJRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeKey = HDMJRefreshHeaderLastUpdatedTimeKey;
    self.mj_h = HDMJRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == HDMJRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
     _scrollViewOriginalInset = self.scrollView.contentInset;
    
    CGFloat offsetY = self.scrollView.mj_offsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    if (offsetY > happenOffsetY) return;
    
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        if (self.state == HDMJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            self.state = HDMJRefreshStatePulling;
        } else if (self.state == HDMJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            self.state = HDMJRefreshStateIdle;
        }
    } else if (self.state == HDMJRefreshStatePulling) {
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(HDMJRefreshState)state
{
    HDMJRefreshCheckState
    
    if (state == HDMJRefreshStateIdle) {
        if (oldState != HDMJRefreshStateRefreshing) return;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:HDMJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;
            
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    } else if (state == HDMJRefreshStateRefreshing) {
        [UIView animateWithDuration:HDMJRefreshFastAnimationDuration animations:^{
            CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
            self.scrollView.mj_insetT = top;
            
            self.scrollView.mj_offsetY = - top;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
}

- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}
@end
