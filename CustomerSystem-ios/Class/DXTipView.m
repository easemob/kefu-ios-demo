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
@property (nonatomic,assign) NSInteger originWidth;

@end

@implementation DXTipView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tipLabel];
        _originWidth = frame.size.width;
        _tipLabel.size = frame.size;
        _tipLabel.width = 20.f;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (UILabel*)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor redColor];
        _tipLabel.clipsToBounds = YES;
        _tipLabel.layer.cornerRadius = 10;
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
            _tipLabel.width = 20.f;
        } else if (tipNumber.length == 2) {
            _tipLabel.width = 25.f;
        } else if (tipNumber.length == 3) {
            _tipLabel.width = 30.f;
        }
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

@end
