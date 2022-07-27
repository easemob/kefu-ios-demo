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

#define EASEUI_EMOTION_DEFAULT_EXT @"em_emotion"

#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"em_is_big_expression"
#define MESSAGE_ATTR_EXPRESSION_ID @"em_expression_id"

typedef NS_ENUM(NSUInteger, HDEmotionType) {
    HDEmotionDefault = 0,
    HDEmotionPng,
    HDEmotionGif
};

@interface HDEmotionManager : NSObject

@property (nonatomic, strong) NSArray *emotions;

@property (nonatomic, strong) NSString *emotionName;

/*!
 @property
 @brief number of lines of emotion
 */
@property (nonatomic, assign) NSInteger emotionRow;

/*!
 @property
 @brief number of columns of emotion
 */
@property (nonatomic, assign) NSInteger emotionCol;

/*!
 @property
 @brief emotion type
 */
@property (nonatomic, assign) HDEmotionType emotionType;

@property (nonatomic, strong) UIImage *tagImage;

- (id)initWithType:(HDEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions;

- (id)initWithType:(HDEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage;

@end

@interface HDEmotion : NSObject

@property (nonatomic, assign) HDEmotionType emotionType;

@property (nonatomic, copy) NSString *emotionTitle;

@property (nonatomic, copy) NSString *emotionId;

@property (nonatomic, copy) NSString *emotionThumbnail;

@property (nonatomic, copy) NSString *emotionOriginal;

@property (nonatomic, copy) NSString *emotionOriginalURL;

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(HDEmotionType)emotionType;

@end
