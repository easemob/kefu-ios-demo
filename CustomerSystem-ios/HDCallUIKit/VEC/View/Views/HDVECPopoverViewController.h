//
//  Popover.h
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, HDVECPopoverType) {
    HDVECPopoverTypeCamera    = 0,      /**  摄像头   */
    HDVECPopoverTypeMore,               /**  更多  */
};
typedef NS_ENUM (NSInteger, HDVECPopoverCellItemType) {
    HDVECPopoverCellItemTypeCloseCamera    = 0,     /**  关闭摄像头   */
    HDVECPopoverCellItemTypeChangeCamera,           /**  切换摄像头摄像头   */
    HDVECPopoverCellItemTypeShareScreen,            /**   屏幕共享  */
    HDVECPopoverCellItemTypeWhiteBoard            /**  共享白板   */
};
@interface HDVECPopoverViewControllerCellItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSIndexPath *indexPath;
//类型
@property (nonatomic, assign) HDVECPopoverCellItemType cellItemType;

@property (nonatomic, assign) BOOL isOn;//是不是 开启


@end

@interface HDVECPopoverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) HDVECPopoverType popoverType;


- (void)setDataArrayWithModel:(NSMutableArray<HDVECPopoverViewControllerCellItem *> *)dataArray;

- (void)reloadRows:(HDVECPopoverViewControllerCellItem *)item;



@end
