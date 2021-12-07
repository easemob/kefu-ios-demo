//
//  NSArray+HDMASShorthandAdditions.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+HDMASAdditions.h"

#ifdef HDMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'mas_' prefixes,
 *  only enabled if HDMAS_SHORTHAND is defined
 */
@interface NSArray (HDMASShorthandAdditions)

- (NSArray *)hdMakeConstraints:(void(^)(HDMASConstraintMaker *make))block;
- (NSArray *)hdUpdateConstraints:(void(^)(HDMASConstraintMaker *make))block;
- (NSArray *)hdRemakeConstraints:(void(^)(HDMASConstraintMaker *make))block;

@end

@implementation NSArray (HDMASShorthandAdditions)

- (NSArray *)hdMakeConstraints:(void(^)(HDMASConstraintMaker *))block {
    return [self hdmas_makeConstraints:block];
}

- (NSArray *)hdUpdateConstraints:(void(^)(HDMASConstraintMaker *))block {
    return [self hdmas_updateConstraints:block];
}

- (NSArray *)hdRemakeConstraints:(void(^)(HDMASConstraintMaker *))block {
    return [self hdmas_remakeConstraints:block];
}

@end

#endif
