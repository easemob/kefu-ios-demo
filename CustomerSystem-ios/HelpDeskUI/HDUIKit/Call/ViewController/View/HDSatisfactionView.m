//
//  HDSatisfactionView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDSatisfactionView.h"
#import "HDEnquiryOptionModel.h"
#import "HDEnquiryOptionModel.h"

@interface HDSatisfactionView()<UITextViewDelegate,CWStarRateViewDelegate,HEvaluationTagSelectDelegate>
{
//    HDMessage *model;
    NSDictionary *enquiryDic;
    NSArray *_enquiryOptions;
    NSDictionary *_enquiryTags;
    
    UILabel *_placeHolderLabel;
}

@end
@implementation HDSatisfactionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self creatUI];
    
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
        make.height.offset(80);
        make.bottom.offset(-74);
    }];
    [self.textView layoutIfNeeded];
    [self.bgView addSubview:self.evaluationTagView];
    [self.evaluationTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.evaluateTitle.mas_bottom).offset(0);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.mas_equalTo(self.textView.mas_top).offset(-10);
    }];
    [self.evaluationTagView layoutIfNeeded];
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
- (void)setEnquiryInvite:(NSDictionary *)enquiryInvite{
    
    NSLog(@"=============%@",enquiryInvite);
    
    if ([[enquiryInvite allKeys] containsObject:@"enquiryOptions"] && [[enquiryInvite valueForKey:@"enquiryOptions"] isKindOfClass:[NSArray class]]) {
        
//        [enquiryInvite valueForKey:@"enquiryOptions"];
    
        NSArray *enquiryOptions = [NSArray yy_modelArrayWithClass:[HDEnquiryOptionModel class] json:[enquiryInvite valueForKey:@"enquiryOptions"]];
        NSLog(@"-%@",enquiryOptions);
        
        if (enquiryOptions) {
            
            _enquiryOptions = enquiryOptions;
        }
        
        [enquiryOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HDEnquiryOptionModel * model = obj;
            
            if ([model.optionName isEqualToString:@"EnquiryInviteMsg"]) {
                
                self.textLabel.text = model.optionValue;
                
                _placeHolderLabel.text = model.optionValue;
                
            }else if([model.optionName isEqualToString:@"EnquiryInviteMsg"]){
                
                self.msgLabel.text = model.optionValue;
                
            }
            
            
            
        }];
    }
    if ([[enquiryInvite allKeys] containsObject:@"enquiryTags"] && [[enquiryInvite valueForKey:@"enquiryTags"] isKindOfClass:[NSDictionary class]]) {
        
        
        _enquiryTags = [enquiryInvite valueForKey:@"enquiryTags"];
        
        if (_enquiryTags.count == 0) {
            //默认没有标签
            [self.evaluationTagView removeFromSuperview];
            
//                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//                    make.leading.offset(10);
//                    make.trailing.offset(-10);
//                    make.bottom.offset (-10);
//
//                    CGFloat h = self.titleLabel.frame.size.height + self.starRateView.frame.size.height + self.evaluateTitle.frame.size.height + self.textView.frame.size.height+ self.commitBtn.frame.size.height;
            //                    make.height.offset(h);
//
//                }];
                
            CGFloat h = self.titleLabel.frame.size.height + self.starRateView.frame.size.height + self.evaluateTitle.frame.size.height + self.textView.frame.size.height+ self.commitBtn.frame.size.height + 64;//64 是间距
           
            if (self.updateSelfFrame) {
                self.updateSelfFrame(h);
            }
            
            
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
        _titleLabel.textColor = [UIColor lightGrayColor];
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
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.text = @"please evaluate my service:";
        _textLabel.numberOfLines =1;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.font = [UIFont systemFontOfSize:14];
//        _textLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _textLabel;
}
- (UILabel*)msgLabel
{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.text = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor = [UIColor lightGrayColor];
        _msgLabel.text = @"please evaluate my service:";
        _msgLabel.numberOfLines =1;
        _msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _msgLabel.font = [UIFont systemFontOfSize:14];
//        _textLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _msgLabel;
}
- (CWStarRateView*)starRateView
{
    if (_starRateView == nil) {
//        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + kViewSpace, kHDScreenWidth - 20, 40) numberOfStars:5];
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(40,64,[UIScreen mainScreen].bounds.size.width - 100, 40) numberOfStars:5];
        _starRateView.scorePercent = 1.0;
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
        [_evaluateTitle setTextColor:[UIColor orangeColor]];
        _evaluateTitle.text = @"非常满意";
//        _evaluateTitle.backgroundColor = [UIColor blackColor];
    }
    return _evaluateTitle;
}

- (UITextView*)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.borderWidth = 0.5;
        _textView.textColor = UIColor.blackColor;
        _textView.backgroundColor = [UIColor whiteColor];
        
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        UILabel *placeHolderLabel = [[UILabel alloc] init];
               placeHolderLabel.text = @"请输入内容";
               placeHolderLabel.numberOfLines = 0;
               placeHolderLabel.textColor = [UIColor lightGrayColor];
               [placeHolderLabel sizeToFit];
               placeHolderLabel.font = [UIFont systemFontOfSize:12];
               [_textView addSubview:placeHolderLabel];
               [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        _placeHolderLabel= placeHolderLabel;
    }
    return _textView;
}

- (UIView *)evaluationTagView
{
    if (_evaluationTagView == nil) {
//        _evaluationTagView = [[HEvaluationTagView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_evaluateTitle.frame), [UIScreen mainScreen].bounds.size.width  - 20, 60)];
        _evaluationTagView = [[HEvaluationTagView alloc] init];
        _evaluationTagView.delegate = self;
    }
    return _evaluationTagView;
}

- (UIButton*)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:NSLocalizedString(@"satisfaction.commit", @"commit") forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _commitBtn.frame = CGRectMake(20, CGRectGetMaxY(_textView.frame) + 5, kHDScreenWidth - 40, 40);
        _commitBtn.layer.cornerRadius = 5.f;
        [_commitBtn setBackgroundColor: [UIColor blueColor]];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    [self parseAppraiseTagExt:newScorePercent];
}
//
//
- (void)parseAppraiseTagExt:(CGFloat)ScorePercent{
    
                if (ScorePercent == 1.0) {
                    self.evaluateTitle.text = @" 非常满意";
                } else if (ScorePercent == 0.8) {
                    self.evaluateTitle.text = @"满意";
                } else if (ScorePercent == 0.6) {
                    self.evaluateTitle.text = @"一般";
                } else if (ScorePercent == 0.4) {
                    self.evaluateTitle.text = @"不满意";
                } else if (ScorePercent == 0.2) {
                    self.evaluateTitle.text = @"非常不满意";
                }
//    HEvaluationDegreeModel *edm = [HEvaluationDegreeModel evaluationDegreeWithDict:appraiseTagsDict];
//              self.evaluationTagView.evaluationDegreeModel = edm;
}
//{
//    if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
//        NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMessageExtWeChat];
//        if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
//            NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
//            NSLog(@"ctrlArgs--%@", ctrlArgs);
//            NSMutableArray *evaluationDegree = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_evaluationDegree];
//            NSDictionary *appraiseTagsDict = nil;
//            if (ScorePercent == 1.0) {
//                appraiseTagsDict = [evaluationDegree objectAtIndex:0];
//                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
//            } else if (ScorePercent == 0.8) {
//                appraiseTagsDict = [evaluationDegree objectAtIndex:1];
//                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
//            } else if (ScorePercent == 0.6) {
//                appraiseTagsDict = [evaluationDegree objectAtIndex:2];
//                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
//            } else if (ScorePercent == 0.4) {
//                appraiseTagsDict = [evaluationDegree objectAtIndex:3];
//                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
//            } else if (ScorePercent == 0.2) {
//                appraiseTagsDict = [evaluationDegree objectAtIndex:4];
//                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];;
//            }
//
//            HEvaluationDegreeModel *edm = [HEvaluationDegreeModel evaluationDegreeWithDict:appraiseTagsDict];
//            self.evaluationTagView.evaluationDegreeModel = edm;
//        }
//    }
//}

#pragma mark - action
- (void)commit{
        
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.leading.offset(10);
//        make.trailing.offset(-10);
//        make.bottom.offset (-10);
//        make.height.mas_equalTo(self.superview.mas_height).multipliedBy(0.8);
//
//    }];
}

//- (void)commit
//{
//    if (!_starRateView.isTap && _starRateView.scorePercent != 1) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"satisfaction.alert", @"please evaluate first") delegate:self cancelButtonTitle:NSLocalizedString(@"cancela", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"Ok"), nil];
//        [alert show];
//        return;
//    }
//    if ([self.delegate respondsToSelector:@selector(commitSatisfactionWithControlArguments:type:evaluationTagsArray:evaluationDegreeId:)]) {
//        if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
//            HDMessage *msg = self.messageModel.message;
//            NSDictionary *weichat = [msg.ext objectForKey:kMessageExtWeChat];
//            if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
//                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
//                ControlType *type = [[ControlType alloc] initWithValue:@"enquiry"];
//                ControlArguments *arguments = [ControlArguments new];
//                arguments.sessionId = [msg.ext objectForKey:kMessageExtWeChat_ctrlArgs_serviceSessionId];
//                if (!arguments.sessionId) {
//                    if (msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"]) {
//                        arguments.sessionId = msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"];
//                    }
//                }
//                arguments.inviteId = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_inviteId];
//                arguments.detail = self.textView.text;
//                arguments.summary = [NSString stringWithFormat:@"%d",(int)(_starRateView.scorePercent * 5)];
//                if (self.evaluationTagsArray.count == 0 && self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0) {
////                    [self showHint:NSLocalizedString(@"select_at_least_one_tag", @"Select at least one tag!")];
//                } else {
//                    [self.delegate commitSatisfactionWithControlArguments:arguments
//                                                                     type:type
//                                                      evaluationTagsArray:self.evaluationTagsArray evaluationDegreeId:self.evaluationTagView.evaluationDegreeModel.evaluationDegreeId];
//                }
//
//            }
//        }
//    }
//    if (self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0 &&
//        self.evaluationTagsArray.count == 0) {
//
//    } else {
////         [self back];
//    }
//
//}
-(void)textViewDidChange:(UITextView *)textView
{

    if (textView.text.length == 0) {

        self.textView.text = @"这里是要输入的placeholder文本";

    }else{

        self.textView.text = @"";

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
//        HAppraiseTagsModel *model = tags[i];
//        [dict setObject:model.appraiseTagsId forKey:@"id"];
//        [dict setObject:model.name forKey:@"name"];
//        [self.evaluationTagsArray addObject:dict];
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
//    [self.headImage.image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];

    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    
    return _bgView;
    
}
@end
