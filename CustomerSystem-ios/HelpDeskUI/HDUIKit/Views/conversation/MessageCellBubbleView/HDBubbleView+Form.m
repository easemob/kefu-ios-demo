//
//  HDBubbleView+Form.m
//  CustomerSystem-ios
//
//  Created by lyz on 10/08/2017.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDBubbleView+Form.h"

@implementation HDBubbleView (Form)

#pragma private

-(void)_setupFormBubbleMarginConstraints
{
    [self.marginConstraints removeAllObjects];
    
    
    NSLayoutConstraint *formIconWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *formIconWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *formIconWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    
    //title label
    NSLayoutConstraint *formTitleWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *formTitleWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *fromTitleWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.formTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.formIconView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10];
    
    
    //desc label
    NSLayoutConstraint *formDescWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    
    NSLayoutConstraint *formDescWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *fromDescWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.formIconView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10];
    
    [self.marginConstraints addObject:formIconWithMarginTopConstraint];
    [self.marginConstraints addObject:formIconWithMarginBottomConstraint];
    [self.marginConstraints addObject:formIconWithMarginRightConstraint];
    
    [self.marginConstraints addObject:formTitleWithMarginTopConstraint];
    [self.marginConstraints addObject:formTitleWithMarginLeftConstraint];
    [self.marginConstraints addObject:fromTitleWithMarginRightConstraint];
    
    [self.marginConstraints addObject:formDescWithMarginLeftConstraint];
    [self.marginConstraints addObject:formDescWithMarginBottomConstraint];
    [self.marginConstraints addObject:fromDescWithMarginRightConstraint];
    
   
    
    
    [self addConstraints:self.marginConstraints];
    
}

- (void)_setupFormBubbleConstraints
{
    [self _setupFormBubbleMarginConstraints];
 
    //icon view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formIconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.formIconView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
 
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.formDescLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.formTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}


#pragma public

- (void) setupFormBubbleView
{
    self.formIconView = [[UIImageView alloc]init];
    self.formIconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.formIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundImageView addSubview:self.formIconView];
    
    self.formTitleLabel = [[UILabel alloc]init];
    self.formTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formTitleLabel.backgroundColor = [UIColor clearColor];
    self.formTitleLabel.font = [UIFont systemFontOfSize:13];
    self.formTitleLabel.textColor = [UIColor blackColor];
    self.formTitleLabel.numberOfLines = 1;
    [self.backgroundImageView addSubview:self.formTitleLabel];
    
    [self.backgroundImageView setTag:1991];
    
    self.formDescLabel = [[UILabel alloc] init];
    self.formDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formDescLabel.backgroundColor = [UIColor clearColor];
    self.formTitleLabel.numberOfLines = 1;
    self.formDescLabel.textColor = [UIColor grayColor];
    
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
