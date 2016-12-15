//
//  EaseBubbleView+RobotMenu.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/7.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (RobotMenu) <UITableViewDelegate,UITableViewDataSource>


- (void)setupRobotMenuBubbleView;

- (void)updateRobotMenuMargin:(UIEdgeInsets)margin;

- (void)reloadData;

@end


@interface MenuCell : UITableViewCell

@property(nonatomic,strong) NSString *menu;
@property(nonatomic,assign) CGFloat width;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
