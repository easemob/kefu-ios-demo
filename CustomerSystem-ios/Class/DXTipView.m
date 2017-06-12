//
//  DXTipView.m
//  EMCSApp
//
//  Created by EaseMob on 15/9/8.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "DXTipView.h"

@interface DXTipView()

@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *bgImageView;
@property (nonatomic,assign) NSInteger originWidth;

@end

@implementation DXTipView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.tipLabel];
        _originWidth = frame.size.width;
        _tipLabel.size = frame.size;
        _bgImageView.size = frame.size;
        _bgImageView.width = 20.f;
        _bgImageView.left = (self.width - _bgImageView.width)/2;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (UIButton*)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIButton alloc] init];
        [_bgImageView setBackgroundImage:[[UIImage imageNamed:@"tip_red_white"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
//        _bgImageView.userInteractionEnabled = NO;
//        _bgImageView.image = [[UIImage imageNamed:@"tip_red_white"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
//        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (UILabel*)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.clipsToBounds = YES;
        _tipLabel.layer.cornerRadius = 10;
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:10.0];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (void)setTipNumber:(NSString*)tipNumber
{
    _tipNumber = tipNumber;
    if (tipNumber && tipNumber.length > 0) {
        _tipLabel.text = _tipNumber;
        if (tipNumber.length == 1) {
            _bgImageView.width = 20.f;
            _bgImageView.left = (self.width - _bgImageView.width)/2;
        } else if (tipNumber.length == 2) {
            _bgImageView.width = 25.f;
            _bgImageView.left = (self.width - _bgImageView.width)/2;
        } else if (tipNumber.length == 3) {
            _bgImageView.width = 30.f;
            _bgImageView.left = (self.width - _bgImageView.width)/2;
        }
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

- (void)setTipImageNamed:(NSString *)tipImageNamed
{
//    _bgImageView.image = [UIImage imageNamed:tipImageNamed];
    [_bgImageView setBackgroundImage:[[UIImage imageNamed:tipImageNamed] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
}
@end
