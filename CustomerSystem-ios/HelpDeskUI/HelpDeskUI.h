/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

#import "HDMessageViewController.h"
#import "HDViewController.h"

#import "HDIModelCell.h"
#import "HDIModelChatCell.h"
#import "HDMessageCell.h"
#import "HDBaseMessageCell.h"
#import "HDBubbleView.h"


#import "HDChineseToPinyin.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseEmotionManager.h"
#import "HDSDKHelper.h"
#import "EMCDDeviceManager.h"
#import "HDConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"
#import "NSString+Valid.h"
#import "UIImageView+EMWebCache.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "HDLocalDefine.h"

@interface HelpDeskUI : NSObject

@end
