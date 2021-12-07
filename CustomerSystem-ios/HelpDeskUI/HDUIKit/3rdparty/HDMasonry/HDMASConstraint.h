//
//  HDMASConstraint.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (HDMASViewConstraint) 
 *  or a group of NSLayoutConstraints (MASComposisteConstraint)
 */
@interface HDMASConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (HDMASConstraint * (^)(HDMASEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (HDMASConstraint * (^)(CGFloat inset))inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (HDMASConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (HDMASConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (HDMASConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (HDMASConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (HDMASConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (HDMASConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or HDMASLayoutPriority
 */
- (HDMASConstraint * (^)(HDMASLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to HDMASLayoutPriorityLow
 */
- (HDMASConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to HDMASLayoutPriorityMedium
 */
- (HDMASConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to HDMASLayoutPriorityHigh
 */
- (HDMASConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    HDMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HDMASConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    HDMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HDMASConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    HDMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HDMASConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HDMASConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HDMASConstraint *)and;

/**
 *	Creates a new HDMASCompositeConstraint with the called attribute and reciever
 */
- (HDMASConstraint *)hdleft;
- (HDMASConstraint *)hdtop;
- (HDMASConstraint *)hdright;
- (HDMASConstraint *)hdbottom;
- (HDMASConstraint *)hdleading;
- (HDMASConstraint *)hdtrailing;
- (HDMASConstraint *)hdwidth;
- (HDMASConstraint *)hdheight;
- (HDMASConstraint *)hdcenterX;
- (HDMASConstraint *)hdcenterY;
- (HDMASConstraint *)hdbaseline;

- (HDMASConstraint *)hdfirstBaseline;
- (HDMASConstraint *)hdlastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HDMASConstraint *)hdleftMargin;
- (HDMASConstraint *)hdrightMargin;
- (HDMASConstraint *)hdtopMargin;
- (HDMASConstraint *)hdbottomMargin;
- (HDMASConstraint *)hdleadingMargin;
- (HDMASConstraint *)hdtrailingMargin;
- (HDMASConstraint *)hdcenterXWithinMargins;
- (HDMASConstraint *)hdcenterYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (HDMASConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of hdmas_updateConstraints/hdmas_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(HDMASEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HDMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) HDMASConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for HDMASConstraint methods.
 *
 *  Defining HDMAS_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define mas_equalTo(...)                 equalTo(HDMASBoxValue((__VA_ARGS__)))
#define mas_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(HDMASBoxValue((__VA_ARGS__)))
#define mas_lessThanOrEqualTo(...)       lessThanOrEqualTo(HDMASBoxValue((__VA_ARGS__)))

#define mas_offset(...)                  valueOffset(HDMASBoxValue((__VA_ARGS__)))


#ifdef HDMAS_SHORTHAND_GLOBALS

#define equalTo(...)                     mas_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        mas_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           mas_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      mas_offset(__VA_ARGS__)

#endif


@interface HDMASConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (HDMASConstraint * (^)(id attr))mas_equalTo;
- (HDMASConstraint * (^)(id attr))mas_greaterThanOrEqualTo;
- (HDMASConstraint * (^)(id attr))mas_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (HDMASConstraint * (^)(id offset))mas_offset;

@end
