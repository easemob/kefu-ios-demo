//
//  HDMASConstraintMaker.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASConstraint.h"
#import "HDMASUtilities.h"

typedef NS_OPTIONS(NSInteger, HDMASAttribute) {
    HDMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    HDMASAttributeRight = 1 << NSLayoutAttributeRight,
    HDMASAttributeTop = 1 << NSLayoutAttributeTop,
    HDMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    HDMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    HDMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    HDMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    HDMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    HDMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    HDMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    HDMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,

    HDMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    HDMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    HDMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    HDMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    HDMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    HDMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    HDMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    HDMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    HDMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    HDMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating HDMASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface HDMASConstraintMaker : NSObject

/**
 *	The following properties return a new HDMASViewConstraint
 *  with the first item set to the makers associated view and the appropriate HDMASViewAttribute
 */
@property (nonatomic, strong, readonly) HDMASConstraint *left;
@property (nonatomic, strong, readonly) HDMASConstraint *top;
@property (nonatomic, strong, readonly) HDMASConstraint *right;
@property (nonatomic, strong, readonly) HDMASConstraint *bottom;
@property (nonatomic, strong, readonly) HDMASConstraint *leading;
@property (nonatomic, strong, readonly) HDMASConstraint *trailing;
@property (nonatomic, strong, readonly) HDMASConstraint *width;
@property (nonatomic, strong, readonly) HDMASConstraint *height;
@property (nonatomic, strong, readonly) HDMASConstraint *centerX;
@property (nonatomic, strong, readonly) HDMASConstraint *centerY;
@property (nonatomic, strong, readonly) HDMASConstraint *baseline;

@property (nonatomic, strong, readonly) HDMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) HDMASConstraint *lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HDMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *topMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) HDMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) HDMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new HDMASCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  HDMASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) HDMASConstraint *(^attributes)(HDMASAttribute attrs);

/**
 *	Creates a HDMASCompositeConstraint with type HDMASCompositeConstraintTypeEdges
 *  which generates the appropriate HDMASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HDMASConstraint *edges;

/**
 *	Creates a HDMASCompositeConstraint with type HDMASCompositeConstraintTypeSize
 *  which generates the appropriate HDMASViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HDMASConstraint *size;

/**
 *	Creates a HDMASCompositeConstraint with type HDMASCompositeConstraintTypeCenter
 *  which generates the appropriate HDMASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HDMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL hdupdateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any HDMASConstraint are created with this view as the first item
 *
 *	@return	a new HDMASConstraintMaker
 */
- (id)initWithView:(HDMAS_VIEW *)view;

/**
 *	Calls install method on any HDMASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed HDMASConstraints
 */
- (NSArray *)install;

- (HDMASConstraint * (^)(dispatch_block_t))group;

@end
