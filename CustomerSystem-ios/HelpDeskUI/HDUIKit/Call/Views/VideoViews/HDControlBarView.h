//
//  HDControlBarView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *  功能
 */
typedef NS_ENUM (NSInteger, HDControlBarItemType) {
    HDControlBarItemTypeMute     = 1,    /** 扬声器    */
    HDControlBarItemTypeVideo,           /**视频  */
    HDControlBarItemTypeHangUp,          /**挂断 */
    HDControlBarItemTypeShare,           /**分享桌面 */
    HDControlBarItemTypeFlat,            /**互动白板 */
};
@interface HDControlBarModel : NSObject
@property (nonatomic, strong) NSString *name; // button 的标题
@property (nonatomic, strong) NSString *imageStr; //默认图片名字
@property (nonatomic, strong) NSString *selImageStr; //选中图片名字
@property (nonatomic, assign) HDControlBarItemType itemType;


@end




typedef void(^ClickControlBarItemBlock)(HDControlBarModel *barModel,UIButton *btn);

@interface HDControlBarView : UIView
@property(nonatomic ,assign)BOOL *isLandscape; // 判断是横竖屏 默认竖屏
@property (nonatomic, copy) ClickControlBarItemBlock clickControlBarItemBlock;
-(NSMutableArray *)buttonFromArrBarModels:(NSArray <HDControlBarModel *>*)barModelArr
                                view:(UIView *)view;

- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape;


@end

NS_ASSUME_NONNULL_END
