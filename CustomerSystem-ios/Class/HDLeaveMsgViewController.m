//
//  SCLeaveMsgViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDLeaveMsgViewController.h"
#import "CustomButton.h"
#import "FLTextView.h"
#import "HLeaveMessageSucceedViewController.h"
typedef NS_ENUM(NSUInteger, NSTextFieldTag) {
    NSTextFieldTagName=1,
    NSTextFieldTagTel,
    NSTextFieldTagMail,
    NSTextFieldTagContent
};



@interface HDLeaveMsgViewController ()<UITextFieldDelegate, UITextViewDelegate>

{
    UIView *_bottomView;
    UIView *_backView;
    UIWindow *_window;
    UITextField *_textFieldOne;
    UITextField *_textFieldTwo;
    UITextField *_textFieldThree;
    UITextField *_textFieldFour;
    CGFloat _boardHeight;
}

@property (nonatomic, strong) FLTextView *textView;


@end

@implementation HDLeaveMsgViewController
{
    UITextField *_currentTextField;
    CGFloat     _keyboardHeight;
    CGFloat     _duration;  //动画时间
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNoti];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
    [self setTextFiledFarme];
    [self.view addSubview:self.textView];
    
    NSArray *placeholders = @[NSLocalizedString(@"ticket_name", @"Name"),NSLocalizedString(@"ticket_phone", @"Phone"),NSLocalizedString(@"ticket_email", @"Email"),NSLocalizedString(@"ticket_theme", @"Theme")];
    for (int i=0; i<4; i++) {
        [self createTextfieldWithY:50 * i placeholder:placeholders[i] tag:i+NSTextFieldTagName];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatToolbarState" object:nil];
}

- (void)setTextFiledFarme
{
    _textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-160, 40)];
    _textFieldOne.delegate = self;
    _textFieldOne.returnKeyType = UIReturnKeyNext;
    _textFieldOne.font = [UIFont systemFontOfSize:15];
    _textFieldOne.tag = 1;
    [_backView addSubview:_textFieldOne];
    
    _textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(75, 50, kScreenWidth-160, 40)];
    _textFieldTwo.delegate = self;
    _textFieldTwo.returnKeyType = UIReturnKeyNext;
    _textFieldTwo.font = [UIFont systemFontOfSize:15];
    _textFieldTwo.tag = 2;

    [_backView addSubview:_textFieldTwo];
    
    _textFieldThree = [[UITextField alloc] initWithFrame:CGRectMake(75, 100, kScreenWidth-160, 40)];
    _textFieldThree.delegate = self;
    _textFieldThree.returnKeyType = UIReturnKeyNext;
    _textFieldThree.font = [UIFont systemFontOfSize:15];
    _textFieldThree.tag = 3;
    [_backView addSubview:_textFieldThree];
    
    _textFieldFour = [[UITextField alloc] initWithFrame:CGRectMake(75, 150, kScreenWidth-160, 40)];
    _textFieldFour.delegate = self;
    _textFieldFour.returnKeyType = UIReturnKeyDone;
    _textFieldFour.font = [UIFont systemFontOfSize:15];
    _textFieldFour.tag = 4;
    [_backView addSubview:_textFieldFour];
    
}

- (FLTextView *)textView
{
    if (_textView == nil) {
        _textView = [[FLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.35)];
        [_textView setPlaceholderText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"leave_content",@"Input content"),@"..."]];
        _textView.delegate = self;
        _textView.fontSize = 16.0;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.layer.borderColor = [UIColor clearColor].CGColor;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), kScreenWidth, 0.5f)];
        [self.view addSubview:line];
    }
    return _textView;
}

- (void)createTextfieldWithY:(CGFloat)y placeholder:(NSString *)placeholder tag:(NSTextFieldTag)tag
{
    UILabel *beforeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 4, 55, 30)];
    beforeLabel.text = [NSString stringWithFormat:@"%@:", placeholder];
    beforeLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *lateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textFieldOne.frame), y + 4, 70, 30)];
    lateLabel.text = NSLocalizedString(@"new_leave_item_hint_text", @"Required");
    lateLabel.textColor = [UIColor grayColor];
    lateLabel.textAlignment = NSTextAlignmentRight;
    lateLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, y + 32, kScreenWidth - 40, 1.f)];
    line.backgroundColor = [UIColor blackColor];
    

    [_backView addSubview:beforeLabel];
    [_backView addSubview:lateLabel];
    [_backView addSubview:line];

    
    [self.view bringSubviewToFront:_backView];
}


- (void)leaveMessage {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _backView.frame;
        
        frame.origin.y = CGRectGetMaxY(self.textView.frame);
        
        _backView.frame = frame;
        
    }];
    
    NSString *name = ((UITextField *)[self.view viewWithTag:NSTextFieldTagName]).text;
    NSString *tel = ((UITextField *)[self.view viewWithTag:NSTextFieldTagTel]).text;
    NSString *mail = ((UITextField *)[self.view viewWithTag:NSTextFieldTagMail]).text;
    NSString *subject = ((UITextField *)[self.view viewWithTag:NSTextFieldTagContent]).text;
    NSString *content = _textView.text;
    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    NSString *subject = content.length >=10 ? [content substringToIndex:10] : content;
//    [parameters setValue:subject forKey:@"subject"];
//    [parameters setObject:content.length>0 ? content:@"" forKey:@"content"];
    
    if (([name isEqualToString:@""] || [tel isEqualToString:@""] || [mail isEqualToString:@""] || [subject isEqualToString:@""] || [content isEqualToString:@""])) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"Please_fill_out_the_information", @"addinformation") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alert show];
        
    } else {
        Creator *creator = [Creator new];
        creator.name = name;
        creator.email = mail;
        creator.phone = tel;
        creator.qq = @"123456";
        creator.desc = @"我是一只丑小鸭";
        creator.companyName = @"环信客服";
        LeaveMsgRequestBody *body = [LeaveMsgRequestBody new];
        body.creator = creator;
        body.content = content;
        body.subject = subject;
        CSDemoAccountManager *logM = [CSDemoAccountManager shareLoginManager];
        [self showHudInView:self.view hint:NSLocalizedString(@"recorder_video_processing", @"processing...")];
        [[[HDClient sharedClient] leaveMsgManager]createLeaveMsgWithProjectId:logM.projectId targetUser:logM.cname requestBody:body completion:^(id responseObject, NSError *error) {
            if (error == nil) {
                NSLog(@"发送留言成功");
                [self hideHud];
                [self showHudInView:self.view hint:NSLocalizedString(@"recorder_video_processing", @"processing...")];
                
                HLeaveMessageSucceedViewController *lmsvc = [[HLeaveMessageSucceedViewController alloc] init];
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:name];
                [array addObject:tel];
                [array addObject:mail];
                [array addObject:subject];
                [array addObject:content];
                NSArray *arr = [NSArray arrayWithArray:array];
                lmsvc.leaveMessageArray = arr;
                [self.navigationController pushViewController:lmsvc animated:YES];
                
            } else {
                NSLog(@"发送留言失败");
                [self hideHud];
                [self showHudInView:self.view hint:NSLocalizedString(@"send_failure_please", @"Send failure")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideHud];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_ADDMSG_TO_LIST object:nil];
    }
    
}


// textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == NSTextFieldTagTel && ![string isEqualToString:@""]) {
        if (textField.text.length >=20) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"message_content_beyond_limit", @"The message content beyond the limit") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (textField.tag == 1) {
            [_textFieldTwo becomeFirstResponder];
        } else if (textField.tag == 2) {
             [_textFieldThree becomeFirstResponder];
        } else if (textField.tag == 3) {
             [_textFieldFour becomeFirstResponder];
        }
        
    } else {
        [_textFieldFour endEditing:YES];
       }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;  //当前焦点所在textField
    [self layoutKeyboard];
    
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self resetBackView];
}

- (void)layoutKeyboard {
    CGRect crtRect = [_backView convertRect:_currentTextField.frame toView:self.view];
    
    CGFloat offset = self.view.size.height - CGRectGetMaxY(crtRect) - _keyboardHeight;
    
    //将视图上移计算好的偏移
    CGFloat oy = _backView.originY+ offset;
    [UIView animateWithDuration:_duration animations:^{
        _backView.frame = CGRectMake(0.0f, oy, _backView.frame.size.width, _backView.frame.size.height);
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_textView endEditing:YES];
        return NO;
    }
    
    return YES;
}

- (void)setupBarButtonItem
{
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"leave_title", @"Note") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 43, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 80, 29);
    
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];

    
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), kScreenWidth, kScreenHeight -CGRectGetMaxY(self.textView.frame) - 140)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 110, kScreenWidth, 50)];
    _bottomView.backgroundColor = RGBACOLOR(184, 22, 22, 1);
    [self.view addSubview:_bottomView];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 55, 0, 50, 50)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
//    [self.navigationItem setRightBarButtonItem:sendItem];
    
    [_bottomView addSubview:sendButton];
    
}

- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    _keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    _duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self layoutKeyboard];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self resetBackView];
}

- (void)resetBackView {
    _backView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame), kScreenWidth, kScreenHeight -CGRectGetMaxY(self.textView.frame) - 140);
}


- (void)dealloc {
    NSLog(@"dealloc %s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
