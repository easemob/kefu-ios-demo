//
//  HDWhiteBoardView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/11.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 *  点击类型
 */
typedef NS_ENUM (NSInteger, HDClickButtonType) {
    HDClickButtonTypeScale     = 0,    /** 缩放   */
    HDClickButtonTypeFile,           /** 文件上传  */
    HDClickButtonTypeLogout,           /** 退出房间 */
};
typedef void(^ClickWhiteBoardViewBlock)(HDClickButtonType type,UIButton *btn);
typedef void(^FastboardDidJoinRoomSuccessBlock)();
typedef void(^FastboardDidJoinRoomFailBlock)();
@interface HDWhiteBoardView : UIView
@property (nonatomic, copy) ClickWhiteBoardViewBlock clickWhiteBoardViewBlock;
@property (nonatomic, copy) FastboardDidJoinRoomSuccessBlock fastboardDidJoinRoomSuccessBlock;
@property (nonatomic, copy) FastboardDidJoinRoomFailBlock fastboardDidJoinRoomFailBlock;

- (void)hd_ModifyStackViewLayout:(UIView *)view withScle:(BOOL)isScle;

- (void)reloadFastboardOverlayWithScle:(BOOL)isScle;

@end

NS_ASSUME_NONNULL_END
