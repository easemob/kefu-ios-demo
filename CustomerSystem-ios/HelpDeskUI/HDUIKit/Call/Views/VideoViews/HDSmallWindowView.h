//
//  HDSmallWindowView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDCallViewCollectionViewCellItem;

@interface HDSmallWindowView : UIView
typedef void(^ClickCellItemBlock)(HDCallViewCollectionViewCellItem *item,NSIndexPath *indexpath);
@property (nonatomic, copy) ClickCellItemBlock clickCellItemBlock;
@property (nonatomic, strong,readonly) NSArray *items;//cell 的数组
@property(nonatomic ,assign)BOOL  isLandscape; // 判断是横竖屏 默认竖屏

- (void)setItemData:(NSArray<HDCallViewCollectionViewCellItem *> *)items;
- (void)setSelectCallItemChangeVideoView:(HDCallViewCollectionViewCellItem *)item withIndex:(NSInteger )index;
- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape;
@end

NS_ASSUME_NONNULL_END
