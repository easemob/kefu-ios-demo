//
//  HDMASConstraintMaker.m
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASConstraintMaker.h"
#import "HDMASViewConstraint.h"
#import "HDMASCompositeConstraint.h"
#import "HDMASConstraint+Private.h"
#import "HDMASViewAttribute.h"
#import "View+HDMASAdditions.h"

@interface HDMASConstraintMaker () <HDMASConstraintDelegate>

@property (nonatomic, weak) HDMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation HDMASConstraintMaker

- (id)initWithView:(HDMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [HDMASViewConstraint installedConstraintsForView:self.view];
        for (HDMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (HDMASConstraint *constraint in constraints) {
        constraint.hdupdateExisting = self.hdupdateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - HDMASConstraintDelegate

- (void)constraint:(HDMASConstraint *)constraint hdShouldBeReplacedWithConstraint:(HDMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (HDMASConstraint *)constraint:(HDMASConstraint *)constraint hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    HDMASViewAttribute *viewAttribute = [[HDMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    HDMASViewConstraint *newConstraint = [[HDMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:HDMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        HDMASCompositeConstraint *compositeConstraint = [[HDMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint hdShouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (HDMASConstraint *)addConstraintWithAttributes:(HDMASAttribute)attrs {
    __unused HDMASAttribute anyAttribute = (HDMASAttributeLeft | HDMASAttributeRight | HDMASAttributeTop | HDMASAttributeBottom | HDMASAttributeLeading
                                          | HDMASAttributeTrailing | HDMASAttributeWidth | HDMASAttributeHeight | HDMASAttributeCenterX
                                          | HDMASAttributeCenterY | HDMASAttributeBaseline
                                          | HDMASAttributeFirstBaseline | HDMASAttributeLastBaseline
#if TARGET_OS_IPHONE || TARGET_OS_TV
                                          | HDMASAttributeLeftMargin | HDMASAttributeRightMargin | HDMASAttributeTopMargin | HDMASAttributeBottomMargin
                                          | HDMASAttributeLeadingMargin | HDMASAttributeTrailingMargin | HDMASAttributeCenterXWithinMargins
                                          | HDMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & HDMASAttributeLeft) [attributes addObject:self.view.mas_left];
    if (attrs & HDMASAttributeRight) [attributes addObject:self.view.mas_right];
    if (attrs & HDMASAttributeTop) [attributes addObject:self.view.mas_top];
    if (attrs & HDMASAttributeBottom) [attributes addObject:self.view.mas_bottom];
    if (attrs & HDMASAttributeLeading) [attributes addObject:self.view.mas_leading];
    if (attrs & HDMASAttributeTrailing) [attributes addObject:self.view.mas_trailing];
    if (attrs & HDMASAttributeWidth) [attributes addObject:self.view.mas_width];
    if (attrs & HDMASAttributeHeight) [attributes addObject:self.view.mas_height];
    if (attrs & HDMASAttributeCenterX) [attributes addObject:self.view.mas_centerX];
    if (attrs & HDMASAttributeCenterY) [attributes addObject:self.view.mas_centerY];
    if (attrs & HDMASAttributeBaseline) [attributes addObject:self.view.mas_baseline];
    if (attrs & HDMASAttributeFirstBaseline) [attributes addObject:self.view.mas_firstBaseline];
    if (attrs & HDMASAttributeLastBaseline) [attributes addObject:self.view.mas_lastBaseline];
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    if (attrs & HDMASAttributeLeftMargin) [attributes addObject:self.view.hdmas_leftMargin];
    if (attrs & HDMASAttributeRightMargin) [attributes addObject:self.view.hdmas_rightMargin];
    if (attrs & HDMASAttributeTopMargin) [attributes addObject:self.view.hdmas_topMargin];
    if (attrs & HDMASAttributeBottomMargin) [attributes addObject:self.view.hdmas_bottomMargin];
    if (attrs & HDMASAttributeLeadingMargin) [attributes addObject:self.view.hdmas_leadingMargin];
    if (attrs & HDMASAttributeTrailingMargin) [attributes addObject:self.view.hdmas_trailingMargin];
    if (attrs & HDMASAttributeCenterXWithinMargins) [attributes addObject:self.view.hdmas_centerXWithinMargins];
    if (attrs & HDMASAttributeCenterYWithinMargins) [attributes addObject:self.view.hdmas_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (HDMASViewAttribute *a in attributes) {
        [children addObject:[[HDMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    HDMASCompositeConstraint *constraint = [[HDMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (HDMASConstraint *)hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil hdAddConstraintWithLayoutAttribute:layoutAttribute];
}

- (HDMASConstraint *)left {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (HDMASConstraint *)top {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (HDMASConstraint *)right {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (HDMASConstraint *)bottom {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (HDMASConstraint *)leading {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (HDMASConstraint *)trailing {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (HDMASConstraint *)width {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (HDMASConstraint *)height {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (HDMASConstraint *)centerX {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (HDMASConstraint *)centerY {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (HDMASConstraint *)baseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (HDMASConstraint *(^)(HDMASAttribute))attributes {
    return ^(HDMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

- (HDMASConstraint *)firstBaseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (HDMASConstraint *)lastBaseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HDMASConstraint *)leftMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HDMASConstraint *)rightMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (HDMASConstraint *)topMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (HDMASConstraint *)bottomMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HDMASConstraint *)leadingMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HDMASConstraint *)trailingMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HDMASConstraint *)centerXWithinMargins {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HDMASConstraint *)centerYWithinMargins {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (HDMASConstraint *)edges {
    return [self addConstraintWithAttributes:HDMASAttributeTop | HDMASAttributeLeft | HDMASAttributeRight | HDMASAttributeBottom];
}

- (HDMASConstraint *)size {
    return [self addConstraintWithAttributes:HDMASAttributeWidth | HDMASAttributeHeight];
}

- (HDMASConstraint *)center {
    return [self addConstraintWithAttributes:HDMASAttributeCenterX | HDMASAttributeCenterY];
}

#pragma mark - grouping

- (HDMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        HDMASCompositeConstraint *constraint = [[HDMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
