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
#define kTitleHeight 20

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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 100, 0)];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _cimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 5, kImageWidth, kImageHeight)];
        [self addSubview:_cimageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_titleLabel.frame) + 5, 120, 35)];
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
    
    NSDictionary *dic = [_model.message.ext objectForKey:@"msgtype"];
    if ([dic objectForKey:@"order"]) {
        height += kTitleHeight;
    }
    
    return CGSizeMake(width, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSDictionary *dic = [_model.message.ext objectForKey:@"msgtype"];
    if ([dic objectForKey:@"order"]) {
        _titleLabel.frame = CGRectMake(10, 25, self.frame.size.width - 20, kTitleHeight);
    }
    else{
        _titleLabel.frame = CGRectMake(10, 25, self.frame.size.width - 20, 0);
    }
     _cimageView.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 5, kImageWidth, kImageHeight);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_titleLabel.frame) + 5, 150, 35);
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_cimageView.frame) + 5, CGRectGetMaxY(_nameLabel.frame) + 5, 150, 15);
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    NSDictionary *dic = [model.message.ext objectForKey:@"msgtype"];
    NSDictionary *itemDic = [dic objectForKey:@"order"] ? [dic objectForKey:@"order"] : [dic objectForKey:@"track"];
    _topLabel.text = [itemDic objectForKey:@"title"];
    _titleLabel.text = [itemDic objectForKey:@"order_title"];
    _nameLabel.text = [itemDic objectForKey:@"desc"];
    _priceLabel.text = [itemDic objectForKey:@"price"];
    
    NSString *imageName = [model.message.ext objectForKey:@"imageName"];
    if ([imageName length] > 0) {
        _cimageView.image = [UIImage imageNamed:imageName];
    }
    else{
        _cimageView.image = [UIImage imageNamed:@"imageDownloadFail.png"];
    }
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
//    [self routerEventWithName:kRouterEventAudioBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    NSDictionary *dic = [object.message.ext objectForKey:@"msgtype"];
    if ([dic objectForKey:@"order"]){
       return 2 * BUBBLE_VIEW_PADDING + kImageHeight + kTitleHeight + 20;
    }else{
        return 2 * BUBBLE_VIEW_PADDING + kImageHeight + 20;
    }
}


@end
