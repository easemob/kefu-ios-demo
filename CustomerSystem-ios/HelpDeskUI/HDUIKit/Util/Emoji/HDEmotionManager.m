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

#import "HDEmotionManager.h"

@implementation HDEmotionManager

- (id)initWithType:(HDEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
{
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        NSMutableArray *tempEmotions = [NSMutableArray array];
        for (id name in emotions) {
            if ([name isKindOfClass:[NSString class]]) {
                HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:HDEmotionDefault];
                [tempEmotions addObject:emotion];
            }
        }
        _emotions = tempEmotions;
        _tagImage = nil;
    }
    return self;
}

- (id)initWithType:(HDEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage

{
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        _emotions = emotions;
        _tagImage = tagImage;
    }
    return self;
}

@end

@implementation HDEmotion

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(HDEmotionType)emotionType
{
    self = [super init];
    if (self) {
        _emotionTitle = emotionTitle;
        _emotionId = emotionId;
        _emotionThumbnail = emotionThumbnail;
        _emotionOriginal = emotionOriginal;
        _emotionOriginalURL = emotionOriginalURL;
        _emotionType = emotionType;
    }
    return self;
}


@end
