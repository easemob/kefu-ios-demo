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

#import "HDRecordView.h"
#import "HDCDDeviceManager.h"
#import "HDLocalDefine.h"
#define kCoverTag 32320
@interface HDRecordView ()
{
    NSTimer *_timer;
    UIImageView *_recordAnimationView;
    UILabel *_timeLabel;
}

@property (nonatomic) int timeLength;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (strong, nonatomic) NSTimer *timerView;

@end

@implementation HDRecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDRecordView *recordView = [self appearance];
    recordView.voiceMessageAnimationImages = @[@"HelpDeskUIResource.bundle/hd_record_animate_1",@"HelpDeskUIResource.bundle/hd_record_animate_2",@"HelpDeskUIResource.bundle/hd_record_animate_3",@"HelpDeskUIResource.bundle/hd_record_animate_4",@"HelpDeskUIResource.bundle/hd_record_animate_5",@"HelpDeskUIResource.bundle/hd_record_animate_6",@"HelpDeskUIResource.bundle/hd_record_animate_7",@"HelpDeskUIResource.bundle/hd_record_animate_8",@"HelpDeskUIResource.bundle/hd_record_animate_9",@"HelpDeskUIResource.bundle/hd_record_animate_10",@"HelpDeskUIResource.bundle/hd_record_animate_11",@"HelpDeskUIResource.bundle/hd_record_animate_12",@"HelpDeskUIResource.bundle/hd_record_animate_13",@"HelpDeskUIResource.bundle/hd_record_animate_14"];
//    recordView.upCancelText = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
//    recordView.loosenCancelText = NSEaseLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 30)];
        _recordAnimationView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_record_animate_1"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                               65,
                                                               20,
                                                               10)];
        
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _timeLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - setter
- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages
{
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText
{
    _upCancelText = upCancelText;
    _timeLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    [self stopTimeTimer];
    self.timeLength = 0;
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction) userInfo:nil repeats:YES];
    _timerView = [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(setVoiceImage)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)timeTimerAction
{
    self.timeLength += 1;
    int hour = self.timeLength / 3600;
    int m = (self.timeLength - hour * 3600) / 60;
    int s = self.timeLength - hour * 3600 - m * 60;
    
 
    _timeLabel.text = [NSString stringWithFormat:@"%i", s];
    
}

- (void)stopTimeTimer
{
    if (self.timeTimer) {
        [self.timeTimer invalidate];
        self.timeTimer = nil;
        _timeLabel.text = nil;
    }
}


- (void)addCover {
    UIWindow *keyw = [UIApplication sharedApplication].keyWindow;
    UIView *cover = [[UIView alloc] initWithFrame:keyw.bounds];
    cover.tag = kCoverTag;
    [self bringSubviewToFront:cover];
    [keyw addSubview:cover];
}

- (void)removeCoverView {
     UIWindow *keyw = [UIApplication sharedApplication].keyWindow;
    UIView *coverView = [keyw viewWithTag:kCoverTag];
    [coverView removeFromSuperview];
}
-(void)recordButtonTouchUpInside
{
    [self stopTimeTimer];
    [self removeCoverView];
    [_timerView invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [self stopTimeTimer];
    [self removeCoverView];
    [_timerView invalidate];
}

-(void)recordButtonDragInside
{
//    _textLabel.text = _upCancelText;
//    _textLabel.backgroundColor = [UIColor clearColor];
}

-(void)recordButtonDragOutside
{
//    _textLabel.text = _loosenCancelText;
//    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    voiceSound = [[HDCDDeviceManager sharedInstance] hdPeekRecorderVoiceMeter];
    int index = voiceSound*[_voiceMessageAnimationImages count];
    if (index >= [_voiceMessageAnimationImages count]) {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    } else {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    }
}

@end
