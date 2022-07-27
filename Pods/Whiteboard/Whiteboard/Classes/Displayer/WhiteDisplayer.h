//
//  WhiteDisplayer.h
//  WhiteSDK
//
//  Created by yleaf on 2019/7/1.
//

#import <Foundation/Foundation.h>
#import "WhiteCameraConfig.h"
#import "WhiteRectangleConfig.h"
#import "WhiteCameraBound.h"
#import "WhitePanEvent.h"
#import "WhiteFontFace.h"

typedef NS_ENUM(NSInteger, WhiteScenePathType) {
    /** 路径对应的内容为空。 */
    WhiteScenePathTypeEmpty,
    /** 路径对应的内容是一个白板页面。 */
    WhiteScenePathTypePage,
    /** 路径对应的内容是一个目录，该目录下存在目录或者多个页面。 */
    WhiteScenePathTypeDir
};

NS_ASSUME_NONNULL_BEGIN

@class WhiteScene;

 /** 该类为白板房间的基类。 */
@interface WhiteDisplayer : NSObject

/**
 @deprecated 该方法已弃用，修改白板背景色，现在可以直接设置 WhiteboardView backgroundColor 属性即可。
 */
@property (nonatomic, strong) UIColor *backgroundColor __deprecated_msg("use WhiteboardView's backgroundColor property");

#pragma mark - iframe

/**
 * 向 iframe 插件发送的关键信息。
 * @param payload 关键信息。
 */
- (void)postIframeMessage:(id)payload;

#pragma mark - 页面（场景）管理 API

/**
 查询场景路径类型。

 你可以在该方法中指定想要查询的场景路径，SDK 会返回该路径对应的场景类型。

 @param pathOrDir 场景路径类型。
 @param result 回调。返回指定场景的路径类型，详见 [WhiteScenePathType](WhiteScenePathType)。
 */
- (void)getScenePathType:(NSString *)pathOrDir result:(void (^) (WhiteScenePathType pathType))result;

/**
 * 获取房间内所有场景的信息，返回格式：
 * 场景目录路径: 对应场景目录下，所有的页面数组
 * key 为 scenePath，value 为 WhiteScene 数组。
 * 只存在 /init 的房间，返回结构为：
 * {"/": @[init WhiteScene]}

 @param result 回调。返回当前房间内所有场景的信息。
 */
- (void)getEntireScenes:(void (^) (NSDictionary<NSString *, NSArray<WhiteScene *>*> *dict))result;

#pragma mark - 自定义事件
/** 注册自定义事件监听。

 成功注册后，你可以接收到对应的自定义事件通知。

 **Note:** 对于同名的自定义事件，SDK 仅支持触发一个回调。
 
 @param eventName 想要监听的自定义事件名称。
*/
- (void)addMagixEventListener:(NSString *)eventName;

/** 注册高频自定义事件监听。
 
 成功注册后，你可以接收到对应的自定义事件通知。

 **Note:** 对于同名的自定义事件，SDK 仅支持触发一个回调。

 @param eventName 想要监听的自定义事件名称。
 
 @param millseconds SDK 触发回调的频率，单位为毫秒。该参数最小值为 500 ms，如果设置为低于该值会被重置为 500 ms。
*/
- (void)addHighFrequencyEventListener:(NSString *)eventName fireInterval:(NSUInteger)millseconds;

/** 移除自定义事件监听。
 
 @param eventName 想要移除监听的自定义事件名称。
*/
- (void)removeMagixEventListener:(NSString *)eventName;

#pragma mark - 视野坐标类 API

/** 刷新白板的界面。
 
 当 `WhiteboardView` 出现改变时，需要调用该方法刷新白板的界面。
 目前该方法 SDK 会主动调用，不再需要手动调用
 */
- (void)refreshViewSize;

/** 转换白板上点的坐标。
 
 该方法可以将 iOS 内部坐标系中的坐标转换为世界坐标系（以白板初始化时的中点为原点，横轴为 X 轴，正方向向右，纵轴为 Y 轴，正方向向下）坐标。

 @param point 点在 iOS 坐标系中的坐标。
 @param result 回调。返回点在世界坐标系上的坐标，详见 [WhitePanEvent](WhitePanEvent)。
 */
- (void)convertToPointInWorld:(WhitePanEvent *)point result:(void (^) (WhitePanEvent *convertPoint))result;

/**
 设置视角边界。

 @param cameraBound 视角边界，详见 [WhiteCameraBound](WhiteCameraBound)。
 */
- (void)setCameraBound:(WhiteCameraBound *)cameraBound;

/**
 调整视角。

 调用该方法后，SDK 会根据传入的参数调整视角。

 @param camera 视角的参数配置，详见 [WhiteCameraConfig](WhiteCameraConfig)。
 */
- (void)moveCamera:(WhiteCameraConfig *)camera;

/**
 调整视角，以保证完整显示视觉矩形。

 @param rectangle 视觉矩形的参数设置，详见 [WhiteRectangleConfig](WhiteRectangleConfig)。
 */
- (void)moveCameraToContainer:(WhiteRectangleConfig *)rectangle;

/**
 调整视角以保证完整显示 PPT 的内容。
 
 该操作为一次性操作。

 @since 2.5.1
 
 **Note:** 
 
 - 如果当前用户已经调用 [setViewMode](setViewMode) 方法并设置为 `follower`，调用该方法可能造成当前用户与主播内容不完全一致。
 - 该方法为一次性操作。如果没有插入 PPT，调用该方法不生效。

 @param mode 视角调整时的动画模式，详见 [WhiteAnimationMode](WhiteAnimationMode)。
 */
- (void)scalePptToFit:(WhiteAnimationMode)mode;

/**
 调整视角以保证完整显示 H5 课件。

 该方法为一次性操作。如果没有插入 H5 课件，调用该方法不生效。

 @since 2.12.5
 
 **Note:** 如果当前用户已经调用 [setViewMode](setViewMode) 方法并设置为 `follower`，调用该方法可能造成当前用户与主播内容不完全一致。
 */
- (void)scaleIframeToFit;

/**
 禁止/允许用户调整视角。

 @since 2.11.0

 @param disable 是否禁止用户调整视角：

 - `YES`: 禁止用户调整视角。
 - `NO`: (默认) 允许用户调整视角。
 */
- (void)disableCameraTransform:(BOOL)disable;

#pragma mark - 截图

/**
 获取特定场景的预览图。
 **Note:** 
 
 - 截取用户切换时，看到的场景内容，不是场景内全部内容。
 - 图片支持：只有当图片服务器支持跨域，才可以显示在截图中。（请真机中运行）

 @param scenePath 场景路径。
 @param completionHandler 返回指定场景的预览图。
 */
- (void)getScenePreviewImage:(NSString *)scenePath completion:(void (^)(UIImage * _Nullable image))completionHandler;


/**
 获取特定场景的截图。

 **Note:** 只有当前图片服务器支持跨区域，才能显示截图。

 @param scenePath 场景路径。
 @param completionHandler 你可以通过该接口获取 `getSceneSnapshotImage` 方法的调用结果：
 */
- (void)getSceneSnapshotImage:(NSString *)scenePath completion:(void (^)(UIImage * _Nullable image))completionHandler;

@end

NS_ASSUME_NONNULL_END
