//
//  HDMASConstraint+Private.h
//  HDMasonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "HDMASConstraint.h"

@protocol HDMASConstraintDelegate;


@interface HDMASConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL hdupdateExisting;

/**
 *	Usually HDMASConstraintMaker but could be a parent HDMASConstraint
 */
@property (nonatomic, weak) id<HDMASConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with HDMASEdgeInsets - setInsets:
 */
- (void)setHdlayoutConstantWithValue:(NSValue *)value;

@end


@interface HDMASConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    HDMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HDMASConstraint * (^)(id, NSLayoutRelation))hdequalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (HDMASConstraint *)hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol HDMASConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A HDMASViewConstraint may turn into a HDMASCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(HDMASConstraint *)constraint hdShouldBeReplacedWithConstraint:(HDMASConstraint *)replacementConstraint;

- (HDMASConstraint *)constraint:(HDMASConstraint *)constraint hdAddConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end
