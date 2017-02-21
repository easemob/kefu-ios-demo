/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    UILabel *takePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets, CGRectGetMaxY(_takePicButton.frame), CGRectGetWidth(_takePicButton.frame), 20)];
    takePicLabel.backgroundColor = [UIColor clearColor];
    takePicLabel.text = NSLocalizedString(@"message.camera", @"Camera");
    takePicLabel.textAlignment = NSTextAlignmentCenter;
    takePicLabel.font = [UIFont systemFontOfSize:14.0];
    takePicLabel.textColor = [UIColor grayColor];
    [self addSubview:takePicLabel];
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, CGRectGetMaxY(_photoButton.frame), CGRectGetWidth(_photoButton.frame), 20)];
    photoLabel.backgroundColor = [UIColor clearColor];
    photoLabel.text = NSLocalizedString(@"message.image", @"Photo");
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.font = [UIFont systemFontOfSize:14.0];
    photoLabel.textColor = [UIColor grayColor];
    [self addSubview:photoLabel];
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, CGRectGetMaxY(_locationButton.frame), CGRectGetWidth(_locationButton.frame), 20)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.text = NSLocalizedString(@"message.location", @"Location");
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.font = [UIFont systemFontOfSize:14.0];
    locationLabel.textColor = [UIColor grayColor];
    [self addSubview:locationLabel];
    
    CGRect frame = self.frame;
    frame.size.height = 100;
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

@end
