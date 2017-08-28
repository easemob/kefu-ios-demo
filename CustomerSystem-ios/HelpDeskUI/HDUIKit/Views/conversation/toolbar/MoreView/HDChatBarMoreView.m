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

#import "HDChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 10
#define MOREVIEW_COL 4
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

#define CHAT_LABEL_SIZE_WIDTH 50
#define CHAT_LABEL_SIZE_HEIGHT 20

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface HDChatBarMoreView ()<UIScrollViewDelegate>
{
    HDChatToolbarType _type;
    NSInteger _maxIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
//@property (nonatomic, strong) UIButton *videoButton;
//@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;
@property (nonatomic, strong) UIButton *leaveMessageButton;

@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UILabel *takeLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *videoCallLabel;
@property (nonatomic, strong) UILabel *leaveMessageLabel;

@end

@implementation HDChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    HDChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame type:(HDChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(HDChatToolbarType)type
{
    //self.backgroundColor = [UIColor clearColor];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate = self;
    [self addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 1;
    [self addSubview:_pageControl];
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_image_normal"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_image_pressed"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = MOREVIEW_BUTTON_TAG;
    [_scrollview addSubview:_photoButton];
    
    _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets, 10 + CHAT_BUTTON_SIZE, CHAT_LABEL_SIZE_WIDTH , CHAT_LABEL_SIZE_HEIGHT)];
    _photoLabel.text = NSLocalizedString(@"attach_picture", @"Picture");
    _photoLabel.font = [UIFont systemFontOfSize:10];
    _photoLabel.textAlignment = UITextAlignmentCenter;
    _photoLabel.textColor = [UIColor blackColor];
    [_scrollview addSubview:_photoLabel];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE * 1, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_takepic_normal"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_takepic_pressed"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = MOREVIEW_BUTTON_TAG + 1;
    _maxIndex = 1;
    [_scrollview addSubview:_takePicButton];
    
    _takeLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE * 1, 10 + CHAT_BUTTON_SIZE, CHAT_LABEL_SIZE_WIDTH , CHAT_LABEL_SIZE_HEIGHT)];
    _takeLabel.text = NSLocalizedString(@"attach_picture", @"Image");
    _takeLabel.font = [UIFont systemFontOfSize:10];
    _takeLabel.textAlignment = UITextAlignmentCenter;
    _takeLabel.textColor = [UIColor blackColor];
    [_scrollview addSubview:_takeLabel];

    CGRect frame = self.frame;
    frame.size.height = 160;
//    _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_audioCallButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
//    [_audioCallButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
//    [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
//    _audioCallButton.tag = MOREVIEW_BUTTON_TAG + 3;
//    [_scrollview addSubview:_audioCallButton];
//    
    _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoCallButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoCallButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/em_chat_video_normal"] forState:UIControlStateNormal];
    [_videoCallButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/em_chat_video_pressed"] forState:UIControlStateHighlighted];
    [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
    _videoCallButton.tag =MOREVIEW_BUTTON_TAG + 2;
    _maxIndex = 2;
    [_scrollview addSubview:_videoCallButton];
    
    _videoCallLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10 + CHAT_BUTTON_SIZE, CHAT_LABEL_SIZE_WIDTH , CHAT_LABEL_SIZE_HEIGHT)];
    _videoCallLabel.text = NSLocalizedString(@"attach_call_video", @"Call Video");
    _videoCallLabel.font = [UIFont systemFontOfSize:10];
    _videoCallLabel.textAlignment = NSTextAlignmentCenter;
    _videoCallLabel.textColor = [UIColor blackColor];
    [_scrollview addSubview:_videoCallLabel];
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_location_normal"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chat_location_pressed"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = MOREVIEW_BUTTON_TAG + 3;
    [_scrollview addSubview:_locationButton];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10 + CHAT_BUTTON_SIZE, CHAT_LABEL_SIZE_WIDTH , CHAT_LABEL_SIZE_HEIGHT)];
    _locationLabel.text = NSLocalizedString(@"attach_location", @"Location");
    _locationLabel.font = [UIFont systemFontOfSize:10];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.textColor = [UIColor blackColor];
    [_scrollview addSubview:_locationLabel];
    
    _leaveMessageButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_leaveMessageButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 15, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_leaveMessageButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/em_chat_phrase_normal"] forState:UIControlStateNormal];
    [_leaveMessageButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/em_chat_phrase_pressed"] forState:UIControlStateHighlighted];
    [_leaveMessageButton addTarget:self action:@selector(leaveMessageAction) forControlEvents:UIControlEventTouchUpInside];
    _leaveMessageButton.tag = MOREVIEW_BUTTON_TAG + 4;
    _maxIndex = 4;
    [_scrollview addSubview:_leaveMessageButton];
    
    _leaveMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE*2 + 15, CHAT_LABEL_SIZE_WIDTH , CHAT_LABEL_SIZE_HEIGHT)];
    _leaveMessageLabel.text = NSLocalizedString(@"leave_title", @"Note");
    _leaveMessageLabel.font = [UIFont systemFontOfSize:10];
    _leaveMessageLabel.textAlignment = NSTextAlignmentCenter;
    _leaveMessageLabel.textColor = [UIColor blackColor];
    [_scrollview addSubview:_leaveMessageLabel];
    
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)insertItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
    NSInteger page = _maxIndex/pageSize;
    NSInteger row = (_maxIndex%pageSize)/MOREVIEW_COL;
    NSInteger col = _maxIndex%MOREVIEW_COL;
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [moreButton setImage:image forState:UIControlStateNormal];
    [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = MOREVIEW_BUTTON_TAG+_maxIndex;
    [_scrollview addSubview:moreButton];
    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    if (_maxIndex >=5) {
        frame.size.height = 150;
        _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    }
    self.frame = frame;
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)updateItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title atIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
}

- (void)removeItematIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self _resetItemFromIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - private

- (void)_resetItemFromIndex:(NSInteger)index
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE) / 5;
    CGRect frame = self.frame;
    for (NSInteger i = index + 1; i<_maxIndex + 1; i++) {
        UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
            NSInteger page = moveToIndex/pageSize;
            NSInteger row = (moveToIndex%pageSize)/MOREVIEW_COL;
            NSInteger col = moveToIndex%MOREVIEW_COL;
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE * row, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
            moreButton.tag = MOREVIEW_BUTTON_TAG+moveToIndex;
            [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    _maxIndex--;
    if (_maxIndex >=5) {
        frame.size.height = 150;
    } else {
        frame.size.height = 80;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

#pragma setter
//- (void)setMoreViewColumn:(NSInteger)moreViewColumn
//{
//    if (_moreViewColumn != moreViewColumn) {
//        _moreViewColumn = moreViewColumn;
//        [self setupSubviewsForType:_type];
//    }
//}
//
//- (void)setMoreViewNumber:(NSInteger)moreViewNumber
//{
//    if (_moreViewNumber != moreViewNumber) {
//        _moreViewNumber = moreViewNumber;
//        [self setupSubviewsForType:_type];
//    }
//}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

/*
- (void)setMoreViewButtonImages:(NSArray *)moreViewButtonImages
{
    _moreViewButtonImages = moreViewButtonImages;
    if ([_moreViewButtonImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonImages count]) {
                    NSString *imageName = [_moreViewButtonImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)setMoreViewButtonHignlightImages:(NSArray *)moreViewButtonHignlightImages
{
    _moreViewButtonHignlightImages = moreViewButtonHignlightImages;
    if ([_moreViewButtonHignlightImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonHignlightImages count]) {
                    NSString *imageName = [_moreViewButtonHignlightImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
                }
            }
        }
    }
}*/

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)leaveMessageAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLeaveMessageAction:)]) {
        [_delegate moreViewLeaveMessageAction:self];
    }
}

- (void)moreAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewAtIndex:)]) {
        [_delegate moreView:self didItemInMoreViewAtIndex:button.tag-MOREVIEW_BUTTON_TAG];
    }
}

@end
