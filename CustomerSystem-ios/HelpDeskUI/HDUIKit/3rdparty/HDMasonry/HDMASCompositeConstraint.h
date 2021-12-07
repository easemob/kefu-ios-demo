//
//  HDMASCompositeConstraint.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HDMASConstraint.h"
#import "HDMASUtilities.h"

/**
 *	A group of HDMASConstraint objects
 */
@interface HDMASCompositeConstraint : HDMASConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child HDMASConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
