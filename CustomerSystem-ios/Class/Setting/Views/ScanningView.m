//
//  ScanningView.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/13.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "ScanningView.h"

@interface ScanningView ()
@property (nonatomic,strong) UILabel  *QRCodeTipLabel; //小提示
@property (nonatomic, strong) UIImageView *scanningImageView;

@end

@implementation ScanningView

- (void)scanning {
    CGRect animationRect = self.scanningImageView.frame;
    animationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animationRect) * 2 - CGRectGetHeight(animationRect);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:FLT_MAX];
    [UIView setAnimationRepeatAutoreverses:NO];
    self.scanningImageView.hidden = NO;
    self.scanningImageView.frame = animationRect;
    [UIView commitAnimations];
}

- (void)stopScanning {
    [self.scanningImageView.layer removeAllAnimations];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        [self addSubview:self.QRCodeTipLabel];
    }
    return self;
}

- (void)setClearRect:(CGRect)clearRect {
    _clearRect = clearRect;
    [self addSubview:self.scanningImageView];
}

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.clearRect.origin.x, _clearRect.origin.y, _clearRect.size.width, 3)];
        _scanningImageView.backgroundColor = [UIColor whiteColor];
        [self scanning];
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.clearRect) + 30, CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.numberOfLines = 0;
        _QRCodeTipLabel.text = NSLocalizedString(@"qrcode_box", @"qrcode box");
        _QRCodeTipLabel.textColor = [UIColor whiteColor];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:10];
    }
    return _QRCodeTipLabel;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    CGFloat paddingX;
    CGFloat tipLabelPadding = 20;
    paddingX = _clearRect.origin.x;
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.clearRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    CGContextClearRect(context, _clearRect);
    CGContextSaveGState(context);
    CGFloat padding = 0.5;
    CGContextMoveToPoint(context, CGRectGetMinX(_clearRect) - padding, CGRectGetMinY(_clearRect) - padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(_clearRect) + padding, CGRectGetMinY(_clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(_clearRect) + padding, CGRectGetMaxY(_clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(_clearRect) - padding, CGRectGetMaxY(_clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(_clearRect) - padding, CGRectGetMinY(_clearRect) - padding);
    CGContextSetLineWidth(context, padding);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
