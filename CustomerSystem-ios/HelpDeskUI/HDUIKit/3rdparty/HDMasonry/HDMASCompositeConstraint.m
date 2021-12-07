//
//  HDMASCompositeConstraint.m
//  HDMasonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASCompositeConstraint.h"
#import "HDMASConstraint+Private.h"

@interface HDMASCompositeConstraint () <HDMASConstraintDelegate>

@property (nonatomic, strong) id hdmas_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

@implementation HDMASCompositeConstraint

- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;

    _childConstraints = [children mutableCopy];
    for (HDMASConstraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }

    return self;
}

#pragma mark - HDMASConstraintDelegate

- (void)constraint:(HDMASConstraint *)constraint hdShouldBeReplacedWithConstraint:(HDMASConstraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (HDMASConstraint *)constraint:(HDMASConstraint __unused *)constraint hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<HDMASConstraintDelegate> strongDelegate = self.delegate;
    HDMASConstraint *newConstraint = [strongDelegate constraint:self hdAddConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

#pragma mark - NSLayoutConstraint multiplier proxies 

- (HDMASConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (HDMASConstraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}

- (HDMASConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (HDMASConstraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}

#pragma mark - HDMASLayoutPriority proxy

- (HDMASConstraint * (^)(HDMASLayoutPriority))priority {
    return ^id(HDMASLayoutPriority priority) {
        for (HDMASConstraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (HDMASConstraint * (^)(id, NSLayoutRelation))hdequalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (HDMASConstraint *constraint in self.childConstraints.copy) {
            constraint.hdequalToWithRelation(attr, relation);
        }
        return self;
    };
}

#pragma mark - attribute chaining

- (HDMASConstraint *)hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self hdAddConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (HDMASConstraint *)animator {
    for (HDMASConstraint *constraint in self.childConstraints) {
        [constraint animator];
    }
    return self;
}

#endif

#pragma mark - debug helpers

- (HDMASConstraint * (^)(id))key {
    return ^id(id key) {
        self.hdmas_key = key;
        int i = 0;
        for (HDMASConstraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(HDMASEdgeInsets)insets {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}

- (void)setInset:(CGFloat)inset {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.inset = inset;
    }
}

- (void)setOffset:(CGFloat)offset {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}

#pragma mark - HDMASConstraint

- (void)activate {
    for (HDMASConstraint *constraint in self.childConstraints) {
        [constraint activate];
    }
}

- (void)deactivate {
    for (HDMASConstraint *constraint in self.childConstraints) {
        [constraint deactivate];
    }
}

- (void)install {
    for (HDMASConstraint *constraint in self.childConstraints) {
        constraint.hdupdateExisting = self.hdupdateExisting;
        [constraint install];
    }
}

- (void)uninstall {
    for (HDMASConstraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}

@end
