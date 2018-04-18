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
    HDRecordViewTypeTouchDown,
    HDRecordViewTypeTouchUpInside,
    HDRecordViewTypeTouchUpOutside,
    HDRecordViewTypeDragInside,
    HDRecordViewTypeDragOutside,
}HDRecordViewType;

@protocol HDRecordViewDelegate <NSObject>
@optional
- (void)didHdStartRecordingVoiceAction:(UIView *)recordView;

- (void)didHdCancelRecordingVoiceAction:(UIView *)recordView;

- (void)didHdFinishRecoingVoiceAction:(UIView *)recordView;

- (void)didHdDragOutsideAction:(UIView *)recordView;

- (void)didHdDragInsideAction:(UIView *)recordView;

@end

@interface HDRecordView : UIView

@property (weak, nonatomic) id<HDRecordViewDelegate> delegate;

@property (nonatomic) NSArray *voiceMessageAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *upCancelText UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *loosenCancelText UI_APPEARANCE_SELECTOR;

-(void)recordButtonTouchDown;
-(void)recordButtonTouchUpInside;
-(void)recordButtonTouchUpOutside;
-(void)recordButtonDragInside;
-(void)recordButtonDragOutside;

- (void)stopTimeTimer;

@end
