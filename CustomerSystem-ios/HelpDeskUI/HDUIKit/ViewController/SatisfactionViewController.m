//
//  SatisfactionViewController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "SatisfactionViewController.h"

#import "CWStarRateView.h"
#import "HEvaluationTagView.h"
#import "HEvaluationDegreeModel.h"
#import "HAppraiseTagsModel.h"

#define kViewSpace 20.f

@interface SatisfactionViewController () <UITextViewDelegate,CWStarRateViewDelegate, HEvaluationTagSelectDelegate>

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CWStarRateView *starRateView;
@property (nonatomic, strong) UILabel *evaluateTitle;
@property (nonatomic, strong) HEvaluationTagView *evaluationTagView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSMutableDictionary *evaluationTagsDict;
@property (nonatomic, strong) NSMutableArray *evaluationTagsArray;
@end

@implementation SatisfactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.satisfaction", @"satisfaction evaluation");
    
    [self setupBarButtonItem];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, kHDScreenWidth, kHDScreenHeight);
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.headImage];
    [self.bgView addSubview:self.nickLabel];
    [self.bgView addSubview:self.textLabel];
    [self.bgView addSubview:self.starRateView];
    [self.bgView addSubview:self.evaluateTitle];
    [self.bgView addSubview:self.evaluationTagView];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.commitBtn];
    
    self.evaluateTitle.text = @"非常满意";
    [self parseAppraiseTagExt:1.0];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(topAction:)];
    [self.view addGestureRecognizer:tapGr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)topAction:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *)evaluationTagsDict
{
    if (_evaluationTagsDict == nil) {
        _evaluationTagsDict = [NSMutableDictionary dictionary];
    }
    return _evaluationTagsDict;
}

- (NSMutableArray *)evaluationTagsArray
{
    if (_evaluationTagsArray == nil) {
        _evaluationTagsArray = [NSMutableArray array];
    }
    return _evaluationTagsArray;
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -18;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
}

#pragma mark - getter
- (UIImageView*)headImage
{
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] init];
        _headImage.frame = CGRectMake((kHDScreenWidth-50)/2, 20, 50.f, 50.f);
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
        _nickLabel.frame = CGRectMake(0, CGRectGetMaxY(_headImage.frame) + kViewSpace, kHDScreenWidth, 15.f);
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
        _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_nickLabel.frame) + kViewSpace, kHDScreenWidth, 15.f);
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}

- (CWStarRateView*)starRateView
{
    if (_starRateView == nil) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + kViewSpace, kHDScreenWidth - 20, 40) numberOfStars:5];
        _starRateView.scorePercent = 1.0;
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = YES;
        _starRateView.delegate = self;
    }
    return _starRateView;
}

- (UILabel *)evaluateTitle
{
    if (_evaluateTitle == nil) {
        _evaluateTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_starRateView.frame) + kViewSpace/2, kHDScreenWidth - 40, 30)];
        _evaluateTitle.textAlignment = NSTextAlignmentCenter;
        _evaluateTitle.font = [UIFont systemFontOfSize:16];
        [_evaluateTitle setTextColor:[UIColor orangeColor]];
    }
    return _evaluateTitle;
}

- (UITextView*)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(20, CGRectGetMaxY(_evaluationTagView.frame) + kViewSpace/2, kHDScreenWidth - 40, 100);
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

- (UIView *)evaluationTagView
{
    if (_evaluationTagView == nil) {
        _evaluationTagView = [[HEvaluationTagView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_evaluateTitle.frame), kHDScreenWidth - 20, 60)];
        _evaluationTagView.delegate = self;
    }
    return _evaluationTagView;
}

- (UIButton*)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:NSLocalizedString(@"satisfaction.commit", @"commit") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.frame = CGRectMake(20, CGRectGetMaxY(_textView.frame) + 5, kHDScreenWidth - 40, 40);
        _commitBtn.layer.cornerRadius = 5.f;
        [_commitBtn setBackgroundColor:RGBACOLOR(36, 149, 207, 1)];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    [self parseAppraiseTagExt:newScorePercent];
}


- (void)parseAppraiseTagExt:(CGFloat)ScorePercent
{
    if ([self.messageModel.message.ext objectForKey:kMesssageExtWeChat]) {
        NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMesssageExtWeChat];
        if ([weichat objectForKey:kMesssageExtWeChat_ctrlArgs]) {
            NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMesssageExtWeChat_ctrlArgs]];
            NSLog(@"ctrlArgs--%@", ctrlArgs);
            NSMutableArray *evaluationDegree = [ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_evaluationDegree];
            NSDictionary *appraiseTagsDict = nil;
            if (ScorePercent == 1.0) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:0];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
            } else if (ScorePercent == 0.8) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:1];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
            } else if (ScorePercent == 0.6) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:2];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
            } else if (ScorePercent == 0.4) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:3];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
            } else if (ScorePercent == 0.2) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:4];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
            }
        
            HEvaluationDegreeModel *edm = [HEvaluationDegreeModel evaluationDegreeWithDict:appraiseTagsDict];
            self.evaluationTagView.evaluationDegreeModel = edm;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)back
{
    if (_delegate && [_delegate respondsToSelector:@selector(backFromSatisfactionViewController)]) {
        [_delegate backFromSatisfactionViewController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commit
{
    if (!_starRateView.isTap && _starRateView.scorePercent != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"satisfaction.alert", @"please evaluate first") delegate:self cancelButtonTitle:NSLocalizedString(@"cancela", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"Ok"), nil];
        [alert show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(commitSatisfactionWithControlArguments:type:evaluationTagsArray:)]) {
        if ([self.messageModel.message.ext objectForKey:kMesssageExtWeChat]) {
            NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMesssageExtWeChat];
            if ([weichat objectForKey:kMesssageExtWeChat_ctrlArgs]) {
                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMesssageExtWeChat_ctrlArgs]];
                ControlType *type = [[ControlType alloc] initWithValue:@"enquiry"];
                ControlArguments *arguments = [ControlArguments new];
                arguments.sessionId = [ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_serviceSessionId];
                arguments.inviteId = [ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_inviteId];
                arguments.detail = self.textView.text;
                arguments.summary = [NSString stringWithFormat:@"%d",(int)(_starRateView.scorePercent * 5)];
                if (self.evaluationTagsArray.count == 0 && self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0) {
                    [self showHint:NSLocalizedString(@"select_at_least_one_tag", @"Select at least one tag!")];
                } else {
                    [self.delegate commitSatisfactionWithControlArguments:arguments type:type evaluationTagsArray:self.evaluationTagsArray];
                }
                
            }
        }
    }
    if (self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0 &&
        self.evaluationTagsArray.count == 0) {
        
    } else {
         [self back];
    }
    
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
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (endRect.origin.y == screenHeight) {
        frame.origin.y = 0;
    } else if(beginRect.origin.y == screenHeight){
        frame.origin.y = - 190;
    } else{
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = frame;
    }];
}

- (void)evaluationTagSelectWithArray:(NSArray *)tags
{
    if (self.evaluationTagsArray) {
        [self.evaluationTagsArray removeAllObjects];
    }
    
    for (int i = 0; i < tags.count; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        HAppraiseTagsModel *model = tags[i];
        [dict setObject:model.appraiseTagsId forKey:@"id"];
        [dict setObject:model.name forKey:@"name"];
        [self.evaluationTagsArray addObject:dict];
    }

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
