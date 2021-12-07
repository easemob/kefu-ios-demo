//  HDMJRefreshFooter.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//

#import "HDMJRefreshFooter.h"

@interface HDMJRefreshFooter()

@end

@implementation HDMJRefreshFooter

#pragma mark - Constructor methods
+ (instancetype)footerWithRefreshingBlock:(HDMJRefreshComponentRefreshingBlock)refreshingBlock
{
    HDMJRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    HDMJRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    self.mj_h = HDMJRefreshFooterHeight;
    self.automaticallyHidden = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        if ([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]]) {
            [self.scrollView setHdmj_reloadDataBlock:^(NSInteger totalDataCount) {
                if (self.isAutomaticallyHidden) {
                    self.hidden = (totalDataCount == 0);
                }
            }];
        }
    }
}

- (void)endRefreshingWithNoMoreData
{
    self.state = HDMJRefreshStateNoMoreData;
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    self.state = HDMJRefreshStateIdle;
}
@end
