//
//  HDVideoAnswerView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVECAnswerView.h"
#import "Masonry.h"
#import "UIImage+HDIconFont.h"
#import "HDVECAgoraCallManager.h"
#import "HDCallAppManger.h"

@interface HDVECAnswerView()
{
    NSInteger _time ;
    HDVECInitLayoutModel *_model;
}
/**  定时器  **/
@property (nonatomic , strong)NSTimer  *timer;
@end
@implementation HDVECAnswerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //创建ui
        self.backgroundColor = [[HDVECAppSkin mainSkin] contentColorBlockalpha:0.6];
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
    
    NSDictionary * dic = [[HDVECAgoraCallManager shareInstance] vec_getInitSettingData];
    HDVECInitLayoutModel * localModel = [[HDVECAgoraCallManager shareInstance] setModel:dic];
    
    if (localModel) {
        
        _model = localModel;
    }else{
        
        _model = [self vec_defaultData];
        
    }

}
- (void)hd_createUIWithCallType:(HDVECCallType)callType{
    
    switch (callType) {
        case HDVECDirectionSend:
            
            //访客主动发送视频邀请
            [self  visitorVideoUI];

            break;
        case HDVECDirectionReceive:
           
        [self agentReceiveVideoUI];
            
            break;

        default:
            break;
    }
    
    
}
- (void)visitorVideoUI{
    
    // 第一步
    if (_model.isSkipWaitingPage) {
        
        [self updateServiceLayoutConfig:_model withProcessType:HDVECProcessInitiate];
    }else{
        
        [self updateServiceLayoutConfig:_model withProcessType:HDVECProcessWaiting];
    }

//    self.onBtn.hidden =YES;
//    self.offBtn.hidden =YES;
    self.hangUpBtn.hidden=NO;
//    self.timeLabel.hidden = YES;
    self.closeBtn.hidden = NO;
//    _answerLabel.text = NSLocalizedString(@"您好！有什么需要帮助，可以发起视频通话进行咨询呦", @"您正在邀请客服进行视频通话");

}


- (void)endCallLayout{
    
    [self updateServiceLayoutConfig:_model withProcessType:HDVECProcessEnd];
    
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

- (void)setCallType:(HDVECCallType)callType{

    _callType = callType;
    switch (callType) {
        case HDVECDirectionSend:
//            self.onBtn.hidden =YES;
//            self.offBtn.hidden =YES;
//            self.hangUpBtn.hidden=NO;
//            self.timeLabel.hidden = YES;
//            _answerLabel.text = NSLocalizedString(@"video.answer.send", @"您正在邀请客服进行视频通话");;
            //访客主动发送视频邀请
            [self  visitorVideoUI];
            
            break;
        case HDVECDirectionReceive:
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
- (void)updateServiceLayoutConfig:(HDVECInitLayoutModel *)model{
    
    _model = model;
    
    [self updateServiceLayoutConfig:model withProcessType:self.processType];
    
}
- (void)updateServiceLayoutConfig:(HDVECInitLayoutModel *)model withProcessType:(HDVECProcessType)type{
    
    self.processType = type;
    NSString * titleStr;
    NSString * imageStr;
    switch (type) {
        case HDVECProcessWaiting:
            //等待
            titleStr = model.waitingPrompt;
            imageStr = model.waitingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/on.png"] forState:UIControlStateNormal];
//            [_hangUpBtn setTitle:NSLocalizedString(@"video.answer.waiting", @"发起") forState:UIControlStateNormal];
            _hangUpLabel.text = NSLocalizedString(@"video.answer.waiting", @"发起") ;
            self.closeBtn.hidden = NO;
            break;
        case HDVECProcessInitiate:
            //发起页面
            titleStr = model.callingPrompt;
            imageStr = model.callingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/off.png"] forState:UIControlStateNormal];
//            [_hangUpBtn setTitle:NSLocalizedString(@"video.answer.hangup", @"挂断") forState:UIControlStateNormal];
            _hangUpLabel.text =NSLocalizedString(@"video.answer.hangup", @"挂断");
            self.closeBtn.hidden = YES;
            
            [self startTimer];
            
            break;
        case HDVECProcessLineUp:
            //排队页面
            titleStr = model.queuingPrompt;
            imageStr = model.queuingBackgroundPic;
            self.closeBtn.hidden = YES;
            break;
        case HDVECProcessConnection:
            //接通中
//            titleStr = model.initialWelcome;
//            imageStr = model.initialWelcomeImage;
            break;
        case HDVECProcessEnd:
            //结束页面
            titleStr = model.endingPrompt;
            imageStr = model.endingBackgroundPic;
            [_hangUpBtn setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/on.png"] forState:UIControlStateNormal];
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
    if (_timer) {
        [self stopTimer];
    }
    
    _time = 0;
    _timer = [NSTimer timerWithTimeInterval:3
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateTime {
    
    [[HDClient sharedClient].callManager vec_getVisitorCurrentWaitingSessionid:nil Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        [HDLog logD:@"HD===%s responseObject==%@",__func__,responseObject];
            
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
                        
                            if (self.processType != HDVECProcessEnd) {
                                self.answerLabel.text = visitorWaitingNumber;
                            }
                            
                        }else{
                            
                            if (self.processType != HDVECProcessEnd) {
                                self.answerLabel.text = visitorWaitingNumber;
                            }
                            [self stopTimer];
                        }
                        
                    });
                    
                    
                }
                
                
            }
            
          
            
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

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.6);
        make.width.height.offset(108);
        
    }];
  
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
        make.top.offset(32);
        make.width.height.offset(44);
        make.trailing.offset(-15);
        
    }];

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
        _answerLabel.font = [[HDVECAppSkin mainSkin] systemFont16pt];
    }
    
    return _answerLabel;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"video.answer.title", @"视频通话");;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font =  [[HDVECAppSkin mainSkin] systemBoldFont21pt];
    }
    
    return _titleLabel;
}
- (UILabel *)hangUpLabel{
    
    if (!_hangUpLabel) {
        _hangUpLabel = [[UILabel alloc] init];
        _hangUpLabel.text = NSLocalizedString(@"video.answer.waiting", @"发起");
        _hangUpLabel.textColor = [UIColor whiteColor];
        _hangUpLabel.textAlignment=NSTextAlignmentCenter;
        _hangUpLabel.font =  [[HDVECAppSkin mainSkin] systemFont16pt];
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
        _nickNameLabel.font =  [[HDVECAppSkin mainSkin] systemFont16pt];
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

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(onCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        UIImage *img  = [UIImage imageWithIcon:kguanbi inFont:kfontName size:32 color:[[HDVECAppSkin mainSkin] contentColorWhitealpha:1]] ;
        [_closeBtn setImage:img forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_hangUpBtn setBackgroundColor: [UIColor redColor]];
        [_hangUpBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
         _hangUpBtn.titleLabel.font = [[HDVECAppSkin mainSkin] systemFont16pt];
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
    self.callType = HDVECDirectionSend;
    
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
    if (self.processType == HDVECProcessWaiting || self.processType == HDVECProcessEnd) {
        //更新 页面状态
//        HDVideoLayoutModel * model = [[HDVideoLayoutModel alloc] init];
        [self updateServiceLayoutConfig:_model withProcessType:HDVECProcessInitiate];
        if (self.clickVideoOnCallBlock) {
            self.clickVideoOnCallBlock(sender);
        }
    }else if(self.processType == HDVECProcessInitiate){
        
        if (self.clickOffBlock) {
            self.clickOffBlock(sender);
        }
    }
}

-(HDVECAnswerCallBackView *)answerCallBackView{
    
    if (!_answerCallBackView) {
        _answerCallBackView = [[HDVECAnswerCallBackView alloc] init];
        
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

// 没有网络的时候使用
-(HDVECInitLayoutModel *)vec_defaultData{
    
    NSString * configJosn = @"{\"channel\":{\"to\":\"kefuchannelimid_250083\",\"appKey\":\"1417220317092523#kefuchannelapp101554\"},\"functionSettings\":{\"visitorCameraOff\":false,\"skipWaitingPage\":false},\"styleSettings\":{\"waitingPrompt\":\"您好！有什么需要帮助，可以发起视频通话进行咨询呦！\",\"waitingBackgroundPic\":\"\",\"callingPrompt\":\"您好！您正在发起视频通话进行咨询。\",\"callingBackgroundPic\":\"\",\"queuingPrompt\":\"您好！客服人员正在马不停蹄的赶过来，请您耐心等待！\",\"queuingBackgroundPic\":\"\",\"endingPrompt\":\"感谢您的咨询，祝您生活愉快！\",\"endingBackgroundPic\":\"\"}}";
    
    
    NSDictionary * dic = [[HDCallAppManger shareInstance] dictWithString:configJosn];
    
    HDVECInitLayoutModel * defaultModel = [[HDVECAgoraCallManager shareInstance] setModel:dic];
    
   
    return defaultModel;
    
}
@end
