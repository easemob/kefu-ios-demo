//
//  HRecordView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/2.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDRecordViewDelegate;
@interface HDRecordView : UIView

@property (weak, nonatomic) id<HDRecordViewDelegate> delegate;

@property (strong, nonatomic) UIView *micView;

- (instancetype)initWithFrame:(CGRect)frame mark:(NSString *)mark;

@end

// 定义录音按钮的状态的协议，聊天页面HDMessageViewController 遵守这个协议，实现下面的方法去实现录音功能。
@protocol HDRecordViewDelegate <NSObject>
@optional
- (void)didHDStartRecordingVoiceAction:(UIView *)micView;

- (void)didHDCancelRecordingVoiceAction:(UIView *)micView;

- (void)didHDFinishRecoingVoiceAction:(UIView *)micView;

- (void)didHDDragOutsideAction:(UIView *)micView;

- (void)didHDDragInsideAction:(UIView *)micView;

@end
