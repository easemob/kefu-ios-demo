//
//  WhiteImageInformation.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import "WhiteObject.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 白板图片信息。 */
@interface WhiteImageInformation : WhiteObject

/** 设置图片框架并初始化 `WhiteImageInformation` 对象。
 @param frame 图片框架。包括宽高以及左上角坐标（白板坐标系内）。

 @return 初始化的 `WhiteImageInformation` 对象。
*/
- (instancetype)initWithFrame:(CGRect)frame;

/** 设置图片尺寸并初始化 `WhiteImageInformation` 对象。
 @param size 图片尺寸。

 @return 初始化的 `WhiteImageInformation` 对象。
*/
- (instancetype)initWithSize:(CGSize)size;

/** 设置图片的 UUID 和框架并初始化 `WhiteImageInformation` 对象。
 @param uuid 图片的 UUID，即图片在互动白板实时房间中的唯一标识符。
 @param frame 图片框架。包括宽高以及左上角坐标（白板坐标系内）。
 @return 初始化的 `WhiteImageInformation` 对象。
*/
- (instancetype)initWithUuid:(NSString *)uuid frame:(CGRect)frame;

/** 图片的 UUID，即图片在互动白板实时房间中的唯一标识符。*/
@property (nonatomic, copy) NSString *uuid;
/** 图片的中心在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的横向坐标。 */
@property (nonatomic, assign) CGFloat centerX;
/** 图片的中心在世界坐标系（以白板初始化时的中心点为原点的坐标系）中的纵向坐标。*/
@property (nonatomic, assign) CGFloat centerY;
/** 图片的宽度，单位为像素。 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度，单位为像素。 */
@property (nonatomic, assign) CGFloat height;

/**
 是否锁定图片。 
 图片被锁定后，用户无法移动或缩放图片。 
 
 - `YES`：锁定。
 - `NO`：不锁定。
 */
@property (nonatomic, assign) BOOL locked;

@end

NS_ASSUME_NONNULL_END
