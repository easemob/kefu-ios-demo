//
//  HDRecordView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/2.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HDRecordView.h"
#define RecordViewHeight 140
#define RecordButtonHeight 56
#define PinRecord NSLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define EndOrSlide NSLocalizedString(@"recording_description", @"Release to end, finger up to cancel sending")
#define CancelRecord NSLocalizedString(@"message.toolBar.record.loosenCancel", @" loosen the fingers, to cancel sending ")
#define TimeIsTooShort NSLocalizedString(@"media.timeShort", @"record time too short")
#define NotStartedRecording NSLocalizedString(@"not_start_recording", @"Didn't start the recording")

@interface HDRecordView ()
{
    NSString *_mark;
}
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *recordLabel;

@end

@implementation HDRecordView

- (instancetype)initWithFrame:(CGRect)frame mark:(NSString *)mark
{
    self = [super initWithFrame:frame];
    if (self) {
        // 监听录音时间过短
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ListenTime) name:@"TheRecordingTimeIsTooShort" object:nil];

        _mark = mark;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    if (_mark) {
        self.frame = CGRectMake(0, self.frame.origin.y, kHDScreenWidth, RecordViewHeight);
    } else {
        self.frame = CGRectMake(0, 0, kHDScreenWidth, RecordViewHeight);
    }
    
    // label
    _recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, kHDScreenWidth, 19)];
    _recordLabel.text = PinRecord;
    _recordLabel.font = [UIFont systemFontOfSize:15];
    _recordLabel.textAlignment = NSTextAlignmentCenter;
    _recordLabel.textColor = [UIColor grayColor];
    [self addSubview:_recordLabel];
    
    // button
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(152, 53, RecordButtonHeight, RecordButtonHeight)];
    _recordButton.centerX = _recordLabel.centerX;
    [_recordButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_record_menu_mic_gray"] forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_record_menu_mic_recording"] forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    [self addSubview:_recordButton];
}

// 点触录音按钮开始录音
- (void)recordButtonTouchDown
{
    _recordLabel.text = EndOrSlide;
    if (_delegate && [_delegate respondsToSelector:@selector(didHDStartRecordingVoiceAction:)]) {
        [_delegate didHDStartRecordingVoiceAction:self.micView];
    }
}
// 在控件之外触摸抬起事件
- (void)recordButtonTouchUpOutside
{
    [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_mic_gray" andLabelText:PinRecord];
    if (_delegate && [_delegate respondsToSelector:@selector(didHDCancelRecordingVoiceAction:)])
    {
        [_delegate didHDCancelRecordingVoiceAction:self.micView];
    }
}
// 在控件之内触摸抬起事件
- (void)recordButtonTouchUpInside
{
    _recordLabel.text = PinRecord;
    if ([self.delegate respondsToSelector:@selector(didHDFinishRecoingVoiceAction:)])
    {
        [self.delegate didHDFinishRecoingVoiceAction:self.micView];
    }
    
}
// 当一次触摸从控件窗口内部拖动到外部时
- (void)recordDragOutside
{
    [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_mic_cancel" andLabelText:CancelRecord];
    if ([self.delegate respondsToSelector:@selector(didHDDragOutsideAction:)])
    {
        [self.delegate didHDDragOutsideAction:self.micView];
    }
}
// 当一次触摸从控件窗口之外拖动到内部时
- (void)recordDragInside
{
    [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_mic_gray" andLabelText:EndOrSlide];
    if ([self.delegate respondsToSelector:@selector(didHDDragInsideAction:)])
    {
        [self.delegate didHDDragInsideAction:self.micView];
    }
}

// 显示麦克风的View
- (UIView *)micView
{
    if (_micView == nil) {
        _micView = [[HDMicView alloc] initWithFrame:CGRectMake(90, kScreenHeight/2 - 40, 60, 80)];
    }
    
    return _micView;
}

- (void)ListenTime
{
    [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_too_short" andLabelText:TimeIsTooShort];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_mic_gray" andLabelText:PinRecord];
    });
}

//- (void)ListenIsRecording
//{
//    [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_too_short" andLabelText:NotStartedRecording];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setButtonImage:@"HelpDeskUIResource.bundle/hd_record_menu_mic_gray" andLabelText:PinRecord];
//    });
//}

- (void)setButtonImage:(NSString *)imageName andLabelText:(NSString *)text;
{
    [_recordButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _recordLabel.text = text;
}

@end
