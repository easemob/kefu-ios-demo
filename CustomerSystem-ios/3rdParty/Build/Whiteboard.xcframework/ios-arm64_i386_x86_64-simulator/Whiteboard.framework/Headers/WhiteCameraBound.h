//
//  CameraBound.h
//  WhiteSDK
//
//  Created by yleaf on 2019/9/5.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - WhiteContentScaleMode
/** 白板视角边界的缩放模式和缩放比例。 */
typedef NS_ENUM(NSUInteger, WhiteContentMode) {
    /** （默认）基于设置的 `zoomScale` 缩放视角边界。 */
    WhiteContentModeScale,
    /** 等比例缩放视角边界，使视角边界的长边正好顶住与其垂直的屏幕的两边，以保证在屏幕上完整展示视角边界。 */
    WhiteContentModeAspectFit,
    /** 等比例缩放视角边界，使视角边界的长边正好顶住与其垂直的屏幕的两边，以保证在屏幕上完整展示视角边界；在此基础上，再将视角边界缩放指定的倍数。 */
    WhiteContentModeAspectFitScale,
    /** 等比例缩放视角边界，使视角边界的长边正好顶住与其垂直的屏幕的两边；在此基础上，在视角边界的四周填充指定的空白空间。 */
    WhiteContentModeAspectFitSpace,
    /** 等比例缩放视角边界，使视角边界的短边正好顶住与其垂直的屏幕的两边，以保证视角边界铺满屏幕。 */
    WhiteContentModeAspectFill,
    /** 等比例缩放视角边界，使视角边界的短边正好顶住与其垂直的屏幕的两边，以保证视角边界铺满屏幕；在此基础上再将视角边界缩放指定的倍数。 */
    WhiteContentModeAspectFillScale,
};

#pragma mark - WhiteContentMode

/** 设置白板视角边界的缩放模式和缩放比例。 */
@interface WhiteContentModeConfig : WhiteObject

- (instancetype)init NS_UNAVAILABLE;

/** 初始化一个 `WhiteContentMode` 对象。
 @param scaleMode 视角边界的缩放模式，缩放比例默认值为 1.0，即保持视角边界的原始大小。详见 [WhiteContentMode](WhiteContentMode)。

 @return 初始化的 `WhiteContentMode` 对象。
 */
- (instancetype)initWithContentMode:(WhiteContentMode)scaleMode;

/** 视角边界的缩放模式和缩放比例。详见 [WhiteContentMode](WhiteContentMode)。 */
@property (nonatomic, assign, readonly) WhiteContentMode contentMode;
/** 视角边界的缩放比例。只有当 scaleMode 的值为 `WhiteContentModeScale`、`WhiteContentModeAspectFitScale`、`WhiteContentModeAspectFillScale` 时设置生效。 */
@property (nonatomic, assign) CGFloat scale;
/** 视角边界的缩放模式。只有当 scaleMode 为 `WhiteContentModeAspectFitSpace` 时设置生效。 */
@property (nonatomic, assign) CGFloat space;

@end

#pragma mark - WhiteCameraBound

/** 白板视角边界。 

 视角边界指白板场景内，用户可以移动视角的范围。当视角超出视角边界时，视角会被拉回。
 */
@interface WhiteCameraBound : WhiteObject

/**
 指定白板视角边界的中心点并初始化 `WhiteCameraBound` 对象。

 @param visionCenter 视角边界的中心点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的坐标。

 @param minConfig 视角边界的最小缩放设置。

 @param maxConfig 视角边界的最小缩放设置。

 @return 初始化的 `WhiteCameraBound` 对象。
 */
- (instancetype)initWithCenter:(CGPoint)visionCenter minContent:(WhiteContentModeConfig *)minConfig maxContent:(WhiteContentModeConfig *)maxConfig;

/**
 指定白板视角边界的框架并初始化 `WhiteCameraBound` 对象。

 @param visionFrame 视角边界的框架（宽和高）。

 @param minConfig 视角边界框架的最小值（Frame * miniScale）。

 @param maxConfig 视角边界框架的最大值（Frame * maxScale）。

 @return 初始化的 `WhiteCameraBound` 对象。
 */
- (instancetype)initWithFrame:(CGRect)visionFrame minContent:(WhiteContentModeConfig *)minConfig maxContent:(WhiteContentModeConfig *)maxConfig;

/** 
 设置视角边界的默认最小缩放比例。

 @param miniScale 视角边界的最小缩放比例。

 @param maxScale 视角边界的最大缩放比例。
*/
+ (instancetype)defaultMinContentModeScale:(CGFloat )miniScale maxContentModeScale:(CGFloat )maxScale;

/** 视角边界的中心点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。不填则默认为 0。 */
@property (nonatomic, nullable, strong) NSNumber *centerX;
/** 视角边界的中心点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。不填则默认为 0。*/
@property (nonatomic, nullable, strong) NSNumber *centerY;
/** 视角边界的宽度，单位为像素。如果不填，则表示无限制。 */
@property (nonatomic, nullable, strong) NSNumber *width;
/** 视角边界的高度，单位为像素。如果不填，则表示无限制。 */
@property (nonatomic, nullable, strong) NSNumber *height;

/** 视角边界的最大缩放比例。最大值无上限。详见 [WhiteContentModeConfig](WhiteContentModeConfig)。 */
@property (nonatomic, nullable, strong) WhiteContentModeConfig *maxContentMode;
/** 视角边界的最小缩放比例。最小值为 0。详见 [WhiteContentModeConfig](WhiteContentModeConfig)。*/
@property (nonatomic, nullable, strong) WhiteContentModeConfig *minContentMode;

@end

NS_ASSUME_NONNULL_END
