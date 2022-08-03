//
//  WhiteSdkConfiguration.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import "WhiteObject.h"
#import <UIKit/UIKit.h>
#import "WhiteConsts.h"


typedef NS_ENUM(NSInteger, WhiteDeviceType) {
    WhiteDeviceTypeTouch,
    WhiteDeviceTypeDesktop,
};

NS_ASSUME_NONNULL_BEGIN


typedef NSString * WhiteSdkRenderEngineKey NS_STRING_ENUM;
FOUNDATION_EXPORT WhiteSdkRenderEngineKey const WhiteSdkRenderEngineSvg;
FOUNDATION_EXPORT WhiteSdkRenderEngineKey const WhiteSdkRenderEngineCanvas;

/** 日志类型 */
typedef NSString * WhiteSDKLoggerOptionLevelKey NS_STRING_ENUM;
/** Debug 为最详细的日志，目前内容与 Info 一致 */
FOUNDATION_EXPORT WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelDebug;
/** info 主要为连接日志 */
FOUNDATION_EXPORT WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelInfo;
/** warn 主要为对开发者传入的部分不符合 sdk 参数时，进行自动调整的警告（API 弃用警告不会在上报） */
FOUNDATION_EXPORT WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelWarn;
/** error 报错，直接导致 sdk 无法正常运行的信息 */
FOUNDATION_EXPORT WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelError;

/** 是否上报日志 */
typedef NSString * WhiteSDKLoggerReportModeKey NS_STRING_ENUM;
/** 总是上报日志 */
FOUNDATION_EXPORT WhiteSDKLoggerReportModeKey const WhiteSDKLoggerReportAlways;
/** 不上报日志 */
FOUNDATION_EXPORT WhiteSDKLoggerReportModeKey const WhiteSDKLoggerReportBan;

/** 设置动态 PPT 参数。 */
@interface WhitePptParams : WhiteObject

/**
 更改动态 ppt 请求时的请求协议，可以将 https://www.exmaple.com/1.pptx 更改成 scheme://www.example.com/1.pptx

 该属性配合 iOS 11 WebKit 中 `WKWebViewConfiguration` 类的 `setURLSchemeHandler:forURLScheme:` 方法，可以对 PPT 的资源进行拦截，选择使用本地资源。
 */
@property (nonatomic, copy, nullable) NSString *scheme API_AVAILABLE(ios(11.0));

/**
 动态 PPT 服务端排版功能的开启状态。
 
 @since 2.12.25

 - `YES`：开启(默认开启)。
 - `NO`：关闭。

 @note 2021-02-10 之后转换的动态 PPT 支持服务端排版功能，可以确保不同平台排版一致。
 */
@property (nonatomic, assign) BOOL useServerWrap;

@end

/** 用于配置 `WhiteSdk` 对象。*/
@interface WhiteSdkConfiguration : WhiteObject

//+ (instancetype)defaultConfig;
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化 `WhiteSdkConfiguration` 对象。

 @param appIdentifier 白板项目的唯一标识。详见[获取白板项目的 App Identifier](https://docs.agora.io/cn/whiteboard/enable_whiteboard?platform=iOS#获取-app-identifier)。
 @return 初始化的 `WhiteSdkConfiguration` 对象。
*/
- (instancetype)initWithApp:(NSString *)appIdentifier NS_DESIGNATED_INITIALIZER;

/**
 白板项目的唯一标识。
 
 @since 2.8.0 
 */
@property (nonatomic, copy) NSString *appIdentifier;

/**
 是否监听图片加载失败事件。

  - `YES`：开启监听。
  - `NO`：（默认）关闭。

 @since 2.12.0
 */
@property (nonatomic, assign) BOOL enableImgErrorCallback;
/**
 是否启用 iframe 插件。

 - `YES`：开启。
 - `NO`：未启用。

 2.10.0 默认打开，后续版本默认关闭。
 */
@property (nonatomic, assign) BOOL enableIFramePlugin;


@property (nonatomic, assign) WhiteDeviceType deviceType;

/** 
 待回放的互动白板房间所在的数据中心。

 数据中心包括：

 - `"cn-hz"`：中国大陆
 - `"us-sv"`：美国
 - `"in-mum"`：印度
 - `"sg"`：新加坡
 - `"gb-lon"`：英国
 
 @since 2.11.0 
 */
@property (nonatomic, strong, nullable) WhiteRegionKey region;
/**
 画笔教具的渲染引擎模式。详见 [WhiteSdkRenderEngineKey](WhiteSdkRenderEngineKey)。

 @since 2.8.0
 
 2.8.0 版本新增 `canvas` 渲染引擎。从 2.9.0 版本开始，默认值为 `WhiteSdkRenderEngineCanvas`。
 */
@property (nonatomic, copy) WhiteSdkRenderEngineKey renderEngine;

/** 
 是否显示用户头像。

 - `YES`：显示。
 - `NO`：（默认）不显示。
 */
@property (nonatomic, assign) BOOL userCursor;
/** 自定义字体名称和地址。 */
@property (nonatomic, copy, nullable) NSDictionary *fonts;

/** 
 一次性加载动态 PPT 中的所有图片资源开启状态。
 2.12.20 以后，预加载功能通过重构，不在有性能和兼容问题，每次只预加载后一页内容。
 
 - `YES`：开启。
 - `NO`: （默认）未开启。
 */
@property (nonatomic, assign) BOOL preloadDynamicPPT;
/**
 是否开启图片拦截和替换功能。

 - `YES`：开启。
 - `NO`：关闭。
 */
@property (nonatomic, assign) BOOL enableInterrupterAPI;

/** 是否开启调试日志回调。

 - `YES`：开启。
 - `NO`：（默认）关闭。 
 */
@property (nonatomic, assign) BOOL log;

/**
 日志等级。

 日志级别顺序依次为 `error`、`warn`、`info`、和 `debug`。
 
 例如，选择 `info` 级别，就可以看到在 `error`、`warn`、`info` 级别上的所有日志信息。
 
 字段：值
 
 上报 debug 日志的模式，默认为`上报`。
 @"reportDebugLogMode": WhiteSDKLoggerReportModeKey
 上报质量数据的模式，默认为`上报`。
 @"reportQualityMode": WhiteSDKLoggerReportModeKey
 上报 debug 日志的等级过滤，默认为 `info`。
 @"reportLevelMask": WhiteSDKLoggerOptionLevelKey;
 在 webView console 打印 debug 日志的等级过滤，默认为 `info`。
 @"printLevelMask": WhiteSDKLoggerOptionLevelKey;
 */
@property (nonatomic, copy) NSDictionary *loggerOptions;

@property (nonatomic, assign) BOOL routeBackup __deprecated_msg("this api has no effect");

/** 动态 ppt 参数。详见 [WhitePptParams](WhitePptParams)。 */
@property (nonatomic, strong) WhitePptParams *pptParams;


@property (nonatomic, assign) BOOL disableDeviceInputs;

/**
 * 是否禁止新铅笔工具展示笔锋，默认是 `NO`。
 */
@property (nonatomic, assign) BOOL disableNewPencilStroke;

/** 独立的 SyncedStore 状态，与 globalState 类似，但是没有任何 SDK 内部的状态 */
@property (nonatomic, assign) BOOL enableSyncedStore;

/** 是否开启多窗口，默认为 false，开启后，各种 API 会进行更改。*/
@property (nonatomic, assign) BOOL useMultiViews;

@end

@implementation WhiteSdkConfiguration (Deleted)

/**
 在加入实时房间/回放房间时，将构造的 cameraBound 参数传入初始化方法中。
 具体见 WhiteDisplayer.h 中 setCameraBound API。
 */

//@property (nonatomic, assign) CGFloat zoomMinScale;
//@property (nonatomic, assign) CGFloat zoomMaxScale;

/**
 服务端连接情况配置项，可以提前使用 WhiteOriginPrefetcher 进行检测服务器连接情况，在初始化 SDK 时，直接传入。
 2.8.0 开始，sdk 算法优化，自动在请求时，选择最佳链路。该配置不再起作用。
 */
//@property (nonatomic, nullable, copy) NSDictionary *sdkStrategyConfig;

@end
NS_ASSUME_NONNULL_END
