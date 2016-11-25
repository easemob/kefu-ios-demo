//
//  SCLeaveMsgViewController.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCLeaveMsgViewController.h"

typedef NS_ENUM(NSUInteger, NSTextFieldTag) {
    NSTextFieldTagName=342,
    NSTextFieldTagTel,
    NSTextFieldTagMail,
    NSTextFieldTagContent
};

@interface SCLeaveMsgViewController ()

@end

@implementation SCLeaveMsgViewController

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
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.tag = tag;
    textField.placeholder = placeholder;
    [self.view addSubview:textField];
}

- (void)leaveMessage {
    NSString *name = ((UITextField *)[self.view viewWithTag:NSTextFieldTagName]).text;
    NSString *tel = ((UITextField *)[self.view viewWithTag:NSTextFieldTagTel]).text;
    NSString *mail = ((UITextField *)[self.view viewWithTag:NSTextFieldTagMail]).text;
    NSString *content = ((UITextField *)[self.view viewWithTag:NSTextFieldTagContent]).text;
    /*
     创建一个新的留言
     请求body：
     {
     subject: "ticket的主题, 可选, 如果没有的话, 那么默认是content的前10个字",
     content: "ticket的主要内容",
     status_id: "可选, 如果没有则使用project定义的默认的status, 如果没有定义默认的status则留空",
     priority_id: "可选, 如果没有则使用project定义的默认的priority, 如果没有定义默认的priority则留空",
     category_id: "可选, 如果没有则使用project定义的默认的category, 如果没有定义默认的priority则留空",
     creator: {
     name: "创建这个ticket的人的name",
     avatar: "创建这个ticket的人的头像"//可选
     email: "电子邮件地址",
     phone: "电话号码",
     qq: "qq号码",
     company: "公司",
     description: "具体的描述信息"
     },
     attachments:[{
     name: "该附件的名称",
     url: "该附件的url",
     type: "附件的类型, 当前支持image和file"
     }]
     }
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *subject = content.length >=10 ? [content substringToIndex:10] : content;
    [parameters setObject:subject forKey:@"subject"];
    [parameters setObject:content.length>0 ? content:@"" forKey:@"content"];
    [parameters setObject:@"" forKey:@"status_id"];
    [parameters setObject:@"" forKey:@"priority_id"];
    [parameters setObject:@"" forKey:@"category_id"];
    
    //creator
    NSMutableDictionary *creator = [NSMutableDictionary dictionary];
    [creator setObject:name.length>0?name:@"" forKey:@"name"];
    [creator setObject:@"" forKey:@"avatar"];
    [creator setObject:mail.length>0?mail:@"" forKey:@"email"];
    [creator setObject:tel.length>0? tel:@"" forKey:@"phone"];
    [creator setObject:@"110101010" forKey:@"qq"];
    [creator setObject:@"环信" forKey:@"company"];
    [creator setObject:@"描述信息" forKey:@"description"];
    [parameters setObject:creator forKey:@"creator"];
    NSMutableArray *attachments = [NSMutableArray array];
    [parameters setObject:attachments forKey:@"attachments"];
    SCLoginManager *logM = [SCLoginManager shareLoginManager];
    [[HNetworkManager shareInstance] asyncCreateMessageWithTenantId:logM.tenantId projectId:logM.projectId parameters:parameters completion:^(id responseObject, NSError *error) {
        
        if (error == nil) {
            NSLog(@"发送留言成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"发送留言失败");
        }
        
    }];
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
