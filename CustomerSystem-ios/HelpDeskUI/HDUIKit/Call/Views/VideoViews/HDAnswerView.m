//
//  HDAnswerView.m
//  HLtest
//
//  Created by houli on 2022/3/15.
//

#import "HDAnswerView.h"
#import "Masonry.h"
@interface HDAnswerView()
{
    NSInteger _num ;
    dispatch_source_t timer;
    NSInteger _time;
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
    [self.bgView addSubview:self.answerLabel];
   

    [self startTimer];
   

}
#pragma mark - --------- NSTimer 创建 ---------
// 开始计时
- (void)startTimer {
    _time = 0;
    _num = 0;
    _timer = [NSTimer timerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateTime {
  
    if (_num > 2) {
        _num = 0;
    }
    NSArray *array = @[@".",@"..",@"..."];
    self.answerLabel.text = [NSString stringWithFormat:@"收到视频通话%@",array[_num]];
    _num++;
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
    [self.onBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30);
        make.leading.offset(60);
        make.width.height.offset(72);
    }];
    [self.offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30);
        make.width.height.offset(72);
        make.trailing.offset(-60);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.5);
        make.width.height.offset(88);
        
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.icon.mas_centerX).offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        
    }];
    
    
}
- (UILabel *)answerLabel{
    
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.text = @"收到视频通话...";
        _answerLabel.textColor = [UIColor whiteColor];
        _answerLabel.textAlignment=NSTextAlignmentCenter;
        
        
    }
    
    return _answerLabel;
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
@end
