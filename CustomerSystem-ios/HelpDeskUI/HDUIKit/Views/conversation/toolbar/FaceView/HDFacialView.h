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

@class HDEmotion;
@protocol HDFacialViewDelegate

@optional
-(void)selectedFacialView:(NSString*)str;
-(void)deleteSelected:(NSString *)str;
-(void)sendFace;
-(void)sendFace:(HDEmotion *)emotion;

@end

@class HDEmotionManager;
@interface HDFacialView : UIView
{
	NSMutableArray *_faces;
}

@property (nonatomic, weak) id<HDFacialViewDelegate> delegate;

@property (strong, nonatomic, readonly) NSArray *faces;

-(void)loadFacialView:(NSArray*)emotionManagers size:(CGSize)size;

-(void)loadFacialViewWithPage:(NSInteger)page;

//-(void)loadFacialView:(int)page size:(CGSize)size;

@end
