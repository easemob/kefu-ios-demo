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

#import "HDChatToolbar.h"
#import "HDFaceView.h"
#import "HDEmoji.h"
#import "HDEmotionEscape.h"
#import "HDEmotionManager.h"
#import "HDLocalDefine.h"
#import "HDRecordView.h"
#import "HDEmotionEscape.h"


@interface HDChatToolbar()<UITextViewDelegate, HDFaceDelegate>

@property (strong, nonatomic) NSMutableArray *leftItems;
@property (strong, nonatomic) NSMutableArray *rightItems;
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *activityButtomView;
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;
@property (nonatomic) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height

@end

@implementation HDChatToolbar

@synthesize faceView = _faceView;
@synthesize moreView = _moreView;
@synthesize micView = _micView;
@synthesize recordView = _recordView;

- (instancetype)initWithFrame:(CGRect)frame

{
    self = [self initWithFrame:frame horizontalPadding:8 verticalPadding:5 inputViewMinHeight:36 inputViewMaxHeight:150 type:HDChatToolbarTypeChat];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(HDChatToolbarType)type
{
    if (frame.size.height < (verticalPadding * 2 + inputViewMinHeight)) {
        frame.size.height = verticalPadding * 2 + inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _horizontalPadding = horizontalPadding;
        _verticalPadding = verticalPadding;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;
        _chatBarType = type;
        
        _leftItems = [NSMutableArray array];
        _rightItems = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self _setupSubviews];
    }
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubviews
{
    //backgroundImageView
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    _backgroundImageView.image = [[UIImage imageNamed:@"HelpDeskUIResource.bundle/messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:_backgroundImageView];
    
    //toolbar
    _toolbarView = [[UIView alloc] initWithFrame:self.bounds];
    _toolbarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolbarView];
    
    _toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _toolbarView.frame.size.width, _toolbarView.frame.size.height)];
    _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
    [_toolbarView addSubview:_toolbarBackgroundImageView];
    
    //input textview
    _inputTextView = [[HDTextView alloc] initWithFrame:CGRectMake(self.horizontalPadding, self.verticalPadding*2, self.frame.size.width - self.verticalPadding * 2, self.frame.size.height - self.verticalPadding * 2)];
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = NSEaseLocalizedString(@"message.toolBar.inputPlaceHolder", @"input a new message");
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _previousTextViewContentHeight = [self _getTextViewContentH:_inputTextView];
    [_toolbarView addSubview:_inputTextView];
    
    //change input type
    UIButton *styleChangeButton = [[UIButton alloc] init];
    styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [styleChangeButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    [styleChangeButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_setmode_keyboard_btn_normal"] forState:UIControlStateSelected];
    [styleChangeButton addTarget:self action:@selector(styleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 把录音按钮和自定义的录音按钮所在的控件newRecordView传进去，从而显示自己的view
    HDChatToolbarItem *styleItem = [[HDChatToolbarItem alloc] initWithButton:styleChangeButton withView:self.recordView];
    [self setInputViewLeftItems:@[styleItem]];
    
    //emoji
    self.faceButton = [[UIButton alloc] init];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_biaoqing_btn_normal"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_setmode_keyboard_btn_normal"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    HDChatToolbarItem *faceItem = [[HDChatToolbarItem alloc] initWithButton:self.faceButton withView:self.faceView];
    
    //more
    self.moreButton = [[UIButton alloc] init];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.moreButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_type_select_btn_nor"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_type_less_btn_nor"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    HDChatToolbarItem *moreItem = [[HDChatToolbarItem alloc] initWithButton:self.moreButton withView:self.moreView];
    
    [self setInputViewRightItems:@[faceItem, moreItem]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIView *)micView
{
    if (!_micView) {
        _micView = [[HDMicView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _micView;
}

- (UIView *)faceView
{
    if (_faceView == nil) {
        _faceView = [[HDFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 180)];
        [(HDFaceView *)_faceView setDelegate:self];
        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _faceView;
}

- (UIView *)moreView
{
    if (_moreView == nil) {
        _moreView = [[HDChatBarMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 80) type:self.chatBarType];
        _moreView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _moreView;
}

- (UIView *)recordView
{
    if (_recordView == nil) {
        _recordView = [[HDRecordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 80) mark:nil];
        _recordView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
        _recordView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _recordView;
}

#pragma mark - setter

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    if ([_moreView isKindOfClass:[HDChatBarMoreView class]]) {
        [(HDChatBarMoreView *)_moreView setDelegate:delegate];
    }
}

- (void)setRecordView:(UIView *)micView
{
    if(_micView != micView){
        _micView = micView;
    }
}

- (void)setMoreView:(UIView *)moreView
{
    if (_moreView != moreView) {
        _moreView = moreView;
        
        for (HDChatToolbarItem *item in self.rightItems) {
            if (item.button == self.moreButton) {
                item.button2View = _moreView;
                break;
            }
        }
    }
}

- (void)recordView:(UIView *)recordView
{
    if ( _recordView!= recordView) {
        _recordView = recordView;
        
        for (HDChatToolbarItem *item in self.leftItems) {
            if (item.button == _recordView) {
                item.button2View = _recordView;
                break;
            }
        }
    }
}

- (void)setFaceView:(UIView *)faceView
{
    if (_faceView != faceView) {
        _faceView = faceView;
        
        for (HDChatToolbarItem *item in self.rightItems) {
            if (item.button == self.faceButton) {
                item.button2View = _faceView;
                break;
            }
        }
    }
}

- (NSArray*)inputViewLeftItems
{
    return self.leftItems;
}

- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems
{
    for (HDChatToolbarItem *item in self.leftItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    
    CGFloat oX = self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;
    for (id item in inputViewLeftItems) {
        if ([item isKindOfClass:[HDChatToolbarItem class]]) {
            HDChatToolbarItem *chatItem = (HDChatToolbarItem *)item;
            if (chatItem.button) {
                CGRect itemFrame = chatItem.button.frame;
                if (itemFrame.size.height == 0) {
                    itemFrame.size.height = itemHeight - 10;
                }
                
                if (itemFrame.size.width == 0) {
                    itemFrame.size.width = itemFrame.size.height - 5;
                }
                
                itemFrame.origin.x = oX;
                itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                chatItem.button.frame = itemFrame;
                oX += (itemFrame.size.width + self.horizontalPadding);
                
                [self.toolbarView addSubview:chatItem.button];
                [self.leftItems addObject:chatItem];
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = inputFrame.origin.x - oX;
    inputFrame.origin.x = oX;
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
    
    CGRect recordFrame = self.recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    self.recordButton.frame = recordFrame;
}

- (NSArray*)inputViewRightItems
{
    return self.rightItems;
}

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems
{
    for (HDChatToolbarItem *item in self.rightItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.rightItems removeAllObjects];
    
    CGFloat oMaxX = self.toolbarView.frame.size.width - self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;
    if ([inputViewRightItems count] > 0) {
        for (NSInteger i = (inputViewRightItems.count - 1); i >= 0; i--) {
            id item = [inputViewRightItems objectAtIndex:i];
            if ([item isKindOfClass:[HDChatToolbarItem class]]) {
                HDChatToolbarItem *chatItem = (HDChatToolbarItem *)item;
                if (chatItem.button) {
                    CGRect itemFrame = chatItem.button.frame;
                    if (itemFrame.size.height == 0) {
                        itemFrame.size.height = itemHeight - 10;
                    }
                    
                    if (itemFrame.size.width == 0) {
                        itemFrame.size.width = itemFrame.size.height - 5;
                    }
                    
                    oMaxX -= itemFrame.size.width;
                    itemFrame.origin.x = oMaxX - 3;
                    itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                    chatItem.button.frame = itemFrame;
                    oMaxX -= self.horizontalPadding;
                    
                    [self.toolbarView addSubview:chatItem.button];
                    [self.rightItems addObject:item];
                }
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = oMaxX - CGRectGetMaxX(inputFrame);
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
    
    CGRect recordFrame = self.recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    self.recordButton.frame = recordFrame;
}

#pragma mark - private input view

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < self.inputViewMinHeight) {
        toHeight = self.inputViewMinHeight;
    }
    if (toHeight > self.inputViewMaxHeight) {
        toHeight = self.inputViewMaxHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
            [_delegate chatToolbarDidChangeFrameToHeight:self.frame.size.height];
        }
    }
}

#pragma mark - private bottom view

- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
        [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
    }
}

- (void)_willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self _willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self _willShowBottomHeight:toFrame.size.height-iPhoneXBottomHeight];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self _willShowBottomHeight:0];
    }
    else{
        [self _willShowBottomHeight:toFrame.size.height - iPhoneXBottomHeight];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    for (HDChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    for (HDChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
#pragma mark smallpngface
            NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.inputTextView.attributedText.string];
            [_inputTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                      inRange:NSMakeRange(0, self.inputTextView.attributedText.length)
                                                      options:NSAttributedStringEnumerationReverse
                                                   usingBlock:^(id value, NSRange range, BOOL *stop)
             {
                 if (value) {
                     HDTextAttachment *attachment = (HDTextAttachment*)value;
                     NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
                     
                     [attStr replaceCharactersInRange:range withString:str];
                 }
             }];
            
            [self.delegate didSendText:attStr];
            self.inputTextView.text = @"";
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
    if (_delegate && [_delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
        [_delegate inputTextViewDidChange:self.inputTextView];
    }
    
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.inputTextView.text;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    
    
    if (!isDelete && str.length > 0) {
        NSRange range = [self.inputTextView selectedRange];
        [attr insertAttributedString:[[HDEmotionEscape sharedInstance] attStringFromTextForInputView:str textFont:self.inputTextView.font] atIndex:range.location];
        self.inputTextView.attributedText = attr;
    }
    else {
        if (chatText.length > 0) {
            NSInteger length = 1;
            if (chatText.length >= 2) {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([HDEmoji stringContainsEmoji:subStr]) {
                    length = 2;
                }
            }
            self.inputTextView.attributedText = [self backspaceText:attr length:length];
        }
    }
    
    [self textViewDidChange:self.inputTextView];
}

-(NSMutableAttributedString*)backspaceText:(NSMutableAttributedString*) attr length:(NSInteger)length
{
    NSRange range = [self.inputTextView selectedRange];
    if (range.location == 0) {
        return attr;
    }
    [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
    return attr;
}

- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            
            if (![_inputTextView.text isEqualToString:@""]) {
                
                //转义回来
                NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.inputTextView.attributedText.string];
                [_inputTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                          inRange:NSMakeRange(0, self.inputTextView.attributedText.length)
                                                          options:NSAttributedStringEnumerationReverse
                                                       usingBlock:^(id value, NSRange range, BOOL *stop)
                 {
                     if (value) {
                         HDTextAttachment* attachment = (HDTextAttachment*)value;
                         NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
                         [attStr replaceCharactersInRange:range withString:str];
                     }
                 }];
                [self.delegate didSendText:attStr];
                self.inputTextView.text = @"";
                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
            }
        }
    }
}

- (void)sendFaceWithEmotion:(HDEmotion *)emotion
{
    if (emotion) {
        if ([self.delegate respondsToSelector:@selector(didSendText:withExt:)]) {
            [self.delegate didSendText:emotion.emotionTitle withExt:@{EASEUI_EMOTION_DEFAULT_EXT:emotion}];
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
        }
    }
}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - action

// 修改 录音按钮的点击事件
- (void)styleButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;

    
    HDChatToolbarItem *styleItem = nil;
    for (HDChatToolbarItem *item in self.leftItems) {
        if (item.button == button){
            styleItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    for (HDChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self _willShowBottomView:styleItem.button2View];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordButton.hidden = button.selected;
            self.inputTextView.hidden = !button.selected;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
    
}

- (void)faceButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    HDChatToolbarItem *faceItem = nil;
    for (HDChatToolbarItem *item in self.rightItems) {
        if (item.button == button){
            faceItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    for (HDChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self _willShowBottomView:faceItem.button2View];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordButton.hidden = button.selected;
            self.inputTextView.hidden = !button.selected;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
}

- (void)moreButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    HDChatToolbarItem *moreItem = nil;
    for (HDChatToolbarItem *item in self.rightItems) {
        if (item.button == button){
            moreItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    for (HDChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self _willShowBottomView:moreItem.button2View];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordButton.hidden = button.selected;
            self.inputTextView.hidden = !button.selected;
        } completion:nil];
    }
    else
    {
        [self.inputTextView becomeFirstResponder];
    }
}


#pragma mark - public

+ (CGFloat)defaultHeight
{
    return 5 * 2 + 46;
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    for (HDChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    for (HDChatToolbarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    [self _willShowBottomView:nil];
    
    return result;
}

- (void)cancelTouchRecord
{
    if ([_micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)_micView recordButtonTouchUpInside];
        [_micView removeFromSuperview];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    [self _willShowBottomView:bottomView];
}

@end
