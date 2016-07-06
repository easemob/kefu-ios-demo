//
//  LeaveMsgCell.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveMsgCell : UITableViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailMsg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic) NSInteger unreadCount;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
