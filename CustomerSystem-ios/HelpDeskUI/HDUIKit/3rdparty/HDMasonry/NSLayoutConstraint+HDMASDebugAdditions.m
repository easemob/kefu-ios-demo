//
//  NSLayoutConstraint+HDMASDebugAdditions.m
//  HDMasonry
//
//  Created by Jonas Budelmann on 3/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSLayoutConstraint+HDMASDebugAdditions.h"
#import "HDMASConstraint.h"
#import "HDMASLayoutConstraint.h"

@implementation NSLayoutConstraint (HDMASDebugAdditions)

#pragma mark - description maps

+ (NSDictionary *)hdlayoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)hdlayoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"hdtop",
            @(NSLayoutAttributeLeft)     : @"hdleft",
            @(NSLayoutAttributeBottom)   : @"hdbottom",
            @(NSLayoutAttributeRight)    : @"hdright",
            @(NSLayoutAttributeLeading)  : @"hdleading",
            @(NSLayoutAttributeTrailing) : @"hdtrailing",
            @(NSLayoutAttributeWidth)    : @"hdwidth",
            @(NSLayoutAttributeHeight)   : @"hdheight",
            @(NSLayoutAttributeCenterX)  : @"hdcenterX",
            @(NSLayoutAttributeCenterY)  : @"hdcenterY",
            @(NSLayoutAttributeBaseline) : @"hdbaseline",
            @(NSLayoutAttributeFirstBaseline) : @"hdfirstBaseline",
            @(NSLayoutAttributeLastBaseline) : @"hdlastBaseline",

#if TARGET_OS_IPHONE || TARGET_OS_TV
            @(NSLayoutAttributeLeftMargin)           : @"hdleftMargin",
            @(NSLayoutAttributeRightMargin)          : @"hdrightMargin",
            @(NSLayoutAttributeTopMargin)            : @"hdtopMargin",
            @(NSLayoutAttributeBottomMargin)         : @"hdbottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"hdleadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"hdtrailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"hdcenterXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"hdcenterYWithinMargins",
#endif
            
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)hdlayoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE || TARGET_OS_TV
        descriptionMap = @{
            @(HDMASLayoutPriorityDefaultHigh)      : @"hdhigh",
            @(HDMASLayoutPriorityDefaultLow)       : @"hdlow",
            @(HDMASLayoutPriorityDefaultMedium)    : @"hdmedium",
            @(HDMASLayoutPriorityRequired)         : @"hdrequired",
            @(HDMASLayoutPriorityFittingSizeLevel) : @"hdfitting size",
        };
#elif TARGET_OS_MAC
        descriptionMap = @{
            @(HDMASLayoutPriorityDefaultHigh)                 : @"hdhigh",
            @(HDMASLayoutPriorityDragThatCanResizeWindow)     : @"hddrag can resize window",
            @(HDMASLayoutPriorityDefaultMedium)               : @"hdmedium",
            @(HDMASLayoutPriorityWindowSizeStayPut)           : @"hdwindow size stay put",
            @(HDMASLayoutPriorityDragThatCannotResizeWindow)  : @"hddrag cannot resize window",
            @(HDMASLayoutPriorityDefaultLow)                  : @"hdlow",
            @(HDMASLayoutPriorityFittingSizeCompression)      : @"hdfitting size",
            @(HDMASLayoutPriorityRequired)                    : @"hdrequired",
        };
#endif
    });
    return descriptionMap;
}

#pragma mark - description override

+ (NSString *)descriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(hdmas_key)] && [obj hdmas_key]) {
        return [NSString stringWithFormat:@"%@:%@", [obj class], [obj hdmas_key]];
    }
    return [NSString stringWithFormat:@"%@:%p", [obj class], obj];
}

- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"<"];

    [description appendString:[self.class descriptionForObject:self]];

    [description appendFormat:@" %@", [self.class descriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.hdlayoutAttributeDescriptionsByValue[@(self.firstAttribute)]];
    }

    [description appendFormat:@" %@", self.class.hdlayoutRelationDescriptionsByValue[@(self.relation)]];

    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class descriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.hdlayoutAttributeDescriptionsByValue[@(self.secondAttribute)]];
    }
    
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
        }
    }

    if (self.priority != HDMASLayoutPriorityRequired) {
        [description appendFormat:@" ^%@", self.class.hdlayoutPriorityDescriptionsByValue[@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];
    }

    [description appendString:@">"];
    return description;
}

@end
