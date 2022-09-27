//
//  HDVideoMessageView.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoMessageView.h"
#import "UIImage+HDIconFont.h"
@implementation HDVideoMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //添加背景色
        self.backgroundColor = [[HDAppSkin mainSkin] contentColorGrayWhithWite];
        
        
        //添加  标题和 关闭
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(44);
            make.top.offset(0);
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        }];
        
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.width.height.offset(26);
            make.trailing.offset(-15);
            
        }];
        
       
    }
    return self;
}
- (void)onCloseClick:(UIButton *)sender{
    
   // 关闭消息入口
    if (self.clickCloseMessageBlock) {
        self.clickCloseMessageBlock(sender);
    }
}
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
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"video.call.message", @"聊天");
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font =  [[HDAppSkin mainSkin] systemBoldFont16pt];
    }
    
    return _titleLabel;
}
@end
