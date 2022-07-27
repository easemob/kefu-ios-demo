//
//  HDVideoAnswerCallBackView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/7.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoAnswerCallBackView.h"
#import "Masonry.h"
#import "HDAppSkin.h"
#import "UIImage+HDIconFont.h"
#import "HDAgoraCallManager.h"


@interface HDVideoAnswerCallBackView()
{
    NSInteger _time ;
    HDVideoLayoutModel *_model;
}
/**  定时器  **/
@property (nonatomic , strong)NSTimer  *timer;
@end

@implementation HDVideoAnswerCallBackView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //创建ui
        self.backgroundColor = [[HDAppSkin mainSkin] contentColorBlockalpha:1];
        [self _creatUI];
    }
    return self;
}
- (void)_creatUI{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview: self.bgImageView];
    [self.bgView sendSubviewToBack:self.bgImageView];
    [self.bgView addSubview: self.onBtn];
    [self.bgView addSubview:self.offBtn];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.nickNameLabel];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.answerLabel];
    [self agentReceiveVideoUI];
    
}

- (void)agentReceiveVideoUI{
    
    [self startTimer];

    
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
    [self.onBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-66);
        make.leading.offset(60);
        make.width.height.offset(72);
    }];
    [self.offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-66);
        make.width.height.offset(72);
        make.trailing.offset(-60);
    }];

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.6);
        make.width.height.offset(108);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.bottom.mas_equalTo(self.icon.mas_top).offset(-10);
        
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
        make.bottom.mas_equalTo(self.onBtn.mas_top).offset(-5);
        
    }];
    
    
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
        _answerLabel.text = NSLocalizedString(@"video.answer.receive", @"客服邀请您进行视频通话");
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

- (UILabel *)nickNameLabel{
    
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.text = NSLocalizedString(@"个人", @"");;
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

- (UIButton *)onBtn{
    if (!_onBtn) {
        _onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onBtn addTarget:self action:@selector(onAnswerClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_onBtn setImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
        
    }
    return _onBtn;
}

- (UIButton *)offBtn{
    if (!_offBtn) {
        _offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offBtn addTarget:self action:@selector(onAnswerRefuseClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
        [_offBtn setImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
    return _offBtn;
}

- (void)onAnswerRefuseClick:(UIButton *)sender{
    
    [self stopTimer];
    if (self.clickCloseRefuseAnswerCallBlock) {
        self.clickCloseRefuseAnswerCallBlock(sender);
    }
}
- (void)onAnswerClick:(UIButton *)sender{
    [self stopTimer];
    

//    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (self.clickVideoAnswerCallBlock) {
        self.clickVideoAnswerCallBlock(sender);
    }
}
@end
