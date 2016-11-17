//
//  DXBaseViewController.h
//  EMCSApp
//
//  Created by EaseMob on 15/5/11.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem *backItem;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIButton *titleBtn;

@property (strong, nonatomic) UITableView *tableView;

@end
