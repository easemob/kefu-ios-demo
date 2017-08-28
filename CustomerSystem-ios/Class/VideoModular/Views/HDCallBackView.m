//
//  HDCallBackView.m
//  HRTCDemo
//
//  Created by afanda on 7/27/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDCallBackView.h"

@implementation HDCallBackView

- (instancetype)init
{
    self = [super init];
    if (self) {
      self =  [self initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)addSubviewRestoreBtn {
    _restoreBtn.frame = CGRectMake(self.frame.size.width-70, 10, 60, 60);
}

- (void)addSubviewNameLabel {
    _nameLabel.frame = CGRectMake(5, self.frame.size.height-13, 150, 8);
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"minimize"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restoreCallView) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    button.hidden = YES;
    [self addSubview:button];
    _restoreBtn = button;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:8];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_nameLabel];
    
}

- (void)restoreCallView {
    if (_delegate && [_delegate respondsToSelector:@selector(restoreBtnClicked)]) {
        [_delegate restoreBtnClicked];
    }
}

@end
