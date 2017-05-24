//
//  EaseBubbleView+RobotMenu.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/7.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HDBubbleView.h"

@interface HDMenuItem : NSObject

@property(nonatomic,copy) NSString *menuId;
@property(nonatomic,copy) NSString *name;
@end

@interface HDBubbleView (RobotMenu) <UITableViewDelegate,UITableViewDataSource>


- (void)setupRobotMenuBubbleView;

- (void)updateRobotMenuMargin:(UIEdgeInsets)margin;

- (void)reloadData;

@end


@interface MenuCell : UITableViewCell

@property(nonatomic,strong) HDMenuItem *item;

@property(nonatomic,strong) NSString *menu;
@property(nonatomic,assign) CGFloat width;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
