//
//  SCLeaveMsgViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDLeaveMsgViewController.h"

typedef NS_ENUM(NSUInteger, NSTextFieldTag) {
    NSTextFieldTagName=342,
    NSTextFieldTagTel,
    NSTextFieldTagMail,
    NSTextFieldTagContent
};

@interface HDLeaveMsgViewController ()<UITextFieldDelegate>

@end

@implementation HDLeaveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
    NSArray *placeholders = @[@"姓名",@"电话",@"邮箱",@"内容"];
    for (int i=0; i<4; i++) {
        [self createTextfieldWithY:80+60*i placeholder:placeholders[i] tag:i+NSTextFieldTagName];
    }
}
- (void)createTextfieldWithY:(CGFloat)y placeholder:(NSString *)placeholder tag:(NSTextFieldTag)tag
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, y, kScreenWidth-20, 40)];
    if (tag == NSTextFieldTagTel) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.tag = tag;
    textField.delegate = self;
    textField.placeholder = placeholder;
    [self.view addSubview:textField];
}

- (void)leaveMessage {
    [self.view endEditing:YES];
    NSString *name = ((UITextField *)[self.view viewWithTag:NSTextFieldTagName]).text;
    NSString *tel = ((UITextField *)[self.view viewWithTag:NSTextFieldTagTel]).text;
    NSString *mail = ((UITextField *)[self.view viewWithTag:NSTextFieldTagMail]).text;
    NSString *content = ((UITextField *)[self.view viewWithTag:NSTextFieldTagContent]).text;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *subject = content.length >=10 ? [content substringToIndex:10] : content;
    [parameters setValue:subject forKey:@"subject"];
    [parameters setObject:content.length>0 ? content:@"" forKey:@"content"];
    
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
    SCLoginManager *logM = [SCLoginManager shareLoginManager];
    [self showHudInView:self.view hint:@"发送中..."];
    [[HLeaveMsgManager shareInstance] asyncCreateMessageWithTenantId:logM.tenantId projectId:logM.projectId cname:logM.cname requestBody:body completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSLog(@"发送留言成功");
            [self hideHud];
            [self showHudInView:self.view hint:@"留言发送成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_ADDMSG_TO_LIST object:nil];
        } else {
            NSLog(@"发送留言失败");
            [self hideHud];
            [self showHudInView:self.view hint:@"发送失败，请稍后重试"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHud];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == NSTextFieldTagTel && ![string isEqualToString:@""]) {
        if (textField.text.length >=20) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"长度受限" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(leaveMessage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
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
