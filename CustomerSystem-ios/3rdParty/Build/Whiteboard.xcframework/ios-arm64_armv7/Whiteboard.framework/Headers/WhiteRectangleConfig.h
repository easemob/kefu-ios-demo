//
//  WhiteRectangleConfig.h
//  WhiteSDK
//
//  Created by yleaf on 2019/12/10.
//

#import "WhiteObject.h"
#import <UIKit/UIKit.h>
#import "WhiteCameraConfig.h"

NS_ASSUME_NONNULL_BEGIN

/** 配置白板的视觉矩形。 
 
 视觉矩形是用户的视角必须容纳的区域。设置好视觉矩形后，视角会自动调整到刚好可以完整展示视觉矩形所表示的范围。
 
 该方法可用于保证同样的内容在不同的设备上都可以显示完整。
 */
@interface WhiteRectangleConfig : WhiteObject

/**
 初始化一个 `WhiteRectangleConfig` 对象。 
 
 在该函数中，你需要传入 `width` 和 `height`。SDK 会根据你传入 `width` 和 `height` 计算视觉矩形左上角原点
 在世界坐标系中的位置 `originX` 和 `originY`, 即 `originX = - width / 2.0d`，`originY = - height / 2.0d`。

 该方法适用于需要快速显示完整 PPT 内容的场景。
 
 @param width 白板视觉矩形的宽度。视觉矩形的宽度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param height 白板视觉矩形的高度。视觉矩形的高度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @return 初始化的 `WhiteRectangleConfig` 对象
 */
- (instancetype)initWithInitialPosition:(CGFloat)width height:(CGFloat)height;

/**
 设置视觉矩形的动画模式初始化一个 `WhiteRectangleConfig` 对象。 

 在该函数中，你需要传入 `width`，`height` 和 `mode`。SDK 会根据你传入 `width` 和 `height` 计算视觉矩形左上角原点
 在世界坐标系中的位置 `originX` 和 `originY`, 即 `originX = - width / 2.0d`，`originY = - height / 2.0d`。

 该方法适用于需要快速显示完整 PPT 内容的场景。
 
 @param width 白板视觉矩形的宽度。视觉矩形的宽度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param height 白板视觉矩形的高度。视觉矩形的高度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param mode 视觉矩形的动画模式，详见 [AnimationMode](AnimationMode)。
 @return 初始化的 `WhiteRectangleConfig` 对象
 */
- (instancetype)initWithInitialPosition:(CGFloat)width height:(CGFloat)height animation:(WhiteAnimationMode)mode;

/**
 设置视觉矩形的坐标并初始化一个 `WhiteRectangleConfig` 对象。 

 在该函数中，你需要传入 `originX`、`originY`、`width`、`height` 和 `mode`。
 SDK 会根据你传入的 `originX`、`originY`、`width` 和 `height` 确定视觉矩形在白板坐标系（即世界坐标系）中的位置、大小和动画模式。

 @param originX 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。
 @param originY 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。
 @param width 视觉矩形的宽度。视觉矩形的宽度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param height 视觉矩形的高度。视觉矩形的高度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @return 初始化的 `WhiteRectangleConfig` 对象
 */
- (instancetype)initWithOriginX:(CGFloat)originX originY:(CGFloat)originY width:(CGFloat)width height:(CGFloat)height;

/**
 设置视觉矩形的坐标和动画模式并初始化一个 `WhiteRectangleConfig` 对象。 

 在该函数中，你需要传入 `originX`、`originY`、`width`、`height` 和 `mode`。
 SDK 会根据你传入的 `originX`、`originY`、`width`、`height` 和 `mode` 确定视觉矩形在白板坐标系（即世界坐标系）中的位置、大小和动画模式。
 
 @param originX 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。
 @param originY 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。
 @param width 视觉矩形的宽度。视觉矩形的宽度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param height 视觉矩形的高度。视觉矩形的高度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。
 @param mode 视觉矩形的动画模式，详见[WhiteAnimationMode](WhiteAnimationMode)。
 @return 初始化的 `WhiteRectangleConfig` 对象
 */
- (instancetype)initWithOriginX:(CGFloat)originX originY:(CGFloat)originY width:(CGFloat)width height:(CGFloat)height animation:(WhiteAnimationMode)mode;

/** 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。 */
@property (nonatomic, assign) CGFloat originX;

/** 视觉矩形左上角原点在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。 */
@property (nonatomic, assign) CGFloat originY;

/** 视觉矩形的宽度。视觉矩形的宽度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。 */
@property (nonatomic, assign) CGFloat width;

/** 视觉矩形的高度。视觉矩形的高度不能小于实际展示内容的宽度，否则用户将看不见超出的部分。 */
@property (nonatomic, assign) CGFloat height;

/** 视觉矩形的动画模式，详见[WhiteAnimationMode](WhiteAnimationMode)。 */
@property (nonatomic, assign) WhiteAnimationMode animationMode;

@end


NS_ASSUME_NONNULL_END
