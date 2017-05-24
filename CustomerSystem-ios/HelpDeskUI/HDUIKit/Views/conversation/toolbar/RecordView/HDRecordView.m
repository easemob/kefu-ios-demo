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
    UILabel *_textLabel;
}

@end

@implementation HDRecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDRecordView *recordView = [self appearance];
    recordView.voiceMessageAnimationImages = @[@"HelpDeskUIResource.bundle/VoiceSearchFeedback001",@"HelpDeskUIResource.bundle/VoiceSearchFeedback002",@"HelpDeskUIResource.bundle/VoiceSearchFeedback003",@"HelpDeskUIResource.bundle/VoiceSearchFeedback004",@"HelpDeskUIResource.bundle/VoiceSearchFeedback005",@"HelpDeskUIResource.bundle/VoiceSearchFeedback006",@"HelpDeskUIResource.bundle/VoiceSearchFeedback007",@"HelpDeskUIResource.bundle/VoiceSearchFeedback008",@"HelpDeskUIResource.bundle/VoiceSearchFeedback009",@"HelpDeskUIResource.bundle/VoiceSearchFeedback010",@"HelpDeskUIResource.bundle/VoiceSearchFeedback011",@"HelpDeskUIResource.bundle/VoiceSearchFeedback012",@"HelpDeskUIResource.bundle/VoiceSearchFeedback013",@"HelpDeskUIResource.bundle/VoiceSearchFeedback014",@"HelpDeskUIResource.bundle/VoiceSearchFeedback015",@"HelpDeskUIResource.bundle/VoiceSearchFeedback016",@"HelpDeskUIResource.bundle/VoiceSearchFeedback017",@"HelpDeskUIResource.bundle/VoiceSearchFeedback018",@"HelpDeskUIResource.bundle/VoiceSearchFeedback019",@"HelpDeskUIResource.bundle/VoiceSearchFeedback020"];
    recordView.upCancelText = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    recordView.loosenCancelText = NSEaseLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
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
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 30)];
        _recordAnimationView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/VoiceSearchFeedback001"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
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
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    [self addCover];
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
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
    [self removeCoverView];
    [_timer invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [self removeCoverView];
    [_timer invalidate];
}

-(void)recordButtonDragInside
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
}

-(void)recordButtonDragOutside
{
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = [UIColor redColor];
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
