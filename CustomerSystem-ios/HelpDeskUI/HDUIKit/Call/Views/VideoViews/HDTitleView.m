//
//  HDTitleView.m
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import "HDTitleView.h"
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

        //创建ui
        [self creatUI];
    }
    return self;
}



- (void)layoutSubviews{
    
    [self updateFrame];
    
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
    
    self.infoLabel.text=text;
   
    self.timeLabel.frame = CGRectMake(self.infoLabel.frame.size.width+40, 0, self.frame.size.width-self.infoLabel.frame.size.width, self.frame.size.height);
    
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
    
    [self addSubview:self.infoLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.hideBtn];

}
- (void)updateFrame{
    
    self.infoLabel.frame =CGRectMake(20,0,64, self.frame.size.height);
    self.timeLabel.frame =CGRectMake(self.infoLabel.frame.size.width+40, 0, self.frame.size.width-self.infoLabel.frame.size.width, self.frame.size.height);
    self.hideBtn.frame =CGRectMake(self.frame.size.width-34,self.frame.size.height/2-kHideBtnHeight/2 , kHideBtnHeight, kHideBtnHeight);
    
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
//        _infoLabel.backgroundColor = [UIColor brownColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"通话中";
    }
    CGSize size = [self calculateLabelSize:_infoLabel];
    _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, _infoLabel.frame.origin.y, size.width>=200.f?200.f:size.width, self.frame.size.height);

    return _infoLabel;
}
- (UIButton *)hideBtn{
    
    if (!_hideBtn) {
        _hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-34,self.frame.size.height/2-kHideBtnHeight/2 , kHideBtnHeight, kHideBtnHeight)];
        [_hideBtn setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(clickHide:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _hideBtn;
    
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.infoLabel.frame.size.width+40, 0, self.frame.size.width-self.infoLabel.frame.size.width, self.frame.size.height)];
//        _timeLabel.backgroundColor = [UIColor brownColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
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
@end
