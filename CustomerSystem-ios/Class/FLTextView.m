//
//  FLTextView.m
//  FLTextView
//
//  Created by afanda on 16/7/29.
//  Copyright © 2016年 afanda All rights reserved.
//

#import "FLTextView.h"



@interface FLTextView ()<UITextViewDelegate>


@property(nonatomic,strong) UILabel *placeholderLabel;

@end

@implementation FLTextView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 2, 100, 25)];
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.backgroundColor = [UIColor whiteColor];
        _placeholderLabel.textColor = _placeholderTextColor;
        _placeholderLabel.font = [UIFont systemFontOfSize:_fontSize];
        
    }
    return _placeholderLabel;
}


- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderLabel.text = placeholderText;
    [self layoutUI];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderLabel.textColor = placeholderTextColor;
    [self layoutUI];
}

- (void)setFontSize:(CGFloat)fontSize {
    _placeholderLabel.font = [UIFont systemFontOfSize:fontSize];
    [self layoutUI];
}

- (void)setMaxNoOfWords:(NSUInteger)maxNoOfWords {
    _maxNoOfWords = maxNoOfWords;
}

- (void)layoutUI {
    _placeholderLabel.hidden = [self.text isEqualToString:@""] ? NO:YES;
}

/**
 *  限制字数
 */
- (void)textChanged:(NSNotification *)notification {
    if (self.text.length >_maxNoOfWords && notification.object == self) {
        self.text = [self.text substringToIndex:_maxNoOfWords];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"message_content_beyond_limit", @"The message content beyond the limit") delegate:nil cancelButtonTitle:NSLocalizedString(@"know_the", @"Know The") otherButtonTitles:nil, nil];
        [alert show];
    }
    [self layoutUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  默认设置
 */
- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    [self.layer setCornerRadius:5];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    _placeholderText = @"请输入内容";
    _placeholderTextColor = [UIColor lightGrayColor];
    _fontSize = 13.0;
    _maxNoOfWords = 1000000;
    [self addSubview:self.placeholderLabel];
}


- (CGFloat)stringWidthWithHeight:(CGFloat)height fontSize:(CGFloat)fontSize content:(NSString *)content {
    CGSize size =[content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.width;
}
@end






































