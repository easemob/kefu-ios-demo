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

#import "HDFacialView.h"

@protocol HDFaceDelegate

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;
- (void)sendFaceWithEmotion:(HDEmotion *)emotion;

@end

@interface HDFaceView : UIView <HDFacialViewDelegate>

@property (nonatomic, assign) id<HDFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

- (void)setEmotionManagers:(NSArray*)emotionManagers;

@end
