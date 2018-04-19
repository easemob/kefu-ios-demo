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

#import "HDMicView.h"
#import "HDCDDeviceManager.h"
#import "HDLocalDefine.h"
#define kCoverTag 32320
@interface HDMicView ()
{
    NSTimer *_timer;
    UIImageView *_recordAnimationView;
    UILabel *_timeLabel;
}

@property (nonatomic) int timeLength;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (strong, nonatomic) NSTimer *timerView;

@end

@implementation HDMicView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDMicView *micView = [self appearance];
    micView.voiceMessageAnimationImages = @[@"HelpDeskUIResource.bundle/hd_record_animate_1",@"HelpDeskUIResource.bundle/hd_record_animate_2",@"HelpDeskUIResource.bundle/hd_record_animate_3",@"HelpDeskUIResource.bundle/hd_record_animate_4",@"HelpDeskUIResource.bundle/hd_record_animate_5",@"HelpDeskUIResource.bundle/hd_record_animate_6",@"HelpDeskUIResource.bundle/hd_record_animate_7",@"HelpDeskUIResource.bundle/hd_record_animate_8",@"HelpDeskUIResource.bundle/hd_record_animate_9",@"HelpDeskUIResource.bundle/hd_record_animate_10",@"HelpDeskUIResource.bundle/hd_record_animate_11",@"HelpDeskUIResource.bundle/hd_record_animate_12",@"HelpDeskUIResource.bundle/hd_record_animate_13",@"HelpDeskUIResource.bundle/hd_record_animate_14"];
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
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(timeTimerAction)
                                                    userInfo:nil
                                                     repeats:YES];
    _timerView = [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(setVoiceImage)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)timeTimerAction
{
    self.timeLength += 1;
    _timeLabel.text = [NSString stringWithFormat:@"%i", self.timeLength];
    
}

- (void)stopTimeTimer
{
    if (self.timeTimer) {
        [self.timeTimer invalidate];
        self.timeTimer = nil;
        _timeLabel.text = nil;
    }
}

-(void)recordButtonTouchUpInside
{
    [self stopTimeTimer];
    [_timerView invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [self stopTimeTimer];
    [_timerView invalidate];
}

-(void)recordButtonDragInside
{

}

-(void)recordButtonDragOutside
{

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
