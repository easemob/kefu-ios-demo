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

typedef enum{
    HDChatToolbarTypeChat,
    HDChatToolbarTypeGroup,
}HDChatToolbarType;

@protocol HDChatBarMoreViewDelegate;
@interface HDChatBarMoreView : UIView

@property (nonatomic,assign) id<HDChatBarMoreViewDelegate> delegate;

@property (nonatomic) UIColor *moreViewBackgroundColor UI_APPEARANCE_SELECTOR;  //moreview背景颜色,default whiteColor

- (instancetype)initWithFrame:(CGRect)frame type:(HDChatToolbarType)type;

- (void)insertItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title;

- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;

- (void)removeItematIndex:(NSInteger)index;

@end

@protocol HDChatBarMoreViewDelegate <NSObject>

@optional

- (void)moreViewTakePicAction:(HDChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(HDChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(HDChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(HDChatBarMoreView *)moreView;
- (void)moreViewVideoCallAction:(HDChatBarMoreView *)moreView;
- (void)moreViewLeaveMessageAction:(HDChatBarMoreView *)moreView;
- (void)moveViewEvaluationAction:(HDChatBarMoreView *)moreView;
- (void)moreView:(HDChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index;

@end
