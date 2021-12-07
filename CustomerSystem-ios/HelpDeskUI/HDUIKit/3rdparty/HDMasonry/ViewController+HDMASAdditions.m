//
//  UIViewController+HDMASAdditions.m
//  HDMasonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+HDMASAdditions.h"

#ifdef HDMAS_VIEW_CONTROLLER

@implementation HDMAS_VIEW_CONTROLLER (HDMASAdditions)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (HDMASViewAttribute *)mas_topLayoutGuide {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (HDMASViewAttribute *)mas_topLayoutGuideTop {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HDMASViewAttribute *)mas_topLayoutGuideBottom {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (HDMASViewAttribute *)mas_bottomLayoutGuide {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HDMASViewAttribute *)mas_bottomLayoutGuideTop {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HDMASViewAttribute *)mas_bottomLayoutGuideBottom {
    return [[HDMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

#pragma clang diagnostic pop

@end

#endif
