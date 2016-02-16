//
//  EaseMessageToolBar.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/11/9.
//  Copyright © 2015年 easemob. All rights reserved.
//

#import "EaseMessageToolBar.h"

#import "DXQuestionView.h"

@interface EaseMessageToolBar () <DXQuestionViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (strong, nonatomic) UIButton *questionButton;

@property (strong, nonatomic) UIView *questionView;

@end

@implementation EaseMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame horizontalPadding:horizontalPadding verticalPadding:verticalPadding inputViewMinHeight:inputViewMinHeight inputViewMaxHeight:inputViewMaxHeight type:type];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    //转变输入样式
    self.questionButton = [[UIButton alloc] init];
    self.questionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.questionButton setImage:[UIImage imageNamed:@"chatBar_question"] forState:UIControlStateNormal];
    [self.questionButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.questionButton addTarget:self action:@selector(questionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.questionButton.tag = 2;
    EaseChatToolbarItem *question = [[EaseChatToolbarItem alloc] initWithButton:self.questionButton withView:nil];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.inputViewLeftItems];
    [array insertObject:question atIndex:0];
//    [self setInputViewLeftItems:array];
    
    if (!self.questionView) {
        self.questionView = [[DXQuestionView alloc] initWithFrame:CGRectMake(0, (self.verticalPadding * 2 + self.inputViewMinHeight), self.frame.size.width, 240)];
        [(DXQuestionView *)self.questionView setDelegate:self];
        self.questionView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1.0];
        self.questionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    self.questionButton.selected = NO;
    return result;
}

#pragma mark - action

- (void)questionButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        [self willShowBottomView:self.questionView];
    } else{
        //键盘也算一种底部扩展页面
        [self.inputTextView becomeFirstResponder];
    }
}

#pragma mark - DXQuestionViewDelegate

- (void)questionViewSeletedTitle:(NSString *)title
{
    if ([title length] > 0) {
        [self.inputTextView becomeFirstResponder];
        self.inputTextView.text = title;
        [self.inputTextView layoutIfNeeded];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
