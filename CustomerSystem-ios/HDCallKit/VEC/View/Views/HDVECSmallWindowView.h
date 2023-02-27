//
//  HDSmallWindowView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDVECCollectionViewCellItem;

@interface HDVECSmallWindowView : UIView
typedef void(^VECClickCellItemBlock)(HDVECCollectionViewCellItem *item,NSIndexPath *indexpath);
@property (nonatomic, copy) VECClickCellItemBlock clickCellItemBlock;
@property (nonatomic, strong,readonly) NSArray *items;//cell 的数组
@property(nonatomic ,assign)BOOL  isLandscape; // 判断是横竖屏 默认竖屏

- (void)setItemData:(NSArray<HDVECCollectionViewCellItem *> *)items;
- (void)setSelectCallItemChangeVideoView:(HDVECCollectionViewCellItem *)item withIndex:(NSInteger )index;
- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape;
- (void)reloadData;
- (void)removeCurrentCellItem:(HDVECCollectionViewCellItem *)item;
- (void)addCurrentCellItem:(HDVECCollectionViewCellItem *)item;
- (void)setAudioMuted:(HDVECCollectionViewCellItem *)item;
- (BOOL)setThirdUserdidJoined:(HDVECCollectionViewCellItem *)item;

@end

NS_ASSUME_NONNULL_END
