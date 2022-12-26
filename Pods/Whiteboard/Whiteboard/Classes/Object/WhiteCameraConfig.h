//
//  WhiteCameraConfig.h
//  WhiteSDK
//
//  Created by yleaf on 2019/12/10.
//

#import "WhiteObject.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 移动或缩放视野时的动画模式。 */
typedef NS_ENUM(NSInteger, WhiteAnimationMode) {
    /**（默认）渐变模式。 */
    WhiteAnimationModeContinuous,
    /** 瞬间切换模式。 */
    WhiteAnimationModeImmediately,
};

#pragma mark - CameraConfig

/** 用于配置白板视角参数。
 */
@interface WhiteCameraConfig : WhiteObject

/** 视角的中心点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。不填则默认为 `0`。 */
@property (nonatomic, strong, nullable) NSNumber *centerX;
/** 视角的中心点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。不填则默认为 `0`。 */
@property (nonatomic, strong, nullable) NSNumber *centerY;

/** 视角的缩放比例。 */
@property (nonatomic, strong, nullable) NSNumber *scale;

/** 视角调整时的动画模式，默认值为 `WhiteAnimationModeContinuous`。详见 [WhiteAnimationMode](WhiteAnimationMode)。  */
@property (nonatomic, assign) WhiteAnimationMode animationMode;

@end

NS_ASSUME_NONNULL_END
