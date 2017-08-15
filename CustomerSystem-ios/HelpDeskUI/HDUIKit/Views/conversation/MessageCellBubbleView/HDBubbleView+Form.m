//
//  HDBubbleView+Form.m
//  CustomerSystem-ios
//
//  Created by 李玉召 on 10/08/2017.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDBubbleView+Form.h"

@implementation HDBubbleView (Form)

#pragma private

-(void)_setupFormBubbleMarginConstraints
{
    [self.marginConstraints removeAllObjects];
    
    //title label
    NSLayoutConstraint *formTitleWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *formTitleWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *formTitleWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:formTitleWithMarginTopConstraint];
    [self.marginConstraints addObject:formTitleWithMarginLeftConstraint];
    [self.marginConstraints addObject:formTitleWithMarginRightConstraint];
    
    
    //icon view
    
    NSLayoutConstraint *formIconWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *formIconWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    
    [self.marginConstraints addObject:formIconWithMarginBottomConstraint];
    [self.marginConstraints addObject:formIconWithMarginLeftConstraint];
    
    
    
    //desc label
    NSLayoutConstraint *formDescWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:formDescWithMarginBottomConstraint];
    
    [self addConstraints:self.marginConstraints];
    
}

- (void)_setupFormBubbleConstraints
{
    [self _setupFormBubbleMarginConstraints];
    
    
    //icon view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.formIconView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.formTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.formTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.formIconView attribute:NSLayoutAttributeRight multiplier:1.0 constant:HDMessageCellPadding]];
    
}


#pragma public

- (void) setupFormBubbleView
{
    self.formIconView = [[UIImageView alloc]init];
    self.formIconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.formIconView.backgroundColor = [UIColor clearColor];
    self.formIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundImageView addSubview:self.formIconView];
    
    self.formTitleLabel = [[UILabel alloc]init];
    self.formTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formTitleLabel.backgroundColor = [UIColor clearColor];
    self.formTitleLabel.font = [UIFont systemFontOfSize:12];
    [self.backgroundImageView addSubview:self.formTitleLabel];
    
    [self.backgroundImageView setTag:1991];
    
    self.formDescLabel = [[UILabel alloc] init];
    self.formDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formDescLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.formDescLabel];
    [self _setupFormBubbleConstraints];
}

-(void)updateFormMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupFormBubbleMarginConstraints];

}
@end
