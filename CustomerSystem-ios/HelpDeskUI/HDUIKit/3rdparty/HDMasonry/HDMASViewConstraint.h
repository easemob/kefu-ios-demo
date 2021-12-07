//
//  HDMASViewConstraint.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASViewAttribute.h"
#import "HDMASConstraint.h"
#import "HDMASLayoutConstraint.h"
#import "HDMASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface HDMASViewConstraint : HDMASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HDMASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HDMASViewAttribute *secondViewAttribute;

/**
 *	initialises the HDMASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.mas_left, view.mas_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(HDMASViewAttribute *)firstViewAttribute;

/**
 *  Returns all HDMASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of HDMASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(HDMAS_VIEW *)view;

@end
