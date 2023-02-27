//
//  Popover.h
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, HDPopoverType) {
    HDPopoverTypeCamera    = 0,      /**  摄像头   */
    HDPopoverTypeMore,               /**  更多  */
};
typedef NS_ENUM (NSInteger, HDPopoverCellItemType) {
    HDPopoverCellItemTypeCloseCamera    = 0,     /**  关闭摄像头   */
    HDPopoverCellItemTypeChangeCamera,           /**  切换摄像头摄像头   */
    HDPopoverCellItemTypeShareScreen,            /**   屏幕共享  */
    HDPopoverCellItemTypeWhiteBoard            /**  共享白板   */
};
@interface HDPopoverViewControllerCellItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSIndexPath *indexPath;
//类型
@property (nonatomic, assign) HDPopoverCellItemType cellItemType;

@property (nonatomic, assign) BOOL isOn;//是不是 开启


@end

@interface HDPopoverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) HDPopoverType popoverType;


- (void)setDataArrayWithModel:(NSMutableArray<HDPopoverViewControllerCellItem *> *)dataArray;

- (void)reloadRows:(HDPopoverViewControllerCellItem *)item;



@end
