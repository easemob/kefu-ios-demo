//
//  WhiteCameraState.h
//  Whiteboard
//
//  Created by yleaf on 2021/1/20.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视角状态。
 
 @since 2.11.12
 */
@interface WhiteCameraState : WhiteObject

//@property (nonatomic, strong) NSNumber *width;
//@property (nonatomic, strong) NSNumber *height;

/**
 视角的中心点在白板坐标系（以白板初始化时的中心点为原点的坐标系）中的 X 轴坐标。初始值为 0。
 */
@property (nonatomic, strong) NSNumber *centerX;

/**
 视角的中心点在白板坐标系（以白板初始化时的中心点为原点的坐标系）中的 Y 轴坐标。初始值为 0。
 */
@property (nonatomic, strong) NSNumber *centerY;

/** 视角的缩放比例。 */
@property (nonatomic, strong) NSNumber *scale;

@end

NS_ASSUME_NONNULL_END
