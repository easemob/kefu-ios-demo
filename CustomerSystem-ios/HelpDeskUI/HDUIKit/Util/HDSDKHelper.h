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


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "EMSDK.h"

#if __has_include(<HelpDesk/HelpDesk.h>)
#import <HelpDesk/HelpDesk.h>
#else
#import <HelpDeskLite/HelpDeskLite.h>
#endif

#import <HyphenateChat/HyphenateChat.h>

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"

#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"

#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface HDSDKHelper : NSObject<HDClientDelegate>

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - send message new
+ (HDMessage *)cmdMessageFormatTo:(NSString *)to action:(NSString *)action;

+ (HDMessage *)textHMessageFormatWithText:(NSString *)text
                                      to:(NSString *)toUser;

+ (HDMessage *)customMagicEmojiMessageWithOriginUrl:(NSString *)url to:(NSString *)toUser;

+ (HDMessage *)imageMessageWithImageData:(NSData *)imageData
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;

+ (HDMessage *)imageMessageWithImage:(UIImage *)image
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;

+ (HDMessage *)locationHMessageWithLatitude:(double)latitude
                                 longitude:(double)longitude
                                   address:(NSString *)address
                                        to:(NSString *)to
                                messageExt:(NSDictionary *)messageExt;

+ (HDMessage *)voiceMessageWithLocalPath:(NSString *)localPath
                               duration:(int)duration
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;


+ (HDMessage *)videoMessageWithLocalPath:(NSString *)localPath
                                     to:(NSString *)toUser
                             messageExt:(NSDictionary *)aMsgExt;

#pragma mark - call
+ (BOOL)isNSDictionary:(NSDictionary *)dic;

@end
