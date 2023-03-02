//
//  HDMiddleVideoView.m
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import "HDVECMiddleVideoView.h"
#import "HDAppSkin.h"
#import "UIImage+HDIconFont.h"
@implementation HDVECMiddleVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加背景色
        self.backgroundColor = [[HDVECAppSkin mainSkin] contentColorGray];
        
        //添加 笑脸图片
        [self addSubview:self.bgImgView];
       
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.height.offset(64);
        
    }];
    UIImage * img = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:_bgImgView.hd_size.width color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
    _bgImgView.image = img;
}
- (UIImageView *)bgImgView{
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];

    }
    return _bgImgView;
    
}

@end
