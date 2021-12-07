//
//  HDMASViewConstraint.m
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASViewConstraint.h"
#import "HDMASConstraint+Private.h"
#import "HDMASCompositeConstraint.h"
#import "HDMASLayoutConstraint.h"
#import "View+HDMASAdditions.h"
#import <objc/runtime.h>

@interface HDMAS_VIEW (HDMASConstraints)

@property (nonatomic, readonly) NSMutableSet *hdmas_installedConstraints;

@end

@implementation HDMAS_VIEW (HDMASConstraints)

static char kInstalledConstraintsKey;

- (NSMutableSet *)hdmas_installedConstraints {
    NSMutableSet *constraints = objc_getAssociatedObject(self, &kInstalledConstraintsKey);
    if (!constraints) {
        constraints = [NSMutableSet set];
        objc_setAssociatedObject(self, &kInstalledConstraintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return constraints;
}

@end


@interface HDMASViewConstraint ()

@property (nonatomic, strong, readwrite) HDMASViewAttribute *secondViewAttribute;
@property (nonatomic, weak) HDMAS_VIEW *installedView;
@property (nonatomic, weak) HDMASLayoutConstraint *layoutConstraint;
@property (nonatomic, assign) NSLayoutRelation layoutRelation;
@property (nonatomic, assign) HDMASLayoutPriority layoutPriority;
@property (nonatomic, assign) CGFloat layoutMultiplier;
@property (nonatomic, assign) CGFloat layoutConstant;
@property (nonatomic, assign) BOOL hasLayoutRelation;
@property (nonatomic, strong) id hdmas_key;
@property (nonatomic, assign) BOOL useAnimator;

@end

@implementation HDMASViewConstraint

- (id)initWithFirstViewAttribute:(HDMASViewAttribute *)firstViewAttribute {
    self = [super init];
    if (!self) return nil;
    
    _firstViewAttribute = firstViewAttribute;
    self.layoutPriority = HDMASLayoutPriorityRequired;
    self.layoutMultiplier = 1;
    
    return self;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone __unused *)zone {
    HDMASViewConstraint *constraint = [[HDMASViewConstraint alloc] initWithFirstViewAttribute:self.firstViewAttribute];
    constraint.layoutConstant = self.layoutConstant;
    constraint.layoutRelation = self.layoutRelation;
    constraint.layoutPriority = self.layoutPriority;
    constraint.layoutMultiplier = self.layoutMultiplier;
    constraint.delegate = self.delegate;
    return constraint;
}

#pragma mark - Public

+ (NSArray *)installedConstraintsForView:(HDMAS_VIEW *)view {
    return [view.hdmas_installedConstraints allObjects];
}

#pragma mark - Private

- (void)setLayoutConstant:(CGFloat)layoutConstant {
    _layoutConstant = layoutConstant;

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
    if (self.useAnimator) {
        [self.layoutConstraint.animator setConstant:layoutConstant];
    } else {
        self.layoutConstraint.constant = layoutConstant;
    }
#else
    self.layoutConstraint.constant = layoutConstant;
#endif
}

- (void)setLayoutRelation:(NSLayoutRelation)layoutRelation {
    _layoutRelation = layoutRelation;
    self.hasLayoutRelation = YES;
}

- (BOOL)supportsActiveProperty {
    return [self.layoutConstraint respondsToSelector:@selector(isActive)];
}

- (BOOL)isActive {
    BOOL active = YES;
    if ([self supportsActiveProperty]) {
        active = [self.layoutConstraint isActive];
    }

    return active;
}

- (BOOL)hasBeenInstalled {
    return (self.layoutConstraint != nil) && [self isActive];
}

- (void)setSecondViewAttribute:(id)secondViewAttribute {
    if ([secondViewAttribute isKindOfClass:NSValue.class]) {
        [self setHdlayoutConstantWithValue:secondViewAttribute];
    } else if ([secondViewAttribute isKindOfClass:HDMAS_VIEW.class]) {
        _secondViewAttribute = [[HDMASViewAttribute alloc] initWithView:secondViewAttribute layoutAttribute:self.firstViewAttribute.layoutAttribute];
    } else if ([secondViewAttribute isKindOfClass:HDMASViewAttribute.class]) {
        HDMASViewAttribute *attr = secondViewAttribute;
        if (attr.layoutAttribute == NSLayoutAttributeNotAnAttribute) {
            _secondViewAttribute = [[HDMASViewAttribute alloc] initWithView:attr.view item:attr.item layoutAttribute:self.firstViewAttribute.layoutAttribute];;
        } else {
            _secondViewAttribute = secondViewAttribute;
        }
    } else {
        NSAssert(NO, @"attempting to add unsupported attribute: %@", secondViewAttribute);
    }
}

#pragma mark - NSLayoutConstraint multiplier proxies

- (HDMASConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");
        
        self.layoutMultiplier = multiplier;
        return self;
    };
}


- (HDMASConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");

        self.layoutMultiplier = 1.0/divider;
        return self;
    };
}

#pragma mark - HDMASLayoutPriority proxy

- (HDMASConstraint * (^)(HDMASLayoutPriority))priority {
    return ^id(HDMASLayoutPriority priority) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint priority after it has been installed");
        
        self.layoutPriority = priority;
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (HDMASConstraint * (^)(id, NSLayoutRelation))hdequalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        if ([attribute isKindOfClass:NSArray.class]) {
            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
            NSMutableArray *children = NSMutableArray.new;
            for (id attr in attribute) {
                HDMASViewConstraint *viewConstraint = [self copy];
                viewConstraint.layoutRelation = relation;
                viewConstraint.secondViewAttribute = attr;
                [children addObject:viewConstraint];
            }
            HDMASCompositeConstraint *compositeConstraint = [[HDMASCompositeConstraint alloc] initWithChildren:children];
            compositeConstraint.delegate = self.delegate;
            [self.delegate constraint:self hdShouldBeReplacedWithConstraint:compositeConstraint];
            return compositeConstraint;
        } else {
            NSAssert(!self.hasLayoutRelation || self.layoutRelation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
            self.layoutRelation = relation;
            self.secondViewAttribute = attribute;
            return self;
        }
    };
}

#pragma mark - Semantic properties

- (HDMASConstraint *)with {
    return self;
}

- (HDMASConstraint *)and {
    return self;
}

#pragma mark - attribute chaining

- (HDMASConstraint *)hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSAssert(!self.hasLayoutRelation, @"Attributes should be chained before defining the constraint relation");

    return [self.delegate constraint:self hdAddConstraintWithLayoutAttribute:layoutAttribute];
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (HDMASConstraint *)animator {
    self.useAnimator = YES;
    return self;
}

#endif

#pragma mark - debug helpers

- (HDMASConstraint * (^)(id))key {
    return ^id(id key) {
        self.hdmas_key = key;
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(HDMASEdgeInsets)insets {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
            self.layoutConstant = insets.left;
            break;
        case NSLayoutAttributeTop:
            self.layoutConstant = insets.top;
            break;
        case NSLayoutAttributeBottom:
            self.layoutConstant = -insets.bottom;
            break;
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
            self.layoutConstant = -insets.right;
            break;
        default:
            break;
    }
}

- (void)setInset:(CGFloat)inset {
    [self setInsets:(HDMASEdgeInsets){.top = inset, .left = inset, .bottom = inset, .right = inset}];
}

- (void)setOffset:(CGFloat)offset {
    self.layoutConstant = offset;
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeWidth:
            self.layoutConstant = sizeOffset.width;
            break;
        case NSLayoutAttributeHeight:
            self.layoutConstant = sizeOffset.height;
            break;
        default:
            break;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeCenterX:
            self.layoutConstant = centerOffset.x;
            break;
        case NSLayoutAttributeCenterY:
            self.layoutConstant = centerOffset.y;
            break;
        default:
            break;
    }
}

#pragma mark - HDMASConstraint

- (void)activate {
    [self install];
}

- (void)deactivate {
    [self uninstall];
}

- (void)install {
    if (self.hasBeenInstalled) {
        return;
    }
    
    if ([self supportsActiveProperty] && self.layoutConstraint) {
        self.layoutConstraint.active = YES;
        [self.firstViewAttribute.view.hdmas_installedConstraints addObject:self];
        return;
    }
    
    HDMAS_VIEW *firstLayoutItem = self.firstViewAttribute.item;
    NSLayoutAttribute firstLayoutAttribute = self.firstViewAttribute.layoutAttribute;
    HDMAS_VIEW *secondLayoutItem = self.secondViewAttribute.item;
    NSLayoutAttribute secondLayoutAttribute = self.secondViewAttribute.layoutAttribute;

    // alignment attributes must have a secondViewAttribute
    // therefore we assume that is refering to superview
    // eg make.left.equalTo(@10)
    if (!self.firstViewAttribute.isSizeAttribute && !self.secondViewAttribute) {
        secondLayoutItem = self.firstViewAttribute.view.superview;
        secondLayoutAttribute = firstLayoutAttribute;
    }
    
    HDMASLayoutConstraint *layoutConstraint
        = [HDMASLayoutConstraint constraintWithItem:firstLayoutItem
                                        attribute:firstLayoutAttribute
                                        relatedBy:self.layoutRelation
                                           toItem:secondLayoutItem
                                        attribute:secondLayoutAttribute
                                       multiplier:self.layoutMultiplier
                                         constant:self.layoutConstant];
    
    layoutConstraint.priority = self.layoutPriority;
    layoutConstraint.hdmas_key = self.hdmas_key;
    
    if (self.secondViewAttribute.view) {
        HDMAS_VIEW *closestCommonSuperview = [self.firstViewAttribute.view hdmas_closestCommonSuperview:self.secondViewAttribute.view];
        NSAssert(closestCommonSuperview,
                 @"couldn't find a common superview for %@ and %@",
                 self.firstViewAttribute.view, self.secondViewAttribute.view);
        self.installedView = closestCommonSuperview;
    } else if (self.firstViewAttribute.isSizeAttribute) {
        self.installedView = self.firstViewAttribute.view;
    } else {
        self.installedView = self.firstViewAttribute.view.superview;
    }


    HDMASLayoutConstraint *existingConstraint = nil;
    if (self.hdupdateExisting) {
        existingConstraint = [self layoutConstraintSimilarTo:layoutConstraint];
    }
    if (existingConstraint) {
        // just update the constant
        existingConstraint.constant = layoutConstraint.constant;
        self.layoutConstraint = existingConstraint;
    } else {
        [self.installedView addConstraint:layoutConstraint];
        self.layoutConstraint = layoutConstraint;
        [firstLayoutItem.hdmas_installedConstraints addObject:self];
    }
}

- (HDMASLayoutConstraint *)layoutConstraintSimilarTo:(HDMASLayoutConstraint *)layoutConstraint {
    // check if any constraints are the same apart from the only mutable property constant

    // go through constraints in reverse as we do not want to match auto-resizing or interface builder constraints
    // and they are likely to be added first.
    for (NSLayoutConstraint *existingConstraint in self.installedView.constraints.reverseObjectEnumerator) {
        if (![existingConstraint isKindOfClass:HDMASLayoutConstraint.class]) continue;
        if (existingConstraint.firstItem != layoutConstraint.firstItem) continue;
        if (existingConstraint.secondItem != layoutConstraint.secondItem) continue;
        if (existingConstraint.firstAttribute != layoutConstraint.firstAttribute) continue;
        if (existingConstraint.secondAttribute != layoutConstraint.secondAttribute) continue;
        if (existingConstraint.relation != layoutConstraint.relation) continue;
        if (existingConstraint.multiplier != layoutConstraint.multiplier) continue;
        if (existingConstraint.priority != layoutConstraint.priority) continue;

        return (id)existingConstraint;
    }
    return nil;
}

- (void)uninstall {
    if ([self supportsActiveProperty]) {
        self.layoutConstraint.active = NO;
        [self.firstViewAttribute.view.hdmas_installedConstraints removeObject:self];
        return;
    }
    
    [self.installedView removeConstraint:self.layoutConstraint];
    self.layoutConstraint = nil;
    self.installedView = nil;
    
    [self.firstViewAttribute.view.hdmas_installedConstraints removeObject:self];
}

@end
