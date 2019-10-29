//
//  EaseBubbleView+RobotMenu.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/7.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView.h"

@interface HDBubbleView (RobotMenu) <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HDMenuInfo *menuInfo;

- (void)setupRobotMenuBubbleView;

- (void)updateRobotMenuMargin:(UIEdgeInsets)margin;

- (void)reloadData;

@end


@interface MenuCell : UITableViewCell

@property (nonatomic,strong) HDMenuItem *item;

@property (nonatomic,strong) NSString *menu;
@property (nonatomic,assign) CGFloat width;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)labelWidth;

@end
