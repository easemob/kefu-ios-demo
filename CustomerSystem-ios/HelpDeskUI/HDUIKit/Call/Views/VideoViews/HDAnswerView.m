//
//  HDAnswerView.m
//  HLtest
//
//  Created by houli on 2022/3/15.
//

#import "HDAnswerView.h"
#import "Masonry.h"
#import "HDAppSkin.h"
@interface HDAnswerView()
{
    NSInteger _time ;
}
/**  定时器  **/
@property (nonatomic , strong)NSTimer  *timer;
@end
@implementation HDAnswerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {


        //创建ui
        [self _creatUI];
    }
    return self;
}
- (void)_creatUI{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview: self.onBtn];
    [self.bgView addSubview:self.offBtn];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.answerLabel];
    [self.bgView addSubview:self.hangUpBtn];

}
- (void)setCallType:(HDVideoCallType)callType{

    switch (callType) {
        case HDVideoCallDirectionSend:
            self.onBtn.hidden =YES;
            self.offBtn.hidden =YES;
            self.hangUpBtn.hidden=NO;
            self.timeLabel.hidden = YES;
            _answerLabel.text = NSLocalizedString(@"video.answer.send", @"您正在邀请客服进行视频通话");;

            break;
        case HDVideoCallDirectionReceive:
            [self startTimer];
            self.titleLabel.hidden = NO;
            self.hangUpBtn.hidden=YES;
            self.onBtn.hidden =NO;
            self.offBtn.hidden =NO;
            _answerLabel.text = NSLocalizedString(@"video.answer.receive", @"客服邀请您进行视频通话");

            break;

        default:
            break;
    }
    
}

#pragma mark - --------- NSTimer 创建 ---------
// 开始计时
- (void)startTimer {
    _time = 0;
    _timer = [NSTimer timerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//- (void)updateTime {
//
//    if (_num > 2) {
//        _num = 0;
//    }
//    NSArray *array = @[@".",@"..",@"..."];
//    self.answerLabel.text = [NSString stringWithFormat:@"收到视频通话%@",array[_num]];
//    _num++;
//}
- (void)updateTime {
    _time++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_time / 3600, (_time % 3600) / 60, _time % 60];
}
// 停止计时
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.2);
    }];
    [self.onBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-60);
        make.leading.offset(60);
        make.width.height.offset(72);
    }];
    [self.offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-60);
        make.width.height.offset(72);
        make.trailing.offset(-60);
    }];

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.8);
        make.width.height.offset(88);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.bottom.mas_equalTo(self.icon.mas_top).offset(-10);
        
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
    }];
    
    [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-60);
        make.width.height.offset(72);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
    }];
    
}
- (UILabel *)answerLabel{
    
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.textColor = [UIColor whiteColor];
        _answerLabel.textAlignment=NSTextAlignmentCenter;
        _answerLabel.font = [[HDAppSkin mainSkin] systemFont18pt];
    }
    
    return _answerLabel;
}
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"video.answer.title", @"视频通话");;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font =  [[HDAppSkin mainSkin] systemFont21pt];
        
        
    }
    
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}
- (UIImageView *)icon{
    
    if (!_icon) {
        _icon=[[UIImageView alloc] init];
        _icon.layer.cornerRadius = 10;
        _icon.layer.masksToBounds = YES;
        NSString * imgStr = [NSString stringWithFormat:@"HelpDeskUIResource.bundle/easemob@2x.png"];
        _icon.image = [UIImage imageNamed:imgStr];
        
    }
    return _icon;
}
- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        
    }
    return _bgView;
    
}

- (UIButton *)onBtn{
    if (!_onBtn) {
        _onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_onBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    }
    return _onBtn;
}
- (UIButton *)offBtn{
    if (!_offBtn) {
        _offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offBtn addTarget:self action:@selector(offClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_offBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
    return _offBtn;
}
- (UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hangUpBtn addTarget:self action:@selector(hangUpCallClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_hangUpBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
    return _hangUpBtn;
}
- (void)onClick:(UIButton *)sender{
    
    [self stopTimer];
    if (self.clickOnBlock) {
        self.clickOnBlock(sender);
    }
    
}
- (void)offClick:(UIButton *)sender{
    [self stopTimer];
    if (self.clickOffBlock) {
        self.clickOffBlock(sender);
    }
    
}
- (void)hangUpCallClick:(UIButton *)sender{
    [self stopTimer];
    if (self.clickHangUpBlock) {
        self.clickHangUpBlock(sender);
    }
    
}
@end
