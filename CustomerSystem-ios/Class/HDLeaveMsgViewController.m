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
    NSTextFieldTagName=342,
    NSTextFieldTagTel,
    NSTextFieldTagMail,
    NSTextFieldTagContent
};



@interface HDLeaveMsgViewController ()<UITextFieldDelegate, UITextViewDelegate>

{
    UIView *_bottomView;
    UIView *_textFView;
    UIWindow *_window;
    UITextField *_textField;
    CGFloat _boardHeight;
}

@property (nonatomic, strong) FLTextView *textView;


@end

@implementation HDLeaveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
    [self.view addSubview:self.textView];
    
    NSArray *placeholders = @[NSLocalizedString(@"ticket_name", @"Name"),NSLocalizedString(@"ticket_phone", @"Phone"),NSLocalizedString(@"ticket_email", @"Email"),NSLocalizedString(@"ticket_theme", @"Theme")];
    for (int i=0; i<4; i++) {
        [self createTextfieldWithY:30 +60*i placeholder:placeholders[i] tag:i+NSTextFieldTagName];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatToolbarState" object:nil];
}

- (FLTextView *)textView
{
    if (_textView == nil) {
        _textView = [[FLTextView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight * 0.4)];
        [_textView setPlaceholderText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"leave_content",@"Input content"),@"..."]];
        _textView.delegate = self;
        _textView.fontSize = 16.0;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:18];
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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beforeLabel.frame) + 5, y, kScreenWidth-160, 40)];
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:15];

    UILabel *lateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textField.frame), y + 4, 70, 30)];
    lateLabel.text = NSLocalizedString(@"new_leave_item_hint_text", @"Required");
    lateLabel.textColor = [UIColor grayColor];
    lateLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, y + 42, kScreenWidth - 40, 1.f)];
    line.backgroundColor = [UIColor blackColor];
    
    if (tag == NSTextFieldTagTel) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    _textField.tag = tag;
    _textField.delegate = self;
    [_textFView addSubview:beforeLabel];
    [_textFView addSubview:lateLabel];
    [_textFView addSubview:line];
    [_textFView addSubview:_textField];
    
    [self.view bringSubviewToFront:_textFView];
}


- (void)leaveMessage {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _textFView.frame;
        
        frame.origin.y = CGRectGetMaxY(self.textView.frame);
        
        _textFView.frame = frame;
        
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
        [self showHudInView:self.view hint:NSLocalizedString(@"Please_fill_out_the_information", @"Add information")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHud];
        });
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
        SCLoginManager *logM = [SCLoginManager shareLoginManager];
        [self showHudInView:self.view hint:NSLocalizedString(@"recorder_video_processing", @"processing...")];
        [[HLeaveMsgManager shareInstance] asyncCreateMessageWithTenantId:logM.tenantId projectId:logM.projectId cname:logM.cname requestBody:body completion:^(id responseObject, NSError *error) {
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

// 结束编辑
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _textFView.frame;
        
        frame.origin.y = CGRectGetMaxY(self.textView.frame) + _boardHeight;
        
        _textFView.frame = frame;
        
    }];
    
    return YES;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == NSTextFieldTagTel && ![string isEqualToString:@""]) {
        if (textField.text.length >=20) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"message_content_beyond_limit", @"The message content beyond the limit") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _textFView.frame;
            
            frame.origin.y = 150;
            
            _textFView.frame = frame;
            
        }];
    return YES;
}

- (void)setupBarButtonItem
{
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"leave_title", @"Note") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 10, 20, 18);
    backButton.titleRect = CGRectMake(45, 10, 120, 18);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(self.view.width * 0.5 - 80, 250, 160, 40);
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    _textFView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), kScreenWidth, kScreenHeight -CGRectGetMaxY(self.textView.frame) - 50)];
    //    self.textFiledView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textFView];
    
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
//    _bottomView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:_bottomView];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
//    [_bottomView addSubview:sendButton];
    
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
