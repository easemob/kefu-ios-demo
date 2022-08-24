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
#import "HDAccountmanager.h"
#import "HDAppSkin.h"

#define kViewSpace 20.f
#define kResolvedButtonTag  111

static UIButton *lastBtn;
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
@property (nonatomic, strong) NSMutableArray *resolutionParamsArray;

@property (nonatomic, strong) UIView *resolvedView;
@property (nonatomic, strong) UILabel *resolvedTitle;
@property (nonatomic, strong) UIButton *resolvedButton;
@property (nonatomic, strong) UIButton *unResolvedButton;
@property (nonatomic, strong) HAppraiseTagsModel *resolveModel;


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
    
    [self.bgView addSubview:self.resolvedTitle];
    [self.resolvedTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(10);
        make.leading.offset(0);
        make.trailing.offset(0);
//        make.height.offset(0);
    }];
    [self.resolvedView layoutIfNeeded];
    [self.bgView addSubview:self.resolvedView];
    [self.resolvedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resolvedTitle.mas_bottom).offset(10);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(0);
    }];
    [self.resolvedView layoutIfNeeded];
    [self.bgView addSubview:self.textLabel];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resolvedView.mas_bottom).offset(10);
        make.leading.offset(0);
        make.trailing.offset(0);
//        make.height.offset(15);
    }];
    [self.textLabel layoutIfNeeded];
    [self.bgView addSubview:self.starRateView];
    [self.starRateView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(40);
    }];
    [self.bgView addSubview:self.evaluateTitle];
    
    [self.evaluateTitle mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.starRateView.mas_bottom).offset(10);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.height.offset(30);
    }];
    
    
    [self.bgView addSubview:self.evaluationTagView];
    [self.evaluationTagView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.evaluateTitle.mas_bottom).offset(10);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(60);
    }];
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.evaluationTagView.mas_bottom).offset(10);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(100);
    }];
    [self.bgView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.textView.mas_bottom).offset(10);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(40);
    }];
    self.evaluateTitle.text = @"非常满意";
    [self parseAppraiseTagExt:1.0];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(topAction:)];
    [self.view addGestureRecognizer:tapGr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.messageModel.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
    self.messageModel.avatarURLPath = [HDAccountmanager shareLoginManager].avatarStr;
    self.messageModel.nickname = [HDAccountmanager shareLoginManager].nickname;

    self.nickLabel.text = self.messageModel.nickname;
    [self.headImage hdSD_setImageWithURL:[NSURL URLWithString:self.messageModel.avatarURLPath] placeholderImage:[UIImage imageNamed:@"customer"]];

   // 创建ResolvedView
    [self getOptionsResolved];
    
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
- (NSMutableArray *)resolutionParamsArray
{
    if (_resolutionParamsArray == nil) {
        _resolutionParamsArray = [NSMutableArray array];
    }
    return _resolutionParamsArray;
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
        _headImage.layer.masksToBounds = YES;
        
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
        _textLabel.numberOfLines = 0;
//        _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_resolvedView.frame) + kViewSpace, kHDScreenWidth, 15.f);
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
        _textView.textColor = UIColor.blackColor;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        UILabel *placeHolderLabel = [[UILabel alloc] init];
              
        placeHolderLabel.text = NSLocalizedString(@"video.satisfaction.EnquiryComment", @"EnquiryComment");
        
        placeHolderLabel.numberOfLines = 0;
        
        placeHolderLabel.textColor = [[HDAppSkin mainSkin] contentColorBCBCBC];
        
        [placeHolderLabel sizeToFit];
        
        placeHolderLabel.font = [UIFont systemFontOfSize:12];
        
        [_textView addSubview:placeHolderLabel];
        
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
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
    if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
        NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMessageExtWeChat];
        if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
            NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
            NSLog(@"ctrlArgs--%@", ctrlArgs);
            NSMutableArray *evaluationDegree = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_evaluationDegree];
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
    if ([self.delegate respondsToSelector:@selector(commitSatisfactionWithControlArguments:type:evaluationTagsArray:resolutionParamsArray: evaluationDegreeId:)]) {
        if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
            HDMessage *msg = self.messageModel.message;
            NSDictionary *weichat = [msg.ext objectForKey:kMessageExtWeChat];
            if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
                ControlType *type = [[ControlType alloc] initWithValue:@"enquiry"];
                ControlArguments *arguments = [ControlArguments new];
                arguments.sessionId = [msg.ext objectForKey:kMessageExtWeChat_ctrlArgs_serviceSessionId];
                if (!arguments.sessionId) {
                    if (msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"]) {
                        arguments.sessionId = msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"];
                    }
                }
                
                if ([[msg.ext allKeys] containsObject:@"evaluateWay"] && [msg.ext[@"evaluateWay"] isEqualToString:@"visitor"]) {
                    arguments.evaluateWay = msg.ext[@"evaluateWay"];
                }else if (![[msg.ext allKeys] containsObject:@"evaluateWay"]) {
                    // 说明是 坐席主动发起的评价
                    arguments.evaluateWay = @"agent";
                }else if ([[msg.ext allKeys] containsObject:@"evaluateWay"] && [msg.ext[@"evaluateWay"] isEqualToString:@"system"]) {
                    arguments.evaluateWay = msg.ext[@"evaluateWay"];
                }else{
                    
                    arguments.evaluateWay = @"";
                }
                
                arguments.inviteId = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_inviteId];
                arguments.detail = self.textView.text;
                arguments.summary = [NSString stringWithFormat:@"%d",(int)(_starRateView.scorePercent * 5)];
                if (self.evaluationTagsArray.count == 0 && self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0) {
                    [self showHint:NSLocalizedString(@"select_at_least_one_tag", @"Select at least one tag!")];
                } else {
                    
                   

                    [self.delegate commitSatisfactionWithControlArguments:arguments
                                                                     type:type
                                                      evaluationTagsArray:self.evaluationTagsArray
                                                    resolutionParamsArray: [self setAssemblyresolveData]
                                                       evaluationDegreeId:self.evaluationTagView.evaluationDegreeModel.evaluationDegreeId];
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
//对应于 ContentMode UIViewContentModeScaleAspectFit
- (CGSize)CGSizeAspectFit:(CGSize)aspectRatio bounding:(CGSize) boundingSize
{
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = mH * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = mW * aspectRatio.height;
    return boundingSize;
}

//对应于 ContentMode UIViewContentModeScaleAspectFill
- (CGSize)CGSizeAspectFill:(CGSize)aspectRatio minSize:(CGSize)minimumSize
{
    float mW = minimumSize.width / aspectRatio.width;
    float mH = minimumSize.height / aspectRatio.height;
    if( mH > mW )
        minimumSize.width = mH * aspectRatio.width;
    else if( mW > mH )
        minimumSize.height = mW * aspectRatio.height;
    return minimumSize;
}

- (UIImage *)imageScaledToSize:(CGSize)size boundingSize:(CGSize)boundingSize cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);

    //需要将可视区域画到图片的中心
    CGFloat originX = (size.width-boundingSize.width)/2;
    originX = originX < 0 ? 0 : originX;

    CGFloat originY = (size.height-boundingSize.height)/2;
    originY = originY < 0 ? 0 : originY;

    [borderColor setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(originX, originY, boundingSize.width, boundingSize.height) cornerRadius:cornerRadius];
    [bezierPath setLineWidth:borderWidth];
    [bezierPath stroke];
    [bezierPath addClip];

    //draw
    [self.headImage.image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];

    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
#pragma mark - 新增 解决未解决 界面

// 获取解决未解决 接口 展示对应数据
- (void)getOptionsResolved{
//    问题解决评价开关
     [[HDClient sharedClient].chatManager getOptionsConfig:HDOption_Satisfaction_ProblemSolvingEvaluationOn  WithServiceSessionId:self.messageModel.serviceSessionId Completion:^(id responseObject, HDError *error) {
         NSLog(@"=====%@",responseObject);
         
         if (error == nil && [responseObject isKindOfClass:[NSDictionary class]]) {
             
             NSDictionary * dic = responseObject;
             
             NSArray * entities = [dic valueForKey:@"entities"];
             
             if ([[entities firstObject] isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary * optionDic = [entities firstObject];
                 
                 if ([[optionDic allKeys] containsObject:@"optionValue"]) {
                     
                     NSString * json = [optionDic valueForKey:@"optionValue"];
                    NSString *str = [json stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                     
                     NSDictionary *info = [NSDictionary dictionaryWithString:str];
                     
                     if ([[info allKeys] containsObject:@"app"]) {
                         
                         NSString * app = [info valueForKey:@"app"];
                         
                         if ([app intValue] == 1) {
//                             问题解决评价
                             [[HDClient sharedClient].chatManager getResolutionParamServiceSessionId:self.messageModel.serviceSessionId Completion:^(id responseObject, HDError *error) {
                                 if (error == nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                     NSDictionary * dic = responseObject;
                                     if ([[dic allKeys] containsObject:@"status"] && [[dic objectForKey:@"status"] isEqualToString:@"OK"] && [[dic allKeys] containsObject:@"entities"] && [[dic objectForKey:@"entities"] isKindOfClass:[NSArray class]]) {
                                         // 需要展示
                                         NSArray * array = [dic objectForKey:@"entities"];
                                         [self updateResolvedViewLayout:array];
                                     }
                                
                                 }
                             }];
                         }
                     }
                 }
             }
         }
     }];
    
  
    // 获取请您对我的服务做出评价
    [[HDClient sharedClient].chatManager getOptionsConfig:HDOption_Satisfaction_GreetingMsgEnquiryInvite WithServiceSessionId:self.messageModel.serviceSessionId Completion:^(id responseObject, HDError *error) {
        
        if (error == nil && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            self.textLabel.text =  [self getResponeDataAnalysis:responseObject];
        }
    }];
    
}
-  (NSString *)getResponeDataAnalysis:(id)responseObject{
        NSDictionary * dic = responseObject;
        NSArray * entities = [dic valueForKey:@"entities"];
        if ([[entities firstObject] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * optionDic = [entities firstObject];
            if ([[optionDic allKeys] containsObject:@"optionValue"]) {
                NSString * json = [optionDic valueForKey:@"optionValue"];
                return json;
            }
        }
    return @"";
}


// 解析 消息里返回的 评价相关的字段
- (void) updateResolvedViewLayout:(NSArray *)resolutionParams{
    // 解析数据 如果数据解析正常显示 界面
    if (resolutionParams.count > 0) {
        // 获取问题解决评价引导语
        [[HDClient sharedClient].chatManager getOptionsConfig:HDOption_Satisfaction_EvaluteSolveWord WithServiceSessionId:self.messageModel.serviceSessionId Completion:^(id responseObject, HDError *error) {
            if (error == nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                self.resolvedTitle.text =  [self getResponeDataAnalysis:responseObject];
            }
        }];
        NSArray * tmpArray = [[NSArray alloc] initWithArray:resolutionParams];
        
        [self.resolutionParamsArray removeAllObjects];
        
        [ tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HAppraiseTagsModel *model = [HAppraiseTagsModel appraiseTagsWithDict:obj];
            
            if (idx == 0) {
                [self.resolvedButton setTitle:model.name forState:UIControlStateNormal];
            }else{
                [self.unResolvedButton setTitle:model.name forState:UIControlStateNormal];
            }
            [self.resolutionParamsArray addObject:model];
        }];
        self.resolvedTitle.hidden = NO;
        self.resolvedView.hidden = NO;
        [self.resolvedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.resolvedTitle.mas_bottom).offset(10);
            make.leading.offset(0);
            make.trailing.offset(0);
            make.height.offset(56);
        }];
        [self.resolvedView layoutIfNeeded];
        //设置默认选中
        [self btnTouch:self.resolvedButton];
    }
}
-(NSMutableArray *)setAssemblyresolveData{
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    if (self.resolveModel && self.resolvedView.frame.size.height >0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict hd_setValue: self.resolveModel.appraiseTagsId forKey:@"id"];
        [dict hd_setValue:self.resolveModel.name forKey:@"name"];
        [dict hd_setValue: self.resolveModel.score  forKey:@"score"];
        [dict hd_setValue:self.resolveModel.resolutionParamTags forKey:@"resolutionParamTags"];
        [mArray addObject:dict];
    }
    
    return mArray;
    
}

// 在touch事件中，以一个static变量记录instance
- (void)btnTouch:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (lastBtn != btn) {
        btn.selected = !btn.selected;
        [btn setBackgroundColor:RGBACOLOR(36, 149, 207, 1)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lastBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        lastBtn.selected = !lastBtn.selected;
        lastBtn = btn;
        NSInteger tag = btn.tag - kResolvedButtonTag;
        if (tag < self.resolutionParamsArray.count) {
            self.resolveModel = [self.resolutionParamsArray objectAtIndex:tag];
        }
    }
}
- (UIView *)resolvedView{
    
    if (!_resolvedView) {
        _resolvedView = [[UIView alloc] init];
        _resolvedView.hidden = YES;
        [_resolvedView addSubview: self.resolvedButton];
        [self.resolvedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.leading.offset(self.view.frame.size.width*0.5 -self.view.frame.size.width*0.5/1.2-20);
            make.width.offset(self.view.frame.size.width*0.5/1.2);
            make.height.offset(44);
            
        }];
        [_resolvedView addSubview: self.unResolvedButton];
        [self.unResolvedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.leading.mas_equalTo(self.resolvedButton.mas_trailing).offset(30);
            make.width.mas_equalTo(self.resolvedButton.mas_width);
            make.height.mas_equalTo(self.resolvedButton.mas_height);

        }];
        
    }
    
    return _resolvedView;
}

- ( UILabel *)resolvedTitle{
    
    if (_resolvedTitle == nil) {
        _resolvedTitle = [[UILabel alloc] init];
        _resolvedTitle.hidden = YES;
        _resolvedTitle.text = NSLocalizedString(@"satisfaction.evaluate.GuideLanguage", @"请问客服是否解决了您的问题？");
        _resolvedTitle.textAlignment = NSTextAlignmentCenter;
        _resolvedTitle.numberOfLines = 0;
        _resolvedTitle.textColor = [UIColor lightGrayColor];

        _resolvedTitle.font = [UIFont systemFontOfSize:15];
    }
    return _resolvedTitle;
    
}

- (UIButton *)resolvedButton{
    
    if (_resolvedButton == nil) {
        _resolvedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resolvedButton setTitle:NSLocalizedString(@"satisfaction.evaluate.solve", @"satisfaction.evaluate.solve") forState:UIControlStateNormal];
        [_resolvedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_resolvedButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_dianzan"] forState:UIControlStateNormal];
        [_resolvedButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_dianzan-sel"] forState:UIControlStateSelected];
        [_resolvedButton  setImageEdgeInsets: UIEdgeInsetsMake(0, 2, 0, 20)];
        _resolvedButton.layer.cornerRadius = 20.f;
        _resolvedButton.tag = kResolvedButtonTag + 0;
        _resolvedButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _resolvedButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [_resolvedButton setBackgroundColor:[[HDAppSkin mainSkin] contentColorF7F7F7]];
        [_resolvedButton addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolvedButton;
    
    
}
- (UIButton *)unResolvedButton{
    
    if (_unResolvedButton == nil) {
        _unResolvedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unResolvedButton setTitle:NSLocalizedString(@"satisfaction.evaluate.NotSolved", @"satisfaction.evaluate.NotSolved") forState:UIControlStateNormal];
        [_unResolvedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _unResolvedButton.layer.cornerRadius = 20.f;
        _unResolvedButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_unResolvedButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_nodianzan"] forState:UIControlStateNormal];
        [_unResolvedButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_nodianzan-sel"] forState:UIControlStateSelected];
        [_unResolvedButton  setImageEdgeInsets: UIEdgeInsetsMake(0, 2, 0, 20)];
        _unResolvedButton.tag =  kResolvedButtonTag +1;
        _unResolvedButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [_unResolvedButton setBackgroundColor:[[HDAppSkin mainSkin] contentColorF7F7F7] ];
        [_unResolvedButton addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unResolvedButton;
    
    
}


@end
