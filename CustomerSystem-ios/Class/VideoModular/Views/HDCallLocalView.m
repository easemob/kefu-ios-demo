//
//  HDCallLocalView.m
//  HRTCDemo
//
//  Created by afanda on 7/27/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDCallLocalView.h"

@implementation HDCallLocalView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"minimize"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restoreCallView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _restoreBtn = button;
}

- (void)restoreCallView {
    if (_delegate && [_delegate respondsToSelector:@selector(restoreBtnClicked)]) {
        [_delegate restoreBtnClicked];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
