//
//  EMChatCustomBubbleView.m
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/30.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatCustomBubbleView.h"

#define kImageWidth 40
#define kImageHeight 70

@implementation EMChatCustomBubbleView

@synthesize nameLabel = _nameLabel;
@synthesize cimageView = _cimageView;
@synthesize priceLabel = _priceLabel;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        _topLabel.font = [UIFont systemFontOfSize:14.0];
        _topLabel.text = @"我正在看";
        _topLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_topLabel];
        
        _cimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_topLabel.frame) + 5, kImageWidth, kImageHeight)];
        [self addSubview:_cimageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_topLabel.frame) + 5, 120, 35)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_nameLabel.frame), 120, 15)];
        _priceLabel.font = [UIFont systemFontOfSize:13.0];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor redColor];
        [self addSubview:_priceLabel];
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = 3 * BUBBLE_VIEW_PADDING + kImageWidth + 120 + 30;
    CGFloat height = 2 * BUBBLE_VIEW_PADDING + kImageHeight + 20;
    
    return CGSizeMake(width, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_topLabel.frame) + 5, 150, 35);
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_nameLabel.frame) + 5, 150, 15);
    
//    CGRect frame = self.bounds;
//    frame.size.width -= BUBBLE_ARROW_WIDTH;
//    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
//    if (self.model.isSender) {
//        frame.origin.x = BUBBLE_VIEW_PADDING;
//    }else{
//        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
//    }
//    
//    frame.origin.y = BUBBLE_VIEW_PADDING;
//    
//    [_topLabel setFrame:frame];
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    _nameLabel.text = [model.message.ext objectForKey:@"title"];
    _priceLabel.text = [model.message.ext objectForKey:@"price"];
    
    UIImage *image = _model.isSender ? _model.image : _model.thumbnailImage;
    if (!image) {
        image = _model.image;
        if (!image) {
            image = [UIImage imageNamed:@"imageDownloadFail.png"];
        }
    }
    _cimageView.image = image;
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
//    [self routerEventWithName:kRouterEventAudioBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return 2 * BUBBLE_VIEW_PADDING + kImageHeight + 20;
}


@end
