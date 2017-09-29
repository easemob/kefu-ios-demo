//
//  EaseBubbleView+RobotMenu.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/7.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+RobotMenu.h"

@implementation HDMenuItem

@end

@implementation HDBubbleView (RobotMenu)

- (void)_setupRobotMenuBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];
    
    NSLayoutConstraint *robotMenuMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *robotMenuMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *robotMenuMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:robotMenuMarginTopConstraint];
    [self.marginConstraints addObject:robotMenuMarginLeftConstraint];
    [self.marginConstraints addObject:robotMenuMarginRightConstraint];
    
    [self addConstraints:self.marginConstraints];
}


- (void)_setupRobotMenuBubbleConstraints {
    [self _setupRobotMenuBubbleMarginConstraints];
    
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-self.margin.top-self.margin.bottom]];
    
}

- (void)setupRobotMenuBubbleView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.backgroundImageView addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu"];
    if (nil == cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu"];
        
    }
    cell.width = self.tableView.width;
    if ([self isItems]) {
        cell.item = self.options[indexPath.row];
    } else {
        cell.menu = self.options[indexPath.row];
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGFloat height = [self.menuTitle boundingRectWithSize:CGSizeMake(self.tableView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, height)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = self.menuTitle;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSString *text = nil;
    if ([self isItems]) {
        text = ((HDMenuItem *)self.options[indexPath.row]).name;
    } else {
        text = self.options[indexPath.row];
    }
    return [text boundingRectWithSize:CGSizeMake(self.tableView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text= nil;
    if ([self isItems]) {
        text = ((HDMenuItem *)self.options[indexPath.row]).name;
        [self routerEventWithName:HRouterEventTapMenu userInfo:@{
                                                                 @"clickText":text,
                                                                 @"menuId":((HDMenuItem *)self.options[indexPath.row]).menuId}];
    } else {
        text = self.options[indexPath.row];
        [self routerEventWithName:HRouterEventTapMenu userInfo:@{@"clickText":self.options[indexPath.row]}];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.menuTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    return [self.menuTitle boundingRectWithSize:CGSizeMake(self.tableView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
}
- (void)updateRobotMenuMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupRobotMenuBubbleConstraints];
}

- (void)reloadData {
    [self removeConstraints:self.marginConstraints];
    [self _setupRobotMenuBubbleConstraints];
    [self.tableView reloadData];
}

- (BOOL)isItems {
    if (self.options.count>0 && [self.options.firstObject isKindOfClass:[HDMenuItem class]]) {
        return YES;
    }
    return NO;
}

@end

@implementation MenuCell
{
    UILabel *_menuLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _menuLabel = [[UILabel alloc] init];
    _menuLabel.font =  [UIFont systemFontOfSize:13];
    _menuLabel.numberOfLines = 0;
    _menuLabel.textColor = [UIColor colorWithRed:242/255.0 green:83/255.0 blue:131/255.0 alpha:1];
    
    [self.contentView addSubview:_menuLabel];
}

- (void)setItem:(HDMenuItem *)item {
    _menuLabel.text = item.name;
    [_menuLabel sizeToFit];
}

- (void)setMenu:(NSString *)menu {
    _menuLabel.text = menu;
    [_menuLabel sizeToFit];
}
- (void)setWidth:(CGFloat)width {
    _menuLabel.width = width;
}

@end
