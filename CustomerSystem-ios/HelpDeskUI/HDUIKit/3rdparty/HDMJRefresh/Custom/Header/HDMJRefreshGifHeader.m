//
//  HDMJRefreshGifHeader.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "HDMJRefreshGifHeader.h"

@interface HDMJRefreshGifHeader()

@property (weak, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation HDMJRefreshGifHeader

#pragma mark - Lazy initialization
- (UIImageView *)gifView
{
    if (!_gifView) { 
        UIImageView *gifView = [[UIImageView alloc] init]; 
        [self addSubview:_gifView = gifView]; 
    } 
    return _gifView; 
}

- (NSMutableDictionary *)stateImages 
{ 
    if (!_stateImages) { 
        self.stateImages = [NSMutableDictionary dictionary]; 
    } 
    return _stateImages; 
}

- (NSMutableDictionary *)stateDurations 
{ 
    if (!_stateDurations) { 
        self.stateDurations = [NSMutableDictionary dictionary]; 
    } 
    return _stateDurations; 
}

#pragma mark - Public methods
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(HDMJRefreshState)state 
{ 
    if (images == nil) return; 
    
    self.stateImages[@(state)] = images; 
    self.stateDurations[@(state)] = @(duration); 
    
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) { 
        self.mj_h = image.size.height; 
    } 
}

- (void)setImages:(NSArray *)images forState:(HDMJRefreshState)state 
{ 
    [self setImages:images duration:images.count * 0.1 forState:state]; 
}

#pragma mark - Overwrite parent class methods
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(HDMJRefreshStateIdle)];
    if (self.state != HDMJRefreshStateIdle || images.count == 0) return;

    [self.gifView stopAnimating];

    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(HDMJRefreshState)state
{
    HDMJRefreshCheckState
    
    if (state == HDMJRefreshStatePulling || state == HDMJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) {
            self.gifView.image = [images lastObject];
        } else {
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == HDMJRefreshStateIdle) {
        [self.gifView stopAnimating];
    }
}

@end
