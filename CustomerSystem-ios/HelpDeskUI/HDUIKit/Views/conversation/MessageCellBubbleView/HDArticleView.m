//
//  HDArticleTableView.m
//  CustomerSystem-ios
//
//  Created by afanda on 8/3/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDArticleView.h"

@interface HDArticleView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation HDArticleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.tableView.scrollEnabled = NO;
        self.tableView.allowsSelection = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}


#pragma mark -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_delegate && [_delegate respondsToSelector:@selector(articleViewNumberOfSectionsInTableView:)]) {
        return [_delegate articleViewNumberOfSectionsInTableView:tableView];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_delegate && [_delegate respondsToSelector:@selector(articleViewTableView:numberOfRowsInSection:)]) {
        return [_delegate articleViewTableView:tableView numberOfRowsInSection:section];
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(articleViewTableView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell = [_delegate articleViewTableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate articleTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_delegate articleTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 45;
}

- (void)reloadData {
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
