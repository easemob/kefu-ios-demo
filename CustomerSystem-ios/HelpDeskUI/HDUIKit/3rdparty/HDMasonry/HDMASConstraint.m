//
//  HDMASConstraint.m
//  HDMasonry
//
//  Created by Nick Tymchenko on 1/20/14.
//

#import "HDMASConstraint.h"
#import "HDMASConstraint+Private.h"

#define HDMASMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation HDMASConstraint

#pragma mark - Init

- (id)init {
	NSAssert(![self isMemberOfClass:[HDMASConstraint class]], @"HDMASConstraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}

#pragma mark - NSLayoutRelation proxies

- (HDMASConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (HDMASConstraint * (^)(id))mas_equalTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (HDMASConstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (HDMASConstraint * (^)(id))mas_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (HDMASConstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (HDMASConstraint * (^)(id))mas_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.hdequalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

#pragma mark - HDMASLayoutPriority proxies

- (HDMASConstraint * (^)(void))priorityLow {
    return ^id{
        self.priority(HDMASLayoutPriorityDefaultLow);
        return self;
    };
}

- (HDMASConstraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(HDMASLayoutPriorityDefaultMedium);
        return self;
    };
}

- (HDMASConstraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(HDMASLayoutPriorityDefaultHigh);
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant proxies

- (HDMASConstraint * (^)(HDMASEdgeInsets))insets {
    return ^id(HDMASEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (HDMASConstraint * (^)(CGFloat))inset {
    return ^id(CGFloat inset){
        self.inset = inset;
        return self;
    };
}

- (HDMASConstraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (HDMASConstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (HDMASConstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (HDMASConstraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setHdlayoutConstantWithValue:offset];
        return self;
    };
}

- (HDMASConstraint * (^)(id offset))mas_offset {
    // Will never be called due to macro
    return nil;
}

#pragma mark - NSLayoutConstraint constant setter

- (void)setHdlayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(HDMASEdgeInsets)) == 0) {
        HDMASEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

#pragma mark - Semantic properties

- (HDMASConstraint *)with {
    return self;
}

- (HDMASConstraint *)and {
    return self;
}

#pragma mark - Chaining

- (HDMASConstraint *)hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    HDMASMethodNotImplemented();
}

- (HDMASConstraint *)hdleft {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (HDMASConstraint *)hdtop {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (HDMASConstraint *)hdright {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (HDMASConstraint *)hdbottom {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (HDMASConstraint *)hdleading {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (HDMASConstraint *)hdtrailing {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (HDMASConstraint *)hdwidth {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (HDMASConstraint *)hdheight {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (HDMASConstraint *)hdcenterX {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (HDMASConstraint *)hdcenterY {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (HDMASConstraint *)hdbaseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (HDMASConstraint *)hdfirstBaseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (HDMASConstraint *)hdlastBaseline {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HDMASConstraint *)hdleftMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HDMASConstraint *)hdrightMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (HDMASConstraint *)hdtopMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (HDMASConstraint *)hdbottomMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HDMASConstraint *)hdleadingMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HDMASConstraint *)hdtrailingMargin {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HDMASConstraint *)hdcenterXWithinMargins {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HDMASConstraint *)hdcenterYWithinMargins {
    return [self hdAddConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - Abstract

- (HDMASConstraint * (^)(CGFloat multiplier))multipliedBy { HDMASMethodNotImplemented(); }

- (HDMASConstraint * (^)(CGFloat divider))dividedBy { HDMASMethodNotImplemented(); }

- (HDMASConstraint * (^)(HDMASLayoutPriority priority))priority { HDMASMethodNotImplemented(); }

- (HDMASConstraint * (^)(id, NSLayoutRelation))hdequalToWithRelation { HDMASMethodNotImplemented(); }

- (HDMASConstraint * (^)(id key))key { HDMASMethodNotImplemented(); }

- (void)setInsets:(HDMASEdgeInsets __unused)insets { HDMASMethodNotImplemented(); }

- (void)setInset:(CGFloat __unused)inset { HDMASMethodNotImplemented(); }

- (void)setSizeOffset:(CGSize __unused)sizeOffset { HDMASMethodNotImplemented(); }

- (void)setCenterOffset:(CGPoint __unused)centerOffset { HDMASMethodNotImplemented(); }

- (void)setOffset:(CGFloat __unused)offset { HDMASMethodNotImplemented(); }

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (HDMASConstraint *)animator { HDMASMethodNotImplemented(); }

#endif

- (void)activate { HDMASMethodNotImplemented(); }

- (void)deactivate { HDMASMethodNotImplemented(); }

- (void)install { HDMASMethodNotImplemented(); }

- (void)uninstall { HDMASMethodNotImplemented(); }

@end
