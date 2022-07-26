//
//  HDSatisfactionView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDSatisfactionView.h"
#import "HDEnquiryOptionModel.h"
#import "HDEnquiryTagModel.h"
#import "MBProgressHUD+Add.h"
#import "HDAgoraCallManager.h"
@interface HDSatisfactionView()<UITextViewDelegate,CWStarRateViewDelegate,HDSatisfactionEvaluationTagSelectDelegate>
{
    HDMessage *_model;
    NSDictionary *enquiryDic;
    NSArray *_enquiryOptions;
    NSDictionary *_enquiryTags;
    
    UILabel *_placeHolderLabel;
    
    CGFloat _currentHeight;
    
//    BOOL  _isDefault5Score;
    CGFloat _textViewHeight;
}
@property (nonatomic,strong) SKTagView *tagView;;
@property (nonatomic,strong) NSMutableArray  *currentTags;
@property (nonatomic,strong) UIView *maskView;
@end
@implementation HDSatisfactionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
       
    
    }
    
    return self;
}

- (void)creatUI{
    

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            make.trailing.offset(0);
            make.leading.offset(0);
    }];

    [self.bgView addSubview:self.titleLabel];
    
    //标题 请对我的服务进行评价
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.offset(20);
        make.width.offset(0);
        make.height.offset(44);
    }];
    [self.titleLabel layoutIfNeeded];
    
    [self.bgView addSubview:self.textLabel];
    
    //标题 请对我的服务进行评价
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.mas_equalTo(self.titleLabel.mas_trailing).offset(0);
        make.trailing.offset(-20);
        make.height.offset(44);
    }];
    [self.textLabel layoutIfNeeded];
    [self.bgView addSubview:self.starRateView];

    [self.bgView addSubview:self.evaluateTitle];
    
    //满意度的 值
    [self.evaluateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starRateView.mas_bottom).offset(0);
        make.leading.offset(50);
        make.trailing.offset(-50);
        make.height.offset(44);
        
    }];
    [self.evaluateTitle layoutIfNeeded];
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.height.offset(_textViewHeight);
        make.bottom.offset(-74);
    }];
    [self.textView layoutIfNeeded];
//    [self.bgView addSubview:self.evaluationTagView];
//    [self.evaluationTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.evaluateTitle.mas_bottom).offset(0);
//        make.leading.offset(20);
//        make.trailing.offset(-20);
//        make.bottom.mas_equalTo(self.textView.mas_top).offset(-10);
//    }];
//    [self.evaluationTagView layoutIfNeeded];
    [self.bgView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(self.textView.mas_trailing).offset(0);
        make.height.offset(38);
        make.width.offset(100);
        make.bottom.offset(-20);
    }];
    [self.commitBtn layoutIfNeeded];
//    [self parseAppraiseTagExt:1.0];
//
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(topAction:)];
    [self addGestureRecognizer:tapGr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)topAction:(UITapGestureRecognizer *)gesture {
    [self endEditing:YES];
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
- (void)setEnquiryInvite:(NSDictionary *)enquiryInvite withModel:(nonnull HDMessage *)message{
    _model = message;
    NSLog(@"=============%@",enquiryInvite);
    if ([[enquiryInvite allKeys] containsObject:@"enquiryTags"] && [[enquiryInvite valueForKey:@"enquiryTags"] isKindOfClass:[NSDictionary class]]) {
        
        _enquiryTags = [enquiryInvite valueForKey:@"enquiryTags"];
    }
    if ([[enquiryInvite allKeys] containsObject:@"enquiryOptions"] && [[enquiryInvite valueForKey:@"enquiryOptions"] isKindOfClass:[NSArray class]]) {
        
        NSArray *enquiryOptions = [NSArray yy_modelArrayWithClass:[HDEnquiryOptionModel class] json:[enquiryInvite valueForKey:@"enquiryOptions"]];
        NSLog(@"-%@",enquiryOptions);
        
        if (enquiryOptions) {
            
            _enquiryOptions = enquiryOptions;
            [self initData];
        
        }
    }
  
}
- (void)initData{
        
    // 获取EnquiryCommentEnable
    HDEnquiryOptionModel * m3 = [self getConfigModel:@"EnquiryCommentEnable"];
    
    if ([m3.optionValue isEqualToString:@"true"]) {
        _textViewHeight = 80;
    }else{
        
        _textViewHeight = 0;
    }
    
    [self creatUI];
    
    _currentHeight = self.titleLabel.frame.size.height + self.starRateView.frame.size.height + self.evaluateTitle.frame.size.height + self.textView.frame.size.height+ self.commitBtn.frame.size.height + 64;//64 是间距
    
    if (self.updateSelfFrame) {
        self.updateSelfFrame(_currentHeight);
    }
    // 获取EnquiryInviteMsg
    HDEnquiryOptionModel * m1 = [self getConfigModel:@"EnquiryInviteMsg"];
    self.textLabel.text = m1.optionValue;
   
    // 获取EnquiryDefaultShow5Score
    HDEnquiryOptionModel * m4 = [self getConfigModel:@"EnquiryDefaultShow5Score"];
    if ([m4.optionValue isEqualToString:@"true"]) {
        self.starRateView.scorePercent = 1;
        [self getEnquiryTagData:@"5"];
    }else{
        self.starRateView.scorePercent = -1;
        self.evaluateTitle.text = @"";
    }
    
    
}
- (HDEnquiryOptionModel *)getConfigModel:(NSString *)tagname{
    
    __block HDEnquiryOptionModel * model;
    [_enquiryOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HDEnquiryOptionModel * m = obj;
        
        NSLog(@"======%@",m.optionName);
        if ([m.optionName isEqualToString:tagname]) {
            
            model = m;
            
            *stop =YES;
        }

        
    }];
     
    return model;
    
}

//循环添加 标签
- (void )hd_calculateAppraiseTags:(NSArray *)appraiseTags{
    
    if (self.currentTags) {
        
        [self.currentTags removeAllObjects];
    }
    if (self.evaluationTagView) {
        [self.evaluationTagView removeAllTags];
    }
    if (self.evaluationTagsArray) {
        [self.evaluationTagsArray removeAllObjects];
    }
    [appraiseTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        HDEnquiryTagModel * model = obj;
        [self.currentTags addObject:model];
        SKTag *tag = [[SKTag alloc] initWithText:model.tagName];
        tag.tagId = [model.tagId integerValue];
        tag.font = [UIFont systemFontOfSize:14];
        tag.textColor = [[HDAppSkin mainSkin] contentColor555555];
        tag.bgColor = [[HDAppSkin mainSkin] contentColorF0F0F0];
        tag.cornerRadius = 10;
        tag.enable = YES;
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        [self.evaluationTagView addTag:tag];
    }];
}
- (CGFloat)hd_textBoundingRectWithSize:(NSString *)text{
    
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake(self.starRateView.frame.size.width, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19]} context:nil].size.height;
    
    return textH;
}
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    [self parseAppraiseTagExt:newScorePercent];
}

- (void)parseAppraiseTagExt:(CGFloat)ScorePercent{
    
    
    
    
    NSString *score;
                if (ScorePercent == 1.0) {
                    self.evaluateTitle.text = NSLocalizedString(@"video.satisfaction.EnquiryTagsFor5Score", @"EnquiryTagsFor5Score");
                    
                    score = @"5";
                    
                } else if (ScorePercent == 0.8) {
                    self.evaluateTitle.text = NSLocalizedString(@"video.satisfaction.EnquiryTagsFor4Score", @"EnquiryTagsFor4Score");
                    score = @"4";
                } else if (ScorePercent == 0.6) {
                    self.evaluateTitle.text = NSLocalizedString(@"video.satisfaction.EnquiryTagsFor3Score", @"EnquiryTagsFor3Score");
                    score = @"3";
                } else if (ScorePercent == 0.4) {
                    self.evaluateTitle.text = NSLocalizedString(@"video.satisfaction.EnquiryTagsFor2Score", @"EnquiryTagsFor2Score");
                    score = @"2";
                } else if (ScorePercent == 0.2) {
                    self.evaluateTitle.text = NSLocalizedString(@"video.satisfaction.EnquiryTagsFor1Score", @"EnquiryTagsFor1Score");
                    score = @"1";
                }

    [self getEnquiryTagData:score];
    
    
}


-(void)getEnquiryTagData:(NSString *)score{
    
    if ([[_enquiryTags allKeys] containsObject:score]) {
        
    NSArray * array = [_enquiryTags valueForKey:score];
    NSArray *tags = [NSArray yy_modelArrayWithClass:[HDEnquiryTagModel class] json:array];
    if (tags &&tags.count > 0) {
    
        // 添加 view
        [self.bgView addSubview:self.evaluationTagView];
        
        //顺序不能混 如果混了 会导致获取的当前行数 不准确
        
        [self hd_calculateAppraiseTags:tags];
        
        [self.evaluationTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.evaluateTitle.mas_bottom).offset(0);
            make.leading.offset(20);
            make.trailing.offset(-20);
            make.bottom.mas_equalTo(self.textView.mas_top).offset(-10);
        }];
        [self.evaluationTagView layoutIfNeeded];
    
        NSLog(@"当前多少行%ld",(long)self.evaluationTagView.currentLineCount);
        
        CGFloat h =  self.evaluationTagView.regularHeight  *self.evaluationTagView.currentLineCount + kViewSpace;
        
        if (self.updateSelfFrame) {

            self.updateSelfFrame(h + _currentHeight);
        }
        
        kWeakSelf
        self.evaluationTagView.didTapTagAtButton = ^(UIButton *button, NSUInteger buttonId) {
            
            button.selected = !button.selected;
        
            if (button.isSelected) {
                [button setTitleColor: [[HDAppSkin mainSkin] contentColorBlueHX] forState: UIControlStateNormal];
//                button.titleLabel.textColor = [[HDAppSkin mainSkin] contentColorBlueHX] ;
                button.backgroundColor = [[HDAppSkin mainSkin] contentColorE2EDFD];
                [weakSelf clickEvaluationTagSelectWithArray:buttonId WithSelect:YES];
                
            }else{
//                button.titleLabel.textColor = [[HDAppSkin mainSkin] contentColorBlueHX] ;
                [button setTitleColor: [[HDAppSkin mainSkin] contentColor555555] forState: UIControlStateNormal];
                button.backgroundColor = [[HDAppSkin mainSkin] contentColorF0F0F0];
                [weakSelf clickEvaluationTagSelectWithArray:buttonId WithSelect:NO];
            }
            
               
        };
       
        
    }
    }else{
       
        if (self.evaluationTagView) {
            [self.evaluationTagView removeFromSuperview];
            self.evaluationTagView = nil;
        }
        if (self.updateSelfFrame) {
            self.updateSelfFrame( _currentHeight);
        }

    }
}


#pragma mark - getter


- (UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor =[[HDAppSkin mainSkin] contentColor555555];
        _titleLabel.text = @"请对我的服务进行评价：";
        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _titleLabel;
}
- (UILabel*)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor  =[[HDAppSkin mainSkin] contentColor555555];
        _textLabel.numberOfLines =1;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _textLabel;
}
- (UILabel*)msgLabel
{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.text = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor =[[HDAppSkin mainSkin] contentColor555555];
//        _msgLabel.text = @"please evaluate my service:";
        _msgLabel.numberOfLines =0;
        _msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _msgLabel.font = [UIFont systemFontOfSize:18];
//        _textLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _msgLabel;
}
- (CWStarRateView*)starRateView
{
    if (_starRateView == nil) {
//        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + kViewSpace, kHDScreenWidth - 20, 40) numberOfStars:5];
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(40,64,[UIScreen mainScreen].bounds.size.width - 100, 40) numberOfStars:5];
//        _starRateView.scorePercent = 1.0;
        
        _starRateView.scorePercent = -1; //标示 没有默认选中的星
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = YES;
        _starRateView.delegate = self;
//        _starRateView.backgroundColor = [UIColor blueColor];
    }
    return _starRateView;
}

- (UILabel *)evaluateTitle
{
    if (_evaluateTitle == nil) {
        _evaluateTitle = [[UILabel alloc] init];
        _evaluateTitle.textAlignment = NSTextAlignmentCenter;
        _evaluateTitle.font = [UIFont systemFontOfSize:16];
        [_evaluateTitle setTextColor:[ [HDAppSkin mainSkin] contentColorF2AC3C]];
        _evaluateTitle.text = @"非常满意";
//        _evaluateTitle.backgroundColor = [UIColor blackColor];
    }
    return _evaluateTitle;
}

- (UITextView*)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        
        _textView.layer.borderColor =  [[HDAppSkin mainSkin] contentColorF0F0F0].CGColor;
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.borderWidth = 0.5;
        _textView.textColor  =[[HDAppSkin mainSkin] contentColor555555];
        _textView.backgroundColor = [[HDAppSkin mainSkin] contentColorF0F0F0];
        
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
        _placeHolderLabel= placeHolderLabel;
    }
    return _textView;
}

- (SKTagView *)evaluationTagView
{
    if (_evaluationTagView == nil) {
//        _evaluationTagView = [[HDSatisfactionEvaluationTagView alloc] init];
//        _evaluationTagView.delegate = self;
        _evaluationTagView = [[SKTagView alloc] init];
        _evaluationTagView.preferredMaxLayoutWidth = self.starRateView.frame.size.width;
        _evaluationTagView.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        _evaluationTagView.lineSpacing = 5;
        _evaluationTagView.regularHeight = 30;
        _evaluationTagView.interitemSpacing = 20;
    }
    return _evaluationTagView;
}

- (UIButton*)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:NSLocalizedString(@"video.satisfaction.Commit", @"commit") forState:UIControlStateNormal];
//        [_commitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 5.f;
        [_commitBtn setBackgroundColor:[[HDAppSkin mainSkin] contentColorBlueHX]];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}


#pragma mark - action
- (void)commit{
    // 查询 对应 星级 必填项
    //当前点击的星
    int score = _starRateView.scorePercent*5;
    NSString * optionName = [NSString stringWithFormat:@"EnquiryTagsFor%dScore",score];
    NSString * commentName = [NSString stringWithFormat:@"EnquiryCommentFor%dScore",score];
    
    if (score == 0) {
        
        // 弹tost
//        [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.satisfaction.score", @"video.satisfaction.score")  withWindow:[HDAgoraCallManager shareInstance].currentWindow];
        [MBProgressHUD  showSuccess:NSLocalizedString(@"video.satisfaction.score", @"video.satisfaction.score") toView:self.superview];
        return;
    }
    
    HDEnquiryOptionModel *model = [self getConfigModel:optionName];
    
    // 标签必选
    if ([model.optionValue isEqualToString:@"true"]) {
        // 判断 标签有么有选
        if (self.evaluationTagsArray.count > 0) {
            
        }else{
//            [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.satisfaction.ags_nessary", @"video.satisfaction.ags_nessary")  withWindow:[HDAgoraCallManager shareInstance].currentWindow];
//
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.satisfaction.ags_nessary", @"video.satisfaction.ags_nessary") toView:self.superview];
            return;
            
        }
    }
    HDEnquiryOptionModel *model1 = [self getConfigModel:@"EnquiryCommentEnable"];
    HDEnquiryOptionModel *model2 = [self getConfigModel:commentName];
    
    if ([model1.optionValue isEqualToString:@"true"] && [model2.optionValue isEqualToString:@"true"]) {
        
        if (self.textView.text.length > 0) {
      
        }else{
                     
            // 弹tost
//            [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.satisfaction.comment_nessary", @"video.satisfaction.comment_nessary")  withWindow:[HDAgoraCallManager shareInstance].currentWindow];
            [MBProgressHUD  showSuccess:NSLocalizedString(@"video.satisfaction.comment_nessary", @"video.satisfaction.comment_nessary") toView:self.superview];
            
            return;
            
        }
    }

    NSString * comment = self.textView.text;
    
    //调用 提交接口
    [self evaluationTagSelectWithArray:self.evaluationTagsArray];
    
//    MBProgressHUD *hud=  [MBProgressHUD  showMessag:@"" toView:[HDAgoraCallManager shareInstance].currentWindow];
    MBProgressHUD *hud=  [MBProgressHUD  showMessag:@"" toView:self.superview];
    
    
    NSString * rtcSessionId= [self getRtcSessionId];
    
    [[HDClient sharedClient].callManager hd_submitVisitorEnquirySessionid:rtcSessionId withScore:score withComment:comment withTagData:self.evaluationTagsArray Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (error == nil) {
            //提交成功
            
            [self addSubview:self.maskView];
            
            [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.bottom.offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
            }];
            // 获取EnquiryInviteMsg
            HDEnquiryOptionModel * m2 = [self getConfigModel:@"EnquirySolveMsg"];
            self.msgLabel.text = m2.optionValue;
            
            /**
            * 定制了延时执行的任务，不会阻塞线程，在主线程和子线程中都可以，效率较高（推荐使用）。
            * 此方式在可以在参数中选择执行的线程。
            * 是一种非阻塞的执行方式， 没有找到取消执行的方法。
            */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
                [self remove];
             });
           
            
            
        }else{
            
//            [MBProgressHUD  dismissInfo:error.errorDescription  withWindow:[HDAgoraCallManager shareInstance].currentWindow];
            
            NSString *str= [NSString stringWithFormat:@"%@",self.evaluationTagsArray];
            
            [MBProgressHUD  showSuccess:[NSString stringWithFormat:@"%@\n%@",error.errorDescription,str] toView:self.superview];
            
        }
        NSLog(@"======%@",responseObject);
            
    }];
    
}
- (NSString *)getRtcSessionId{
    
    if ([[_model.ext allKeys] containsObject:@"weichat"]) {
        
    NSDictionary *weichat = [_model.ext objectForKey:@"weichat"];
    
        if ([[weichat allKeys] containsObject:@"service_session"]) {
            
            NSDictionary *service_session = [weichat objectForKey:@"service_session"];
            if ([[service_session allKeys] containsObject:@"serviceSessionId"]) {
                
                NSString *rtcSessionId = [service_session objectForKey:@"serviceSessionId"];
                
                return rtcSessionId;
            }
        }
    }
    
    return nil;
}
- (void)remove {
   
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];

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

- (void)clickEvaluationTagSelectWithArray:(NSInteger)tagId  WithSelect:(BOOL)select
{
        
    for (int i = 0; i < self.currentTags.count; i ++) {
      
        HDEnquiryTagModel * model = self.currentTags[i];
        if ([model.tagId integerValue] == tagId) {

            if (select) {
                
                if (![self.evaluationTagsArray containsObject:model]) {
                   
                    [self.evaluationTagsArray addObject:model];
                }
               
            }else{
                
                if ([self.evaluationTagsArray containsObject:model]) {
                   
                    [self.evaluationTagsArray removeObject:model];
                }
                
            }
           
           
        }
        
    }

}


- (void)evaluationTagSelectWithArray:(NSArray *)tags
{
    NSArray * tmpArray = [[NSArray alloc] initWithArray:tags];
    if (self.evaluationTagsArray) {
        [self.evaluationTagsArray removeAllObjects];
    }
    
    for (int i = 0; i < tmpArray.count; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        HDEnquiryTagModel *model = tmpArray[i];
        [dict hd_setValue:model.tagId forKey:@"id"];
        [dict hd_setValue:model.tagName forKey:@"tagName"];
        [self.evaluationTagsArray addObject:dict];
    }

}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    
    return _bgView;
    
}
- (NSMutableArray *)currentTags{
    
    if (!_currentTags) {
        _currentTags = [[NSMutableArray alloc] init];
    }
    
    return _currentTags;
}
-(UIView *)maskView{

    if (!_maskView) {
        _maskView = [[UIView alloc] init];
//        _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        UIColor *color = [UIColor whiteColor];
        _maskView.backgroundColor = [color colorWithAlphaComponent:0.97];
        [_maskView addSubview:self.msgLabel];
        [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
            make.leading.offset(10);
            make.trailing.offset(-10);
        }];
    }
    
    return _maskView;
    
}
@end
