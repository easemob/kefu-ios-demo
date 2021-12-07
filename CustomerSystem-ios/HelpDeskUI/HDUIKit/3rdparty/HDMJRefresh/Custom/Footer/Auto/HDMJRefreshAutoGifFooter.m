//
//  HDMJRefreshAutoGifFooter.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "HDMJRefreshAutoGifFooter.h"

@interface HDMJRefreshAutoGifFooter()
@property (weak, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end

@implementation HDMJRefreshAutoGifFooter

#pragma mark - lazy initialization
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
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.isRefreshingTitleHidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(HDMJRefreshState)state
{
    HDMJRefreshCheckState
    
    if (state == HDMJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        [self.gifView stopAnimating];
        
        self.gifView.hidden = NO;
        if (images.count == 1) {
            self.gifView.image = [images lastObject];
        } else { 
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == HDMJRefreshStateNoMoreData || state == HDMJRefreshStateIdle) {
        [self.gifView stopAnimating];
        self.gifView.hidden = YES;
    }
}
@end

