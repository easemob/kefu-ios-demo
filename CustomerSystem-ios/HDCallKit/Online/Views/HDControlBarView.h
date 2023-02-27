//
//  HDControlBarView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+HDIconFont.h"
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
    HDControlBarItemTypeImage,            /**图片 */
    HDControlBarItemTypeFile,            /**文件 */
    HDControlBarItemTypeMore,            /**更多 */
    HDControlBarItemTypeMessage,            /**消息 */
};

/*
 *  创建button 类型
 */
typedef NS_ENUM (NSInteger, HDControlBarButtonStyle) {
    HDControlBarButtonStyleVideo     = 1,    /** 视频导航类型 不带文字   */
    HDControlBarButtonStyleUploadFile,           /**上传文件类型 带文字和图片  */
    HDControlBarButtonStyleVideoNew,           /**视频导航 新版界面  */
    
};
/*
 *  设置button image及背景颜色
 */
typedef NS_ENUM (NSInteger, HDControlBarButtonBackground) {
    HDControlBarButtonBackgroundRed     = 1,    /** 红色   */
    HDControlBarButtonBackgroundBlue,           /**蓝色  */
};
@interface HDControlBarModel : NSObject
@property (nonatomic, strong) NSString *name; // button 的标题
@property (nonatomic, strong) NSString *imageStr; //默认图片名字
@property (nonatomic, strong) NSString *selImageStr; //选中图片名字
@property (nonatomic, assign) HDControlBarItemType itemType;
@property (nonatomic, assign) BOOL  isHangUp; // 是否是挂断按钮
@property (nonatomic, assign) BOOL  isGray; // 是否是灰度功能
@property (nonatomic, assign) BOOL  isVisitorCameraOff; // 是否开启摄像头

@end

typedef void(^ClickControlBarItemBlock)(HDControlBarModel *barModel,UIButton *btn);

@interface HDControlBarView : UIView
@property(nonatomic ,assign)BOOL *isLandscape; // 判断是横竖屏 默认竖屏
@property (nonatomic, copy) ClickControlBarItemBlock clickControlBarItemBlock;
-(NSMutableArray *)hd_buttonFromArrBarModels:(NSArray <HDControlBarModel *>*)barModelArr
                                view:(UIView *)view withButtonType:(HDControlBarButtonStyle )style;

- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape;
-(UIButton *)hd_bttonWithTag:(NSInteger)tag withArray:(NSArray *)array;
- (UIButton *)hd_bttonMuteWithTag;
- (void)hd_setButton:(UIButton *)button withBackground:(HDControlBarButtonBackground)background withSize:(NSUInteger)size withImageName:(NSString *)imageStr withSelectImage:(NSString *)selImageStr;

//角标需要的model 数据
- (void)setModel:(HDConversation *)model;
@end

NS_ASSUME_NONNULL_END
