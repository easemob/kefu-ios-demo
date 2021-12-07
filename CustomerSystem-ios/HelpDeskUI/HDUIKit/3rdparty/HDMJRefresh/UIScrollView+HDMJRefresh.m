//  UIScrollView+HDMJRefresh.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//

#import "UIScrollView+HDMJRefresh.h"
#import "HDMJRefreshHeader.h"
#import "HDMJRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (HDMJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (HDMJRefresh)

static const char HDMJRefreshHeaderKey = '\0';

- (void)setMj_header:(HDMJRefreshHeader *)mj_header
{
    if (mj_header != self.mj_header) {
        [self.mj_header removeFromSuperview];
        [self insertSubview:mj_header atIndex:0];
        [self willChangeValueForKey:@"hdmj_header"]; // KVO
        objc_setAssociatedObject(self, &HDMJRefreshHeaderKey,
                                 mj_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"hdmj_header"]; // KVO
    }
}

- (HDMJRefreshHeader *)mj_header
{
    return objc_getAssociatedObject(self, &HDMJRefreshHeaderKey);
}

static const char HDMJRefreshFooterKey = '\0';
- (void)setMj_footer:(HDMJRefreshFooter *)mj_footer
{
    if (mj_footer != self.mj_footer) {
        [self.mj_footer removeFromSuperview];
        [self addSubview:mj_footer];
        [self willChangeValueForKey:@"hdmj_footer"]; // KVO
        objc_setAssociatedObject(self, &HDMJRefreshFooterKey,
                                 mj_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"hdmj_footer"]; // KVO
    }
}

- (HDMJRefreshFooter *)mj_footer
{
    return objc_getAssociatedObject(self, &HDMJRefreshFooterKey);
}

- (void)setFooter:(HDMJRefreshFooter *)footer
{
    self.mj_footer = footer;
}

- (HDMJRefreshFooter *)footer
{
    return self.mj_footer;
}

- (void)setHeader:(HDMJRefreshHeader *)header
{
    self.mj_header = header;
}

- (HDMJRefreshHeader *)header
{
    return self.mj_header;
}

- (NSInteger)mj_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char HDMJRefreshReloadDataBlockKey = '\0';
- (void)setMj_reloadDataBlock:(void (^)(NSInteger))hdmj_reloadDataBlock
{
    [self willChangeValueForKey:@"hdmj_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &HDMJRefreshReloadDataBlockKey, hdmj_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"hdmj_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))hdmj_reloadDataBlock
{
    return objc_getAssociatedObject(self, &HDMJRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.hdmj_reloadDataBlock ? : self.hdmj_reloadDataBlock(self.mj_totalDataCount);
}
@end

@implementation UITableView (HDMJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (HDMJRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mj_reloadData)];
}

- (void)mj_reloadData
{
    [self mj_reloadData];
    
    [self executeReloadDataBlock];
}

@end
