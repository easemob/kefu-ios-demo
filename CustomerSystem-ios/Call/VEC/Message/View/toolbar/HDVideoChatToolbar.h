//
//  HDVideoChatToolbar.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDFaceView.h"
#import "HDTextView.h"
#import "HDMicView.h"
#import "HDChatBarMoreView.h"
#import "HDChatToolbarItem.h"

#define kTouchToRecord NSEaseLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define kTouchToFinish NSEaseLocalizedString(@"message.toolBar.record.send", @"loosen to send")
NS_ASSUME_NONNULL_BEGIN

@protocol HDVideoChatToolbarDelegate;
@interface HDVideoChatToolbar : UIView
@property (weak, nonatomic) id<HDVideoChatToolbarDelegate> delegate;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic, readonly) HDChatToolbarType chatBarType;

@property (nonatomic, readonly) CGFloat inputViewMaxHeight;

@property (nonatomic, readonly) CGFloat inputViewMinHeight;

@property (nonatomic, readonly) CGFloat horizontalPadding;

@property (nonatomic, readonly) CGFloat verticalPadding;

@property (strong, nonatomic) NSArray *inputViewLeftItems;

@property (strong, nonatomic) NSArray *inputViewRightItems;

@property (strong, nonatomic) HDTextView *inputTextView;

@property (strong, nonatomic) UIView *moreView;

@property (strong, nonatomic) UIView *faceView;

@property (strong, nonatomic) UIView *micView;

@property (strong, nonatomic) UIView *recordView;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  Initializa chat bar
 * @param horizontalPadding  default 8
 * @param verticalPadding    default 5
 * @param inputViewMinHeight default 36
 * @param inputViewMaxHeight default 150
 * @param type               default EMChatToolbarTypeGroup
 */
- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(HDChatToolbarType)type;

+ (CGFloat)defaultHeight;

- (void)cancelTouchRecord;

- (void)willShowBottomView:(UIView *)bottomView;
@end

@protocol HDVideoChatToolbarDelegate <NSObject>

@optional

- (void)inputTextViewDidBeginEditing:(HDTextView *)inputTextView;

- (void)inputTextViewWillBeginEditing:(HDTextView *)inputTextView;

- (void)inputTextViewDidChange:(HDTextView *)inputTextView;

- (void)didSendText:(NSString *)text;

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext;

- (void)didSendFace:(NSString *)faceLocalPath;

- (void)didStartRecordingVoiceAction:(UIView *)recordView;

- (void)didCancelRecordingVoiceAction:(UIView *)recordView;

- (void)didFinishRecoingVoiceAction:(UIView *)recordView;

- (void)didDragOutsideAction:(UIView *)recordView;

- (void)didDragInsideAction:(UIView *)recordView;
- (void)didSendMessageAction:(NSString *)text;
- (void)didSelectTakePicAction:(UIButton *)imageButton;
@required

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight;

@end
NS_ASSUME_NONNULL_END
