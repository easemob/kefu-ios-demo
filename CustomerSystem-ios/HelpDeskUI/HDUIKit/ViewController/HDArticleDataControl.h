//
//  HDMessageVCDataControl.h
//  CustomerSystem-ios
//
//  Created by afanda on 8/4/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTitleFontSize 15
#define kProfileFontSize 12
#define kTopMargin 10
#define kLeftMargin 10
#define kTitleImageHeight 180
#define kTitleFontSize 15
#define kTimeFontSize 10
#define kDigistFontSize 10
#define kMarginNormal 10


@interface HDArticleDataControl : NSObject

/**
 是否是图文消息
 */
+ (BOOL)isArticleMessage:(HMessage *)message;


@end
