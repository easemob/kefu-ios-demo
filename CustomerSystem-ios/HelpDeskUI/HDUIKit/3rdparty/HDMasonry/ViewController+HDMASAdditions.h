//
//  UIViewController+HDMASAdditions.h
//  HDMasonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "HDMASUtilities.h"
#import "HDMASConstraintMaker.h"
#import "HDMASViewAttribute.h"

#ifdef HDMAS_VIEW_CONTROLLER

@interface HDMAS_VIEW_CONTROLLER (HDMASAdditions)

/**
 *	following properties return a new HDMASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_topLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_bottomLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_topLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_topLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_bottomLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) HDMASViewAttribute *mas_bottomLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);

@end

#endif
