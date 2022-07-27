//
//  SatisfactionViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "SatisfactionViewController.h"

#import "CWStarRateView.h"

#define kViewSpace 20.f

@interface SatisfactionViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CWStarRateView *starRateView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation SatisfactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.satisfaction", @"satisfaction evaluation");
    
    [self setupBarButtonItem];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.headImage];
    [self.bgView addSubview:self.nickLabel];
    [self.bgView addSubview:self.textLabel];
    [self.bgView addSubview:self.starRateView];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.commitBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - getter
- (UIImageView*)headImage
{
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] init];
        _headImage.frame = CGRectMake((kScreenWidth-50)/2, 20 + 64, 50.f, 50.f);
        _headImage.layer.cornerRadius = CGRectGetWidth(_headImage.frame)/2;
        _headImage.backgroundColor = [UIColor whiteColor];
        _headImage.image = [UIImage imageNamed:@"customer"];
    }
    return _headImage;
}

- (UILabel*)nickLabel
{
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = NSLocalizedString(@"satisfaction.nickname", @"Nickname");
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.textColor = [UIColor lightGrayColor];
        _nickLabel.frame = CGRectMake(0, CGRectGetMaxY(_headImage.frame) + kViewSpace, kScreenWidth, 15.f);
        _nickLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nickLabel;
}

- (UILabel*)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_nickLabel.frame) + kViewSpace, kScreenWidth, 15.f);
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}

- (CWStarRateView*)starRateView
{
    if (_starRateView == nil) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + kViewSpace, kScreenWidth - 20, 40) numberOfStars:5];
        _starRateView.scorePercent = 1.0;
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = YES;
    }
    return _starRateView;
}

- (UITextView*)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(20, CGRectGetMaxY(_starRateView.frame) + kViewSpace, kScreenWidth - 40, 100);
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.borderWidth = 0.5;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton*)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:NSLocalizedString(@"satisfaction.commit", @"commit") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.frame = CGRectMake(20, CGRectGetMaxY(_textView.frame) + kViewSpace, kScreenWidth - 40, 40);
        _commitBtn.layer.cornerRadius = 5.f;
        [_commitBtn setBackgroundColor:RGBACOLOR(36, 149, 207, 1)];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commit
{
    if (!_starRateView.isTap) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"satisfaction.alert", @"please evaluate first") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"Ok"), nil];
        [alert show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(commitSatisfactionWithExt:messageModel:)]) {
        if ([self.messageModel.message.ext objectForKey:kMesssageExtWeChat]) {
            NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMesssageExtWeChat];
            if ([weichat objectForKey:kMesssageExtWeChat_ctrlArgs]) {
                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMesssageExtWeChat_ctrlArgs]];
                [ctrlArgs setObject:self.textView.text forKey:kMesssageExtWeChat_ctrlArgs_detail];
                [ctrlArgs setObject:[NSString stringWithFormat:@"%d",(int)(_starRateView.scorePercent*5)] forKey:kMesssageExtWeChat_ctrlArgs_summary];
                NSMutableDictionary *wc = [NSMutableDictionary dictionary];
                [wc setObject:ctrlArgs forKey:kMesssageExtWeChat_ctrlArgs];
                [wc setObject:kMesssageExtWeChat_ctrlType_enquiry forKey:kMesssageExtWeChat_ctrlType];
                [self.delegate commitSatisfactionWithExt:wc messageModel:self.messageModel];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *beginValue = [userInfo objectForKey:@"UIKeyboardFrameBeginUserInfoKey"];
    NSValue *endValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect beginRect;
    [beginValue getValue:&beginRect];
    CGRect endRect;
    [endValue getValue:&endRect];
    
    CGRect frame = self.bgView.frame;
    if (endRect.origin.y == self.view.frame.size.height) {
        frame.origin.y = 0;
    } else if(beginRect.origin.y == self.view.frame.size.height){
        frame.origin.y = - 190;
    } else{
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = frame;
    }];
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
