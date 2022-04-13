//
//  UIView+HDMASAdditions.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/2/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "UIView+HDMASAdditions.h"
@implementation UIView (HDMASAdditions)

- (NSArray *)hdmas_updateConstraints:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block{
    
    
    return [self mas_updateConstraints:block];
    
}

/**
 *  Creates a HDMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created HDMASConstraints
 */
- (NSArray *)hdmas_makeConstraints:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block{
    
    return [self mas_makeConstraints:block];
}

/**
 *  Creates a HDMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HDMASConstraints
 */
- (NSArray *)hdmas_remakeConstraints:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block{
    
    return [self mas_remakeConstraints:block];
}
@end
