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


#import "HDFaceView.h"

#import "HDEmotionManager.h"
#import "HDLocalDefine.h"

#define kButtomNum 5

@interface HDFaceView ()
{
    UIScrollView *_bottomScrollView;
    NSInteger _currentSelectIndex;
    NSArray *_emotionManagers;
    UIButton *_sendButton;
}

@property (nonatomic, strong) HDFacialView *facialView;

@end

@implementation HDFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.facialView];
        [self _setupButtom];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self reloadEmotionData];
    }
}

#pragma mark - private

- (HDFacialView*)facialView
{
    if (_facialView == nil) {
        _facialView = [[HDFacialView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
        _facialView.delegate = self;
    }
    return _facialView;
}

- (void)_setupButtom
{
    _currentSelectIndex = 1000;
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(_facialView.frame), 4 * CGRectGetWidth(_facialView.frame)/5, self.frame.size.height - CGRectGetHeight(_facialView.frame))];
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self addSubview:_bottomScrollView];
    [self _setupButtonScrollView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake((kButtomNum-1)*CGRectGetWidth(_facialView.frame)/kButtomNum, CGRectGetMaxY(_facialView.frame), CGRectGetWidth(_facialView.frame)/kButtomNum, CGRectGetHeight(_bottomScrollView.frame));
    [_sendButton setBackgroundColor:RGBACOLOR(184, 22, 22, 1)];
    [_sendButton setTitle:NSEaseLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

- (void)_setupButtonScrollView
{
    NSInteger number = [_emotionManagers count];
    if (number <= 1) {
        return;
    }
    
    for (UIView *view in [_bottomScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < number; i++) {
        UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultButton.titleLabel.font = [UIFont systemFontOfSize:10];
        defaultButton.frame = CGRectMake(i * CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), 0, CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), CGRectGetHeight(_bottomScrollView.frame));
        HDEmotionManager *emotionManager = [_emotionManagers objectAtIndex:i];
        if (emotionManager.emotionType == HDEmotionDefault) {
            HDEmotion *emotion = [emotionManager.emotions objectAtIndex:0];
            [defaultButton setTitle:emotion.emotionThumbnail forState:UIControlStateNormal];
        }  else {
            [defaultButton setTitle:emotionManager.emotionName forState:UIControlStateNormal];
        }
        [defaultButton setBackgroundColor:[UIColor clearColor]];
        defaultButton.layer.borderWidth = 0.5;
        defaultButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [defaultButton addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        defaultButton.tag = 1000 + i;
        [_bottomScrollView addSubview:defaultButton];
    }
    [_bottomScrollView setContentSize:CGSizeMake(number*CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), CGRectGetHeight(_bottomScrollView.frame))];
    
    [self reloadEmotionData];
}

- (void)_clearupButtomScrollView
{
    for (UIView *view in [_bottomScrollView subviews]) {
        [view removeFromSuperview];
    }
}

#pragma mark - action

- (void)didSelect:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    UIButton *lastBtn = (UIButton*)[_bottomScrollView viewWithTag:_currentSelectIndex];
    lastBtn.selected = NO;
    
    _currentSelectIndex = btn.tag;
    btn.selected = YES;
    NSInteger index = btn.tag - 1000;
    [_facialView loadFacialViewWithPage:index];
}

- (void)reloadEmotionData
{
    NSInteger index = _currentSelectIndex - 1000;
    if (index < [_emotionManagers count]) {
        [_facialView loadFacialView:_emotionManagers size:CGSizeMake(30, 30)];
    }
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
//    [_sendButton setBackgroundColor:RGBACOLOR(184, 22, 22, 1)];
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
//    [_sendButton setBackgroundColor:RGBACOLOR(216, 216, 216, 1)];
    if (_delegate) {
        [_delegate sendFace];
    }
}

- (void)sendFace:(HDEmotion *)emotion
{
    if (_delegate) {
        [_delegate sendFaceWithEmotion:emotion];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}

- (void)setEmotionManagers:(NSArray *)emotionManagers
{
    _emotionManagers = emotionManagers;
    for (HDEmotionManager *emotionManager in _emotionManagers) {
        if (emotionManager.emotionType != HDEmotionGif) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:emotionManager.emotions];
            NSInteger maxRow = emotionManager.emotionRow;
            NSInteger maxCol = emotionManager.emotionCol;
            NSInteger count = 1;
            while (1) {
                NSInteger index = maxRow * maxCol * count - 1;
                if (index >= [array count]) {
                    [array addObject:@""];
                    break;
                } else {
                    [array insertObject:@"" atIndex:index];
                }
                count++;
            }
            emotionManager.emotions = array;
        }
    }
    [self _setupButtonScrollView];
}


@end
