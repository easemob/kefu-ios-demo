//
//  HDVideoAnswerView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoAnswerView.h"
#import "Masonry.h"
#import "UIImage+HDIconFont.h"
#import "HDAgoraCallManager.h"
@interface HDVideoAnswerView()
{
    NSInteger _time ;
    HDVideoLayoutModel *_model;
}
/**  定时器  **/
@property (nonatomic , strong)NSTimer  *timer;
@end
@implementation HDVideoAnswerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //创建ui
        self.backgroundColor = [[HDAppSkin mainSkin] contentColorBlockalpha:0.6];
        [self _creatUI];
    }
    return self;
}
- (void)_creatUI{
    
    
    [self addSubview:self.bgView];
    [self.bgView addSubview: self.bgImageView];
    [self.bgView sendSubviewToBack:self.bgImageView];
//    [self.bgView addSubview: self.onBtn];
//    [self.bgView addSubview:self.offBtn];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.nickNameLabel];
    [self.bgView addSubview:self.titleLabel];
//    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.answerLabel];
    [self.bgView addSubview:self.hangUpBtn];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.hangUpLabel];
    
    // 调用初始化接口
    [self getInitSetting];

}
- (void)getInitSetting{
    [[HDAgoraCallManager shareInstance] initSettingWithCompletion:^(id  responseObject, HDError * _Nonnull error) {
       
        if (error ==nil) {
            _model =  [HDAgoraCallManager shareInstance].layoutModel;
        }
    }];
}
- (void)hd_createUIWithCallType:(HDVideoType)callType{
    
    switch (callType) {
        case HDVideoDirectionSend:
            
            //访客主动发送视频邀请
            [self  visitorVideoUI];

            break;
        case HDVideoDirectionReceive:
           
        [self agentReceiveVideoUI];
            
            break;

        default:
            break;
    }
    
    
}
- (void)visitorVideoUI{
    // 第一步
    _model =  [HDAgoraCallManager shareInstance].layoutModel;
    if (_model.isSkipWaitingPage) {
        
        [self updateServiceLayoutConfig:_model withProcessType:HDVideoProcessInitiate];
    }else{
        
        [self updateServiceLayoutConfig:_model withProcessType:HDVideoProcessWaiting];
    }

//    self.onBtn.hidden =YES;
//    self.offBtn.hidden =YES;
    self.hangUpBtn.hidden=NO;
//    self.timeLabel.hidden = YES;
    self.closeBtn.hidden = NO;
//    _answerLabel.text = NSLocalizedString(@"您好！有什么需要帮助，可以发起视频通话进行咨询呦", @"您正在邀请客服进行视频通话");

}

- (void)endCallLayout{
    
    [self updateServiceLayoutConfig:_model withProcessType:HDVideoProcessEnd];
    
}
- (void)agentReceiveVideoUI{
    
    [self addSubview:self.answerCallBackView];
    [self.answerCallBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
}

- (void)setCallType:(HDVideoType)callType{

    _callType = callType;
    switch (callType) {
        case HDVideoDirectionSend:
//            self.onBtn.hidden =YES;
//            self.offBtn.hidden =YES;
//            self.hangUpBtn.hidden=NO;
//            self.timeLabel.hidden = YES;
//            _answerLabel.text = NSLocalizedString(@"video.answer.send", @"您正在邀请客服进行视频通话");;
            //访客主动发送视频邀请
            [self  visitorVideoUI];
            
            break;
        case HDVideoDirectionReceive:
//            [self startTimer];
//            self.titleLabel.hidden = NO;
//            self.hangUpBtn.hidden=YES;
//            self.onBtn.hidden =NO;
//            self.offBtn.hidden =NO;
//            _answerLabel.text = NSLocalizedString(@"video.answer.receive", @"客服邀请您进行视频通话");
            [self agentReceiveVideoUI];
            break;

        default:
            break;
    }
    
}
- (void)updateServiceLayoutConfig:(HDVideoLayoutModel *)model{
    
    _model = model;
    
    [self updateServiceLayoutConfig:model withProcessType:self.processType];
    
}
- (void)updateServiceLayoutConfig:(HDVideoLayoutModel *)model withProcessType:(HDVideoProcessType)type{
    
    self.processType = type;
    NSString * titleStr;
    NSString * imageStr;
    switch (type) {
        case HDVideoProcessWaiting:
            //等待
            titleStr = model.waitingPrompt;
            imageStr = model.waitingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
//            [_hangUpBtn setTitle:NSLocalizedString(@"video.answer.waiting", @"发起") forState:UIControlStateNormal];
            _hangUpLabel.text = NSLocalizedString(@"video.answer.waiting", @"发起") ;
            self.closeBtn.hidden = NO;
            break;
        case HDVideoProcessInitiate:
            //发起页面
            titleStr = model.callingPrompt;
            imageStr = model.callingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
//            [_hangUpBtn setTitle:NSLocalizedString(@"video.answer.hangup", @"挂断") forState:UIControlStateNormal];
            _hangUpLabel.text =NSLocalizedString(@"video.answer.hangup", @"挂断");
            self.closeBtn.hidden = YES;
            
            [self startTimer];
            
            break;
        case HDVideoProcessLineUp:
            //排队页面
            titleStr = model.queuingPrompt;
            imageStr = model.queuingBackgroundPic;
            self.closeBtn.hidden = YES;
            break;
        case HDVideoProcessConnection:
            //接通中
//            titleStr = model.initialWelcome;
//            imageStr = model.initialWelcomeImage;
            break;
        case HDVideoProcessEnd:
            //结束页面
            titleStr = model.endingPrompt;
            imageStr = model.endingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
//            [_hangUpBtn setTitle:NSLocalizedString(@"video.answer.again.waiting", @"重新发起") forState:UIControlStateNormal];
            _hangUpLabel.text = NSLocalizedString(@"video.answer.again.waiting", @"重新发起");
            self.closeBtn.hidden = NO;
            
            break;

        default:
            break;
    }
    
    //更新后台配置
    self.answerLabel.text = titleStr;
    [self.bgImageView hdSD_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
}
#pragma mark - --------- NSTimer 创建 ---------
// 开始计时
- (void)startTimer {
    _time = 0;
    _timer = [NSTimer timerWithTimeInterval:3
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateTime {
    
    [[HDClient sharedClient].callManager hd_getVisitorCurrentWaitingSessionid:nil Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
            
//        {
//          "status": "OK",
//          "entity": {
//            "waitingFlag":"true",
//            "visitorWaitingNumber": "您目前排在第 1 位",
//            "visitorWaitingTimestamp": "1655716146750"
//          }
//        }
        
        if (error == nil) {
        
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary * dic = responseObject;
                NSDictionary *  entity = [dic objectForKey:@"entity"];
                if ([[entity allKeys] containsObject:@"waitingFlag"]) {
                    
                    NSString * waitingFlag = [entity valueForKey:@"waitingFlag"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString * visitorWaitingNumber = [entity valueForKey:@"visitorWaitingNumber"];
                        if ([waitingFlag isEqualToString:@"true"]) {
                            
                           
                            
                            if (self.processType != HDVideoProcessEnd) {
                                self.answerLabel.text = visitorWaitingNumber;
                            }
                            
                        }else{
                            
                            if (self.processType != HDVideoProcessEnd) {
                                self.answerLabel.text = visitorWaitingNumber;
                            }
                            [self stopTimer];
                        }
                        
                    });
                    
                    
                }
                
                
            }
            
            NSLog(@"=====%@",responseObject);
            
        }
        
        
        
        
    }];
    
    
    
}
//- (void)updateTime {
//    _time++;
//    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_time / 3600, (_time % 3600) / 60, _time % 60];
//}
// 停止计时
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)dealloc{
    
    [_timer invalidate];
    _timer = nil;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.2);
    }];
//    [self.onBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-60);
//        make.leading.offset(60);
//        make.width.height.offset(72);
//    }];
//    [self.offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-60);
//        make.width.height.offset(72);
//        make.trailing.offset(-60);
//    }];

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.6);
        make.width.height.offset(108);
        
    }];
    
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
//        make.bottom.mas_equalTo(self.icon.mas_top).offset(-10);
//
//    }];
    
  
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.leading.offset(20);
        make.trailing.offset(-20);
//        make.bottomMargin.mas_equalTo(self.answerLabel.mas_top).offset(5);
//        make.bottom.equalTo(self.nickNameLabel.mas_top).offset(40);
        make.height.offset(44);
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.mas_equalTo(self.hangUpBtn.mas_top).offset(-5);
        
    }];
    
    [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-66);
        make.width.height.offset(66);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        
    }];
    [self.hangUpBtn layoutIfNeeded];
    
    
    [self.hangUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hangUpBtn.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.hangUpBtn.mas_centerX).offset(0);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.width.height.offset(26);
        make.trailing.offset(-15);
        
    }];
//    _hangUpBtn.titleEdgeInsets = UIEdgeInsetsMake(10, -_hangUpBtn.imageView.frame.size.width, -_hangUpBtn.imageView.frame.size.height, 0);
//    _hangUpBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 20,10);
    
//    [self initButton:_hangUpBtn];
}

/*将按钮设置为图片在上，文字在下*/
- (void)initButton:(UIButton*)btn {
    float  spacing = 4;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

- (HDVideoVerticalAlignmentLabel *)answerLabel{
    
    if (!_answerLabel) {
        _answerLabel = [[HDVideoVerticalAlignmentLabel alloc] init];
        _answerLabel.textColor = [UIColor whiteColor];
        _answerLabel.verticalAlignment = VerticalAlignmentTop;
//        _answerLabel.backgroundColor = [UIColor redColor];
        _answerLabel.textAlignment=NSTextAlignmentCenter;
        _answerLabel.numberOfLines = 0;
        _answerLabel.lineBreakMode =NSLineBreakByTruncatingTail;
        _answerLabel.font = [[HDAppSkin mainSkin] systemFont16pt];
    }
    
    return _answerLabel;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"video.answer.title", @"视频通话");;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font =  [[HDAppSkin mainSkin] systemBoldFont21pt];
    }
    
    return _titleLabel;
}
- (UILabel *)hangUpLabel{
    
    if (!_hangUpLabel) {
        _hangUpLabel = [[UILabel alloc] init];
        _hangUpLabel.text = NSLocalizedString(@"video.answer.waiting", @"发起");
        _hangUpLabel.textColor = [UIColor whiteColor];
        _hangUpLabel.textAlignment=NSTextAlignmentCenter;
        _hangUpLabel.font =  [[HDAppSkin mainSkin] systemFont16pt];
    }
    
    return _hangUpLabel;
}
- (UILabel *)nickNameLabel{
    
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.text = NSLocalizedString(@"访客昵称访客昵称", @"");;
        _nickNameLabel.textColor = [UIColor whiteColor];
//        _nickNameLabel.backgroundColor = [ UIColor redColor];
        _nickNameLabel.textAlignment=NSTextAlignmentCenter;
        _nickNameLabel.numberOfLines = 2;
        _nickNameLabel.lineBreakMode =NSLineBreakByTruncatingTail;
//        _nickNameLabel.adjustsFontSizeToFitWidth = YES;
        _nickNameLabel.font =  [[HDAppSkin mainSkin] systemFont16pt];
    }
    return _nickNameLabel;
}
//- (UILabel *)timeLabel{
//    if (!_timeLabel) {
//        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        _timeLabel.textColor = [UIColor whiteColor];
//        _timeLabel.text = @"00:00:00";
//    }
//    return _timeLabel;
//}
- (UIImageView *)icon{
    
    if (!_icon) {
        _icon=[[UIImageView alloc] init];
        _icon.layer.cornerRadius = 108/2;
        _icon.layer.masksToBounds = YES;
        NSString * imgStr = [NSString stringWithFormat:@"HelpDeskUIResource.bundle/easemob@2x.png"];
        _icon.image = [UIImage imageNamed:imgStr];
        
    }
    return _icon;
}

- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
        _bgImageView=[[UIImageView alloc] init];
        _bgImageView.backgroundColor = [UIColor blackColor];
//        _bgImageView.image = [UIImage imageNamed:@"111111"];
    }
    return _bgImageView;
}

- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        
    }
    return _bgView;
    
}

//- (UIButton *)onBtn{
//    if (!_onBtn) {
//        _onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_onBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//        //为button赋值
//        [_onBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
//    }
//    return _onBtn;
//}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(onCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        UIImage *img  = [UIImage imageWithIcon:kguanbi inFont:kfontName size:32 color:[[HDAppSkin mainSkin] contentColorWhitealpha:1]] ;
        [_closeBtn setImage:img forState:UIControlStateNormal];
    }
    return _closeBtn;
}
//- (UIButton *)offBtn{
//    if (!_offBtn) {
//        _offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_offBtn addTarget:self action:@selector(offClick:) forControlEvents:UIControlEventTouchUpInside];
//        //为button赋值
//        [_offBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
//    }
//    return _offBtn;
//}
- (UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_hangUpBtn setBackgroundColor: [UIColor redColor]];
        [_hangUpBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
         _hangUpBtn.titleLabel.font = [[HDAppSkin mainSkin] systemFont16pt];
        [_hangUpBtn addTarget:self action:@selector(onCallClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
//        [_hangUpBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
       
        [_hangUpBtn setTitle: NSLocalizedString(@"video.answer.waiting", @"发起") forState:UIControlStateNormal];
       
    }
    return _hangUpBtn;
}
- (void)onClick:(UIButton *)sender{
    
//    [self stopTimer];
  
    if (self.clickOnBlock) {
        self.clickOnBlock(sender);
    }
    self.callType = HDVideoDirectionSend;
    
}
- (void)offClick:(UIButton *)sender{
//    [self stopTimer];
    
    if (self.clickOffBlock) {
        self.clickOffBlock(sender);
    }
    
   
//    [self onCloseClick:sender];
    
}
- (void)onCloseClick:(UIButton *)sender{
    
    if (self.clickCloseCallBlock) {
        self.clickCloseCallBlock(sender);
    }
    [self removeFromSuperview];
}
- (void)onCallClick:(UIButton *)sender{
    
    //点击的时候进行第二步 真正发起通话 消息 这些
    if (self.processType == HDVideoProcessWaiting || self.processType == HDVideoProcessEnd) {
        //更新 页面状态
//        HDVideoLayoutModel * model = [[HDVideoLayoutModel alloc] init];
        [self updateServiceLayoutConfig:_model withProcessType:HDVideoProcessInitiate];
        if (self.clickVideoOnCallBlock) {
            self.clickVideoOnCallBlock(sender);
        }
    }else if(self.processType == HDVideoProcessInitiate){
        
        if (self.clickOffBlock) {
            self.clickOffBlock(sender);
        }
        
    }
   
   
}

-(HDVideoAnswerCallBackView *)answerCallBackView{
    
    if (!_answerCallBackView) {
        _answerCallBackView = [[HDVideoAnswerCallBackView alloc] init];
        
        kWeakSelf
        _answerCallBackView.clickVideoAnswerCallBlock = ^(UIButton * _Nonnull btn) {
            
            weakSelf.isAnswerCallBack = YES;
            if (weakSelf.clickOnBlock) {
                weakSelf.clickOnBlock(btn);
            }
          
            
        };
        _answerCallBackView.clickCloseRefuseAnswerCallBlock = ^(UIButton * _Nonnull btn) {
            
            if (weakSelf.clickOffBlock) {
                weakSelf.clickOffBlock(btn);
            }
            
            
        };
    }
    return _answerCallBackView;
    
    
}

@end
