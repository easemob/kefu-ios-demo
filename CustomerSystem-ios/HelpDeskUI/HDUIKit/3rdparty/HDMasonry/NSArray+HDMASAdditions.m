//
//  NSArray+HDMASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+HDMASAdditions.h"
#import "View+HDMASAdditions.h"

@implementation NSArray (HDMASAdditions)

- (NSArray *)hdmas_makeConstraints:(void(^)(HDMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HDMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HDMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hdmas_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)hdmas_updateConstraints:(void(^)(HDMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HDMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HDMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hdmas_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)hdmas_remakeConstraints:(void(^)(HDMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HDMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HDMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hdmas_remakeConstraints:block]];
    }
    return constraints;
}

- (void)mas_distributeViewsAlongAxis:(HDMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HDMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == HDMASAxisTypeHorizontal) {
        HDMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HDMAS_VIEW *v = self[i];
            [v hdmas_makeConstraints:^(HDMASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.mas_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        HDMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HDMAS_VIEW *v = self[i];
            [v hdmas_makeConstraints:^(HDMASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.mas_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)mas_distributeViewsAlongAxis:(HDMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HDMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == HDMASAxisTypeHorizontal) {
        HDMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HDMAS_VIEW *v = self[i];
            [v hdmas_makeConstraints:^(HDMASConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        HDMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HDMAS_VIEW *v = self[i];
            [v hdmas_makeConstraints:^(HDMASConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (HDMAS_VIEW *)mas_commonSuperviewOfViews
{
    HDMAS_VIEW *commonSuperview = nil;
    HDMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[HDMAS_VIEW class]]) {
            HDMAS_VIEW *view = (HDMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view hdmas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
