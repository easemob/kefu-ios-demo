//
//  HDTransformButton.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDTransformButton.h"

@implementation HDTransformButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 5.f;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitle:NSLocalizedString(@"transfertocs", @"Transfer Kefu") forState:UIControlStateNormal];
        [self addTarget:self action:@selector(transformActionImage:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return self;
}

- (void)transformActionImage:(UIButton *)sender {
    if (self.clickTransformBlock) {
        self.clickTransformBlock(sender);
    }
}
- (void)setTransformButtonBackgroundColorWithEnable:(BOOL)enable withTitle:(NSString *)title withHidden:(BOOL)hidden{
    self.backgroundColor = enable?[UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0]:[UIColor lightGrayColor];
    self.enabled = enable;
    self.hidden = hidden;
    [self setTitle:title forState:UIControlStateNormal];
}
@end
