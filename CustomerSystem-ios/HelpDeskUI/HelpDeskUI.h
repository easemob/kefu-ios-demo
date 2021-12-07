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


#if __has_include(<HelpDesk/HelpDesk.h>)
#import <Hyphenate/Hyphenate.h>
#import <HelpDesk/HelpDesk.h>
#else
#import <HyphenateLite/HyphenateLite.h>
#import <HelpDeskLite/HelpDeskLite.h>
#endif

//#import <Hyphenate/Hyphenate.h>
//#import <HelpDesk/HelpDesk.h>

#import "HDMessageViewController.h"
#import "HDViewController.h"

#import "HDIModelCell.h"
#import "HDIModelChatCell.h"
#import "HDMessageCell.h"
#import "HDBaseMessageCell.h"
#import "HDBubbleView.h"
#import "CustomButton.h"

#import "HDChineseToPinyin.h"
#import "HDEmoji.h"
#import "HDEmotionEscape.h"
#import "HDEmotionManager.h"
#import "HDSDKHelper.h"
#import "HDCDDeviceManager.h"
#import "HDConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"
#import "UIView+FLExtension.h"
#import "NSString+HDValid.h"
#import "UIImageView+HDWebCache.h"
#import "UIViewController+HDHUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIResponder+HRouter.h"
#import "HDLocalDefine.h"


#define HDMAS_SHORTHAND_GLOBALS
#import "HDMasonry.h"

//Ext keyWord
#define kMessageExtWeChat @"weichat"
#define kMessageExtWeChat_ctrlType @"ctrlType"
#define kMessageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMessageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMessageExtWeChat_transferToHuman @"transferToHumanButtonInfo"
#define kMessageExtWeChat_ctrlType_transferToKf_HasTransfer @"hasTransfer"
#define kMessageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMessageExtWeChat_ctrlArgs_evaluationDegree @"evaluationDegree"
#define kMessageExtWeChat_ctrlType_transferToKfHint  @"TransferToKfHint"
#define kMessageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMessageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMessageExtWeChat_ctrlArgs_detail @"detail"
#define kMessageExtWeChat_ctrlArgs_summary @"summary"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define iPhoneXBottomHeight  ([UIScreen mainScreen].bounds.size.height==812?34:0)
#define kWeakSelf __weak __typeof__(self) weakSelf = self;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kHDScreenWidth [UIScreen mainScreen].bounds.size.width
#define kHDScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define fHDUserDefaults [NSUserDefaults standardUserDefaults]

#define fKeyWindow [UIApplication sharedApplication].keyWindow
#define fUserDefaults [NSUserDefaults standardUserDefaults]

@interface HelpDeskUI : NSObject

@end
