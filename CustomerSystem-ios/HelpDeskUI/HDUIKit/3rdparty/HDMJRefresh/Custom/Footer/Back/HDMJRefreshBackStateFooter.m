//
//  HDMJRefreshBackStateFooter.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "HDMJRefreshBackStateFooter.h"
#import "HDLocalDefine.h"

@interface HDMJRefreshBackStateFooter()
{
    __unsafe_unretained UILabel *_stateLabel;
}

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation HDMJRefreshBackStateFooter

#pragma mark - Lazy initialization
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - Public methods
- (void)setTitle:(NSString *)title forState:(HDMJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(HDMJRefreshState)state {
  return self.stateTitles[@(state)];
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    [self setTitle:NSEaseLocalizedString(@"ui.pullUpToRefresh", @"Pull up to download more") forState:HDMJRefreshStateIdle];
    [self setTitle:NSEaseLocalizedString(@"ui.releaseToDownload", @"Release to download") forState:HDMJRefreshStatePulling];
    [self setTitle:NSEaseLocalizedString(@"ui.downloading", @"Downloading more...") forState:HDMJRefreshStateRefreshing];
    [self setTitle:NSEaseLocalizedString(@"ui.downloadComplete", @"Download complete") forState:HDMJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(HDMJRefreshState)state
{
    HDMJRefreshCheckState
    
    self.stateLabel.text = self.stateTitles[@(state)];
}

@end
