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
#import <UIKit/UIKit.h>

@interface HDEmotionEscape : NSObject

+ (HDEmotionEscape *)sharedInstance;

+ (NSMutableAttributedString *) attributtedStringFromText:(NSString *) aInputText;

+ (NSAttributedString *) attStringFromTextForChatting:(NSString *) aInputText;

+ (NSAttributedString *) attStringFromTextForInputView:(NSString *) aInputText;

- (NSAttributedString *) attStringFromTextForChatting:(NSString *) aInputText textFont:(UIFont*)font;

- (NSAttributedString *) attStringFromTextForInputView:(NSString *) aInputText textFont:(UIFont*)font;

- (void) setEaseEmotionEscapePattern:(NSString*)pattern;

- (void) setEaseEmotionEscapeDictionary:(NSDictionary*)dict;

@end

@interface HDTextAttachment : NSTextAttachment

@property(nonatomic, strong) NSString *imageName;

@end
