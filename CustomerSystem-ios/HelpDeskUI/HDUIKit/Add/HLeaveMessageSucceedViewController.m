//
//  HLeaveMessageSucceedViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/6.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HLeaveMessageSucceedViewController.h"
typedef NS_ENUM(NSUInteger, NSTextFieldTag) {
    NSTextFieldTagName=342,
    NSTextFieldTagTel,
    NSTextFieldTagMail,
    NSTextFieldTagContent
};
@interface HLeaveMessageSucceedViewController () <UITextFieldDelegate>
{
    NSString *_queue;
}
@end

@implementation HLeaveMessageSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItem];
    
}

- (void)createTextfieldWithY:(CGFloat)y placeholder:(NSString *)placeholder tag:(NSTextFieldTag)tag number:(int)i
{
    UILabel *beforeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 4, kScreenWidth*0.3, 40)];
    beforeLabel.text = [NSString stringWithFormat:@"%@:", placeholder];
    beforeLabel.textAlignment = NSTextAlignmentLeft;
    beforeLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *lateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beforeLabel.frame), y + 4, kScreenWidth - CGRectGetMaxX(beforeLabel.frame) - 20, 40)];
    lateLabel.text = _leaveMessageArray[i];
    lateLabel.textColor = [UIColor grayColor];
    lateLabel.font = [UIFont systemFontOfSize:15];
    lateLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, y + 42, kScreenWidth - 40, 1.f)];
    line.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:beforeLabel];
    [self.view addSubview:lateLabel];
    [self.view addSubview:line];
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
    backButton.titleRect = CGRectMake(28, 0, 83, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 120, 29);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self hideHud];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    });
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 30, kScreenHeight/7 - 60, 60, 60)];
    [button setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_icon_leave_suc"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UILabel *commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 20, kScreenWidth, 30)];
    commitLabel.text = NSLocalizedString(@"new_leave_send_success", @"Submit successful");
    commitLabel.font = [UIFont systemFontOfSize:20];
    commitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:commitLabel];
    
    UILabel *thankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(commitLabel.frame) + 10, kScreenWidth, 20)];
    thankLabel.text = NSLocalizedString(@"new_leave_send_descriptionOne", @"Thank you for your leave message.");
    thankLabel.font = [UIFont systemFontOfSize:15];
    thankLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thankLabel];
    
    UILabel *thankLabelOther = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thankLabel.frame) + 5, kScreenWidth, 20)];
    thankLabelOther.text = NSLocalizedString(@"new_leave_send_descriptionTwo", @"We will give you a response at the first time.");
    thankLabelOther.font = [UIFont systemFontOfSize:15];
    thankLabelOther.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thankLabelOther];
    
    NSArray *placeholders = @[NSLocalizedString(@"ticket_name", @"Name"),NSLocalizedString(@"ticket_phone", @"Phone"),NSLocalizedString(@"ticket_email", @"Email"),NSLocalizedString(@"ticket_theme", @"Theme"),NSLocalizedString(@"ticket_detail", @"Detail")];
    for (int i=0; i<5; i++) {
        [self createTextfieldWithY:CGRectGetMaxY(thankLabelOther.frame) + 10 +50*i placeholder:placeholders[i] tag:i+NSTextFieldTagName number:i];
    }
    
}

- (void)back
{
    HDMessageViewController *chatVC = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[HDMessageViewController class]]) {
            chatVC = (HDMessageViewController *)vc;
            break;
        }
    }
    if (chatVC != nil) {
        [self.navigationController popToViewController:chatVC animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)dealloc {
    NSLog(@"dealloc %s",__func__);
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
