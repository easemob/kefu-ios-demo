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
typedef NS_ENUM (NSInteger, HDVECControlBarItemType) {
    HDVECControlBarItemTypeMute     = 1,    /** 扬声器    */
    HDVECControlBarItemTypeVideo,           /**视频  */
    HDVECControlBarItemTypeHangUp,          /**挂断 */
    HDVECControlBarItemTypeShare,           /**分享桌面 */
    HDVECControlBarItemTypeFlat,            /**互动白板 */
    HDVECControlBarItemTypeImage,            /**图片 */
    HDVECControlBarItemTypeFile,            /**文件 */
    HDVECControlBarItemTypeMore,            /**更多 */
    HDVECControlBarItemTypeMessage,            /**消息 */
};

/*
 *  创建button 类型
 */
typedef NS_ENUM (NSInteger, HDVECControlBarButtonStyle) {
    HDVECControlBarButtonStyleVideo     = 1,    /** 视频导航类型 不带文字   */
    HDVECControlBarButtonStyleUploadFile,           /**上传文件类型 带文字和图片  */
    HDVECControlBarButtonStyleVideoNew,           /**视频导航 新版界面  */
    
};
/*
 *  设置button image及背景颜色
 */
typedef NS_ENUM (NSInteger, HDVECControlBarButtonBackground) {
    HDVECControlBarButtonBackgroundRed     = 1,    /** 红色   */
    HDVECControlBarButtonBackgroundBlue,           /**蓝色  */
};
@interface HDVECControlBarModel : NSObject
@property (nonatomic, strong) NSString *name; // button 的标题
@property (nonatomic, strong) NSString *imageStr; //默认图片名字
@property (nonatomic, strong) NSString *selImageStr; //选中图片名字
@property (nonatomic, assign) HDVECControlBarItemType itemType;
@property (nonatomic, assign) BOOL  isHangUp; // 是否是挂断按钮
@property (nonatomic, assign) BOOL  isGray; // 是否是灰度功能
@property (nonatomic, assign) BOOL  isVisitorCameraOff; // 是否开启摄像头

@end

typedef void(^ClickControlBarItemBlock)(HDVECControlBarModel *barModel,UIButton *btn);

@interface HDVECControlBarView : UIView
@property(nonatomic ,assign)BOOL *isLandscape; // 判断是横竖屏 默认竖屏
@property (nonatomic, copy) ClickControlBarItemBlock clickControlBarItemBlock;
-(NSMutableArray *)hd_buttonFromArrBarModels:(NSArray <HDVECControlBarModel *>*)barModelArr
                                view:(UIView *)view withButtonType:(HDVECControlBarButtonStyle )style;

- (void)refreshView:(UIView *)view withScreen:(BOOL)landscape;
-(UIButton *)hd_bttonWithTag:(NSInteger)tag withArray:(NSArray *)array;
- (UIButton *)hd_bttonMuteWithTag;
- (void)hd_setButton:(UIButton *)button withBackground:(HDVECControlBarButtonBackground)background withSize:(NSUInteger)size withImageName:(NSString *)imageStr withSelectImage:(NSString *)selImageStr;

//角标需要的model 数据
- (void)setModel:(HDConversation *)model;
@end

NS_ASSUME_NONNULL_END
