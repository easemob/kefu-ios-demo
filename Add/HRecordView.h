//
//  HRecordView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/2.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HRecordViewDelegate;
@interface HRecordView : UIView


@property (weak, nonatomic) id<HRecordViewDelegate> delegate;

@property (strong, nonatomic) UIView *recordView;

- (instancetype)initWithFrame:(CGRect)frame mark:(NSString *)mark;

@end

// 定义录音按钮的状态的协议，聊天页面HDMessageViewController 遵守这个协议，实现下面的方法去实现录音功能。
@protocol HRecordViewDelegate <NSObject>
@optional
- (void)didHdStartRecordingVoiceAction:(UIView *)recordView;

- (void)didHdCancelRecordingVoiceAction:(UIView *)recordView;

- (void)didHdFinishRecoingVoiceAction:(UIView *)recordView;

- (void)didHdDragOutsideAction:(UIView *)recordView;

- (void)didHdDragInsideAction:(UIView *)recordView;

@end
