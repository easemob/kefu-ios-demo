//
//  HDHiddenView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDHiddenView.h"
#import "HDAppSkin.h"
#import "UIImage+HDIconFont.h"
@implementation HDHiddenView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加背景色
        self.backgroundColor = [[HDAppSkin mainSkin] contentColorGray];
        
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
        make.width.height.offset(44);
        
    }];

}
- (UIImageView *)bgImgView{
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
//        _bgImgView.hidden = YES;
        UIImage * img = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:44 color:[[HDAppSkin mainSkin] contentColorGray1] ];
        _bgImgView.image = img;
        
    }
    return _bgImgView;
    
}


@end
