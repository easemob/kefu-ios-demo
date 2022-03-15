//
//  HDAnswerView.m
//  HLtest
//
//  Created by houli on 2022/3/15.
//

#import "HDAnswerView.h"
#import "Masonry.h"
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
    
    if (self.clickOnBlock) {
        self.clickOnBlock(sender);
    }
    
}
- (void)offClick:(UIButton *)sender{
    
    if (self.clickOffBlock) {
        self.clickOffBlock(sender);
    }
    
}
@end
