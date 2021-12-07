//
//  UIView+HDMASAdditions.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASUtilities.h"
#import "HDMASConstraintMaker.h"
#import "HDMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating HDMASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface HDMAS_VIEW (HDMASAdditions)

/**
 *	following properties return a new HDMASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_left;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_top;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_right;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_bottom;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_leading;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_trailing;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_width;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_height;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_centerX;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_centerY;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_baseline;
@property (nonatomic, strong, readonly) HDMASViewAttribute *(^mas_attribute)(NSLayoutAttribute attr);

@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_firstBaseline;
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_leftMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_rightMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_topMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_bottomMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_leadingMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_trailingMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_centerXWithinMargins;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_centerYWithinMargins;

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuide NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdmas_safeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id hdmas_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)hdmas_closestCommonSuperview:(HDMAS_VIEW *)view;

/**
 *  Creates a HDMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created HDMASConstraints
 */
- (NSArray *)hdmas_makeConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *make))block;

/**
 *  Creates a HDMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HDMASConstraints
 */
- (NSArray *)hdmas_updateConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *make))block;

/**
 *  Creates a HDMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HDMASConstraints
 */
- (NSArray *)hdmas_remakeConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *make))block;

@end
