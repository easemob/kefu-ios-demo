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

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"

#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"

#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface HDSDKHelper : NSObject<HChatClientDelegate>

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - send message new
+ (HMessage *)cmdMessageFormatTo:(NSString *)to;

+ (HMessage *)textHMessageFormatWithText:(NSString *)text
                                      to:(NSString *)toUser;

+ (HMessage *)imageMessageWithImageData:(NSData *)imageData
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;

+ (HMessage *)imageMessageWithImage:(UIImage *)image
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;

+ (HMessage *)locationHMessageWithLatitude:(double)latitude
                                 longitude:(double)longitude
                                   address:(NSString *)address
                                        to:(NSString *)to
                                messageExt:(NSDictionary *)messageExt;

+ (HMessage *)voiceMessageWithLocalPath:(NSString *)localPath
                               duration:(NSInteger)duration
                                     to:(NSString *)to
                             messageExt:(NSDictionary *)messageExt;

+ (HMessage *)videoMessageWithURL:(NSURL *)url
                               to:(NSString *)to
                       messageExt:(NSDictionary *)messageExt;


#pragma mark - call

@end
