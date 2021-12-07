//
//  HDMJRefreshAutoStateFooter.m
//  HDMJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "HDMJRefreshAutoStateFooter.h"
#import "HDLocalDefine.h"

@interface HDMJRefreshAutoStateFooter()
{
    __unsafe_unretained UILabel *_stateLabel;
}

@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation HDMJRefreshAutoStateFooter

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

#pragma mark - Public methords
- (void)setTitle:(NSString *)title forState:(HDMJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - Private methods
- (void)stateLabelClick
{
    if (self.state == HDMJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    [self setTitle:NSEaseLocalizedString(@"ui.clickOrPull", @"Click or pull up to download") forState:HDMJRefreshStateIdle];
    [self setTitle:NSEaseLocalizedString(@"ui.downloading", @"Downloading...") forState:HDMJRefreshStateRefreshing];
    [self setTitle:NSEaseLocalizedString(@"ui.downloadComplete", @"Download complete") forState:HDMJRefreshStateNoMoreData];
    
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
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
    
    if (self.isRefreshingTitleHidden && state == HDMJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end
