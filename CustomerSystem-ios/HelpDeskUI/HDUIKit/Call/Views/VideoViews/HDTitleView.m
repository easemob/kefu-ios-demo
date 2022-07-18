//
//  HDTitleView.m
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import "HDTitleView.h"
#import "UIImage+HDIconFont.h"
#define kHideBtnHeight 34
@interface HDTitleView()
{
    NSInteger _time;
}
@end
@implementation HDTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
           UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
           effectView.frame = self.bounds;
           [self addSubview:effectView];
        
//        self.backgroundColor = [[HDAppSkin mainSkin] contentColorGrayalpha:0.1];
        //创建ui
        [self creatUI];
    }
    return self;
}
- (CGSize) calculateLabelSize:(UILabel *)label{
 
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont fontWithName:label.text size:label.font.pointSize];
    label.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
    // 名字的H
    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    CGSize sizes = CGSizeMake(nameW, nameH);
    return sizes;

}

-(void)modifyInfoLabelText:(NSString *)text{
    
//    self.infoLabel.text=text;
//
//    self.timeLabel.frame = CGRectMake(self.infoLabel.frame.size.width+40, 0, self.frame.size.width-self.infoLabel.frame.size.width, self.frame.size.height);
//
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
- (void)creatUI{
    
    [self addSubview:self.zoomBtn];
    [self addSubview:self.infoLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.hideBtn];
    
    [self updateFrame];

}
- (void)updateFrame{
    

    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self).multipliedBy(0.8);
//        make.centerY.mas_equalTo(self);
//        make.width.offset(64);
        make.bottom.offset(-15);

    }];
    
    [self.zoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.infoLabel.mas_centerY).offset(0);
        make.leading.offset(10);
        make.bottom.offset(-5);
        make.width.height.offset(kHideBtnHeight);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.infoLabel.mas_centerY).offset(0);
        make.leading.mas_equalTo(self.infoLabel.mas_trailing).offset(10);

    }];
    [self.hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.infoLabel.mas_centerY).offset(0);
        make.bottom.offset(-5);
        make.trailing.offset(-20);
        make.width.height.offset(kHideBtnHeight);
    }];
    
   
    
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
//        _infoLabel.backgroundColor = [UIColor brownColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.text = NSLocalizedString(@"video.call.calling", @"通话中") ;
    }
//    CGSize size = [self calculateLabelSize:_infoLabel];
//    _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, _infoLabel.frame.origin.y, size.width>=200.f?200.f:size.width, self.frame.size.height);

    return _infoLabel;
}
- (UIButton *)hideBtn{
    
    if (!_hideBtn) {
        _hideBtn = [[UIButton alloc]init];
//        [_hideBtn setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
        UIImage * img = [UIImage imageWithIcon:kfeihuazhonghua  inFont:kfontName size:kHideBtnHeight/1.4 color:[UIColor whiteColor] ];
        [_hideBtn setImage:img forState:UIControlStateNormal];
        
        UIImage * imgSel = [UIImage imageWithIcon:khuazhonghua1 inFont:kfontName size:kHideBtnHeight/1.4 color:[UIColor whiteColor] ];
        [_hideBtn setImage:imgSel forState:UIControlStateSelected];
        
        [_hideBtn addTarget:self action:@selector(clickHide:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _hideBtn;
    
}
- (UIButton *)zoomBtn{
    
    if (!_zoomBtn) {
        _zoomBtn = [[UIButton alloc]init];
        UIImage * img = [UIImage imageWithIcon:kzoom  inFont:kfontName size:kHideBtnHeight/1.5 color:[UIColor whiteColor]];
        [_zoomBtn setImage:img forState:UIControlStateNormal];
        [_zoomBtn addTarget:self action:@selector(clickZoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomBtn;
    
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
//        _timeLabel.backgroundColor = [UIColor brownColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}

#pragma mark - event
- (void)clickHide:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSLog(@"===clickHide");
    if (self.clickHideBlock) {
        self.clickHideBlock(sender);
    }
}
- (void)clickZoomBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSLog(@"===clickZoomBtn");
    if (self.clickZoomBtnBlock) {
        self.clickZoomBtnBlock(sender);
    }
}
- (void)modifyTextColor:(UIColor *)color{
    
    _infoLabel.textColor = color;
    _timeLabel.textColor = color;
    
}
- (void)modifyIconBackColor:(UIColor *)color{
    UIImage * img1 = [UIImage imageWithIcon:kzoom  inFont:kfontName size:kHideBtnHeight/1.5 color:color ];
    [_zoomBtn setImage:img1 forState:UIControlStateNormal];
    
    UIImage * img = [UIImage imageWithIcon:kfeihuazhonghua  inFont:kfontName size:kHideBtnHeight/1.5 color:color ];
    [_hideBtn setImage:img forState:UIControlStateNormal];
    
    UIImage * imgSel = [UIImage imageWithIcon:khuazhonghua1 inFont:kfontName size:kHideBtnHeight/1.5 color:color];
    [_hideBtn setImage:imgSel forState:UIControlStateSelected];
}
@end
