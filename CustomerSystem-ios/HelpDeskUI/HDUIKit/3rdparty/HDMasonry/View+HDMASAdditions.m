//
//  UIView+HDMASAdditions.m
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+HDMASAdditions.h"
#import <objc/runtime.h>

@implementation HDMAS_VIEW (HDMASAdditions)

- (NSArray *)hdmas_makeConstraints:(void(^)(HDMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HDMASConstraintMaker *constraintMaker = [[HDMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)hdmas_updateConstraints:(void(^)(HDMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HDMASConstraintMaker *constraintMaker = [[HDMASConstraintMaker alloc] initWithView:self];
    constraintMaker.hdupdateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)hdmas_remakeConstraints:(void(^)(HDMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HDMASConstraintMaker *constraintMaker = [[HDMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (HDMASViewAttribute *)mas_left {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (HDMASViewAttribute *)mas_top {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (HDMASViewAttribute *)mas_right {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (HDMASViewAttribute *)mas_bottom {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (HDMASViewAttribute *)mas_leading {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (HDMASViewAttribute *)mas_trailing {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (HDMASViewAttribute *)mas_width {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (HDMASViewAttribute *)mas_height {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (HDMASViewAttribute *)mas_centerX {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (HDMASViewAttribute *)mas_centerY {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (HDMASViewAttribute *)mas_baseline {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (HDMASViewAttribute *(^)(NSLayoutAttribute))mas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

- (HDMASViewAttribute *)mas_firstBaseline {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (HDMASViewAttribute *)mas_lastBaseline {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HDMASViewAttribute *)hdmas_leftMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HDMASViewAttribute *)hdmas_rightMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (HDMASViewAttribute *)hdmas_topMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (HDMASViewAttribute *)hdmas_bottomMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HDMASViewAttribute *)hdmas_leadingMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HDMASViewAttribute *)hdmas_trailingMargin {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HDMASViewAttribute *)hdmas_centerXWithinMargins {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HDMASViewAttribute *)hdmas_centerYWithinMargins {
    return [[HDMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuide {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeNotAnAttribute];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideLeading {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeading];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideTrailing {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTrailing];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideLeft {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideRight {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideTop {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideBottom {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideWidth {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeWidth];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideHeight {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeHeight];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideCenterX {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterX];
}

- (HDMASViewAttribute *)hdmas_safeAreaLayoutGuideCenterY {
    return [[HDMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterY];
}

#endif

#pragma mark - associated properties

- (id)hdmas_key {
    return objc_getAssociatedObject(self, @selector(hdmas_key));
}

- (void)setHdMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(hdmas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)hdmas_closestCommonSuperview:(HDMAS_VIEW *)view {
    HDMAS_VIEW *closestCommonSuperview = nil;

    HDMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        HDMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
