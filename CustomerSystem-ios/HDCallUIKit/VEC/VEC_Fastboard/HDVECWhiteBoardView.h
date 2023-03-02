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
typedef NS_ENUM (NSInteger, HDVECClickButtonType) {
    HDVECClickButtonTypeScale     = 0,    /** 缩放   */
    HDVECClickButtonTypeFile,           /** 文件上传  */
    HDVECClickButtonTypeLogout,           /** 退出房间 */
};
typedef void(^HDVECClickWhiteBoardViewBlock)(HDVECClickButtonType type,UIButton *btn);
typedef void(^HDVECFastboardDidJoinRoomSuccessBlock)();
typedef void(^HDVECFastboardDidJoinRoomFailBlock)();
@interface HDVECWhiteBoardView : UIView
@property (nonatomic, copy) HDVECClickWhiteBoardViewBlock clickWhiteBoardViewBlock;
@property (nonatomic, copy) HDVECFastboardDidJoinRoomSuccessBlock fastboardDidJoinRoomSuccessBlock;
@property (nonatomic, copy) HDVECFastboardDidJoinRoomFailBlock fastboardDidJoinRoomFailBlock;

- (void)hd_ModifyStackViewLayout:(UIView *)view withScle:(BOOL)isScle;

- (void)reloadFastboardOverlayWithScle:(BOOL)isScle;

@end

NS_ASSUME_NONNULL_END
