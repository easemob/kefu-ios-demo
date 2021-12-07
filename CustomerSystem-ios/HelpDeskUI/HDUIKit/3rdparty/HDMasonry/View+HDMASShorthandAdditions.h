//
//  UIView+HDMASShorthandAdditions.h
//  HDMasonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+HDMASAdditions.h"

#ifdef HDMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'mas_' prefixes,
 *  only enabled if HDMAS_SHORTHAND is defined
 */
@interface HDMAS_VIEW (HDMASShorthandAdditions)

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdleft;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdtop;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdright;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdbottom;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdleading;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdtrailing;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdwidth;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdheight;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdcenterX;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdcenterY;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdbaseline;
@property (nonatomic, strong, readonly) HDMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdfirstBaseline;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdlastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdleftMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdrightMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdtopMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdbottomMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdleadingMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdtrailingMargin;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdcenterXWithinMargins;
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdcenterYWithinMargins;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *hdsafeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);

#endif

- (NSArray *)hdMakeConstraints:(void(^)(HDMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(HDMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(HDMASConstraintMaker *make))block;

@end

#define HDMAS_ATTR_FORWARD(attr)  \
- (HDMASViewAttribute *)attr {    \
    return [self mas_##attr];   \
}

#define HDMAS_ATTR_FORWARD_AVAILABLE(attr, available)  \
- (HDMASViewAttribute *)attr available {    \
    return [self mas_##attr];   \
}

@implementation HDMAS_VIEW (HDMASShorthandAdditions)

HDMAS_ATTR_FORWARD(hdtop);
HDMAS_ATTR_FORWARD(hdleft);
HDMAS_ATTR_FORWARD(hdbottom);
HDMAS_ATTR_FORWARD(hdright);
HDMAS_ATTR_FORWARD(hdleading);
HDMAS_ATTR_FORWARD(hdtrailing);
HDMAS_ATTR_FORWARD(hdwidth);
HDMAS_ATTR_FORWARD(hdheight);
HDMAS_ATTR_FORWARD(hdcenterX);
HDMAS_ATTR_FORWARD(hdcenterY);
HDMAS_ATTR_FORWARD(hdbaseline);

HDMAS_ATTR_FORWARD(hdfirstBaseline);
HDMAS_ATTR_FORWARD(hdlastBaseline);

#if TARGET_OS_IPHONE || TARGET_OS_TV

HDMAS_ATTR_FORWARD(hdleftMargin);
HDMAS_ATTR_FORWARD(hdrightMargin);
HDMAS_ATTR_FORWARD(hdtopMargin);
HDMAS_ATTR_FORWARD(hdbottomMargin);
HDMAS_ATTR_FORWARD(hdleadingMargin);
HDMAS_ATTR_FORWARD(hdtrailingMargin);
HDMAS_ATTR_FORWARD(hdcenterXWithinMargins);
HDMAS_ATTR_FORWARD(hdcenterYWithinMargins);

HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideLeading, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideTrailing, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideLeft, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideRight, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideTop, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideBottom, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideWidth, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideHeight, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideCenterX, NS_AVAILABLE_IOS(11.0));
HDMAS_ATTR_FORWARD_AVAILABLE(hdsafeAreaLayoutGuideCenterY, NS_AVAILABLE_IOS(11.0));

#endif

- (HDMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self mas_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *))block {
    return [self hdmas_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *))block {
    return [self hdmas_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(HDMASConstraintMaker *))block {
    return [self hdmas_remakeConstraints:block];
}

@end

#endif
