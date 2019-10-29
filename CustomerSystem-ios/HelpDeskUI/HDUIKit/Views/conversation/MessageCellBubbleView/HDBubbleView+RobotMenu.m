//
//  EaseBubbleView+RobotMenu.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/7.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView+RobotMenu.h"


@implementation HDBubbleView (RobotMenu)

@dynamic menuInfo;

- (void)_setupRobotMenuBubbleConstraints {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_top).offset(self.margin.top);
        make.left.equalTo(self.backgroundImageView.mas_left).offset(self.margin.left);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-self.margin.right);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(5);
        make.width.equalTo(self.tableViewWidth);
    }];
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
    
    if ([self isItems]) {
        cell.item = self.options[indexPath.row];
    } else {
        cell.menu = self.options[indexPath.row];
    }
    cell.width = self.tableViewWidth + 25;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGFloat height = [self.menuTitle boundingRectWithSize:CGSizeMake(self.tableView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + 5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, height)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = self.menuTitle;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSString *text = nil;
    if ([self isItems]) {
        text = ((HDMenuItem *)self.options[indexPath.row]).menuName;
    } else {
        text = self.options[indexPath.row];
    }
    return [text boundingRectWithSize:CGSizeMake(self.tableViewWidth + 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self routerEventWithName:HRouterEventTapMenu userInfo:@{@"clickItem":self.options[indexPath.row]}];
    /*
    if ([self isItems]) {
        HDMenuItem *item = self.options[indexPath.row];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (item.menuName) {
            userInfo[@"clickText"] = item.menuName;
        }
        
        if (item.menuId) {
            userInfo[@"menuId"] = item.menuId;
        }

        if (item.isTransferManualGuide) {
            userInfo[@"isTransferManualGuide"] = @YES;
            if (item.queueId) {
                userInfo[@"queueId"] = item.queueId;
            }
            
            if (item.queueType) {
                userInfo[@"queueType"] = item.queueType;
            }
            
            if (item.queueName) {
                userInfo[@"queueName"] = item.queueName;
            }
        }
        [self routerEventWithName:HRouterEventTapMenu userInfo:userInfo];
    } else {
        [self routerEventWithName:HRouterEventTapMenu userInfo:@{@"clickText":self.options[indexPath.row]}];
    }
     */
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
    [self _setupRobotMenuBubbleConstraints];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self _setupRobotMenuBubbleConstraints];
}

- (void)setMenuInfo:(HDMenuInfo *)menuInfo {
    self.options = menuInfo.items;
    self.menuTitle = menuInfo.title;
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.tag = 1990; //tag 避免controller 拦截手势
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
    _menuLabel.text = item.menuName;
    [_menuLabel sizeToFit];
}

- (void)setMenu:(NSString *)menu {
    _menuLabel.text = menu;
    [_menuLabel sizeToFit];
    CGRect frame = _menuLabel.frame;
    CGFloat y = (CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(frame)) / 2;
    frame.origin.y = y;
    _menuLabel.frame = frame;
}
- (void)setWidth:(CGFloat)width {
    _menuLabel.width = width;
    [_menuLabel sizeToFit];
}

- (CGFloat)labelWidth {
    return CGRectGetWidth(_menuLabel.frame);
}

@end
