//
//  WhiteSDK.h
//  Pods-white-ios-sdk_Example
//
//  Created by leavesster on 2018/8/11.
//

#import <Foundation/Foundation.h>
#import "WhiteBoardView.h"
#import "WhiteCommonCallbacks.h"
#import "WhiteSdkConfiguration.h"
#import "WhiteAudioMixerBridge.h"
#import "WhiteFontFace.h"
NS_ASSUME_NONNULL_BEGIN

/** 白板 SDK 相关方法。 */
@interface WhiteSDK : NSObject


/** 白板 SDK 版本号。 */
+ (NSString *)version;

/**
 设置 RTC 混音并初始化 `WhiteSDK` 对象。
 请确保在调用其他 API 前先调用该方法创建并初始化白板 SDK 对象。
 @param boardView     白板界面，详见 [WhiteBoardView](WhiteBoardView)。
 @param config        白板 SDK 对象配置，详见 [WhiteSdkConfiguration](WhiteSdkConfiguration)。
 @param callback      通用回调事件，详见 [WhiteCommonCallbackDelegate](WhiteCommonCallbackDelegate)。
 @param mixer         RTC 混音设置，详见 [WhiteAudioMixerBridge](WhiteAudioMixerBridge)。当你同时使用 Agora RTC SDK 和互动白板 SDK, 且互动白板中展示的动态 PPT 中包含音频文件时，你可以调用 `WhiteAudioMixerBridge` 接口，将动态 PPT 中的所有音频交给 Agora RTC SDK 进行混音播放。
 @return 初始化的 `WhiteSDK` 对象。
 */
- (instancetype)initWithWhiteBoardView:(WhiteBoardView *)boardView config:(WhiteSdkConfiguration *)config commonCallbackDelegate:(nullable id<WhiteCommonCallbackDelegate>)callback audioMixerBridgeDelegate:(nullable id<WhiteAudioMixerBridgeDelegate>)mixer;

/**
 初始化 `WhiteSDK` 对象。
 请确保在调用其他 API 前先调用该方法创建并初始化白板 SDK 对象。
 @param boardView     白板界面，详见 [WhiteBoardView](WhiteBoardView)。
 @param config        白板 SDK 对象配置，详见 [WhiteSdkConfiguration](WhiteSdkConfiguration)。
 @param callback      通用回调事件，详见 [WhiteCommonCallbackDelegate](WhiteCommonCallbackDelegate)。
 */
- (instancetype)initWithWhiteBoardView:(WhiteBoardView *)boardView config:(WhiteSdkConfiguration *)config commonCallbackDelegate:(nullable id<WhiteCommonCallbackDelegate>)callback;

/**
 @deprecated 该方法已废弃。请使用 initWithWhiteBoardView:config:commonCallbackDelegate: 和 initWithWhiteBoardView:config:commonCallbackDelegate:audioMixerBridgeDelegate: 方法。

 初始化 `WhiteSDK` 对象。

 @param boardView     白板界面，详见 [WhiteBoardView](WhiteBoardView)。
 @param config        白板 SDK 对象配置，详见 [WhiteSdkConfiguration](WhiteSdkConfiguration)。
 */
- (instancetype)initWithWhiteBoardView:(WhiteBoardView *)boardView config:(WhiteSdkConfiguration *)config DEPRECATED_MSG_ATTRIBUTE("initWithWhiteBoardView:config:commonCallbackDelegate");

/** 
 混音设置。
  */
@property (nonatomic, strong, readonly, nullable) WhiteAudioMixerBridge *audioMixer;

#pragma mark - 字体

/**
 声明在本地白板中可用的字体。 
 @since 2.11.3
 
 调用该方法声明的字体可用于显示 PPT 中的文字和工具输入的文字。
 
 该方法和 [loadFontFaces](loadFontFaces:completionHandler:)  都可以声明在本地白板中可用的字体，区别是 [setupFontFaces](setupFontFaces:) 没有回调，因为无法判断字体声明是否正确；loadFontFaces 会触发回调，报告每一种的预加载结果。 

 **Note:** 

 - 该方法只对本地白板生效，不影响远端白板的字体显示。
 - 通过该方法声明的字体，只有当被使用时，才会触发下载。
 - 不同的字体在不同设备上的渲染可能不同，例如，在某些设备上，要等字体加载完成后，才会渲染文字；而在另外一些设备上，会先使用默认的字体渲染文字，等指定的字体加载完毕后，再整体刷新。
 - 每次调用该方法都会覆盖原来的字体声明。
 - 请勿同时调用该方法和 [loadFontFaces](loadFontFaces:completionHandler:) 方法。否则，无法预期行为。 
 
 @param fontFaces 字体配置文件，详见 [WhiteFontFace](WhiteFontFace)。
 */
- (void)setupFontFaces:(NSArray <WhiteFontFace *>*)fontFaces;

/**
 声明在本地白板中可用的字体并预加载。 
 @since 2.11.3
 
 调用该方法预加载的字体可以用于显示 PPT 中的文字和工具输入的文字。
 
 该方法和 [setupFontFaces](setupFontFaces:) 都可以声明在本地白板中可用的字体，区别是 [setupFontFaces](setupFontFaces:) 没有回调，因为无法判断字体声明是否正确；[loadFontFaces](loadFontFaces:completionHandler:)  会触发回调，报告每一种的预加载结果。 

 **Note:**

 - 该方法只对本地白板生效，不影响远端白板的字体显示。
 - 使用该方法预加载的字体，只有当该字体被使用时，才会触发下载。
 - 不同的字体在不同设备上的渲染可能不同，例如，在某些设备上，要等字体加载完成后，才会渲染文字；而在另外一些设备上，会先使用默认的字体渲染文字，等指定的字体加载完毕后，再整体刷新。
 - 通过该方法预加载的字体无法删除，每次调用都会在原来的基础上新增。
 - 请勿同时调用该方法和 setupFontFaces 方法。否则，无法预期行为。 

 @param fontFaces   WhiteFontFace 对象 ，详见 WhiteFontFace。
 @param completionHandler 调用结果：

 - 如果方法调用成功，则返回 `FontFace` 对象
 - 如果方法调用失败，则返回错误信息，详见 NSError。

 每加载完成一种字体，会触发一个回调，报告该字体是否加载成功。传入的 [WhiteFontFace](WhiteFontFace) 对象中有多少种字体，就会有多少个回调。
 */
- (void)loadFontFaces:(NSArray <WhiteFontFace *>*)fontFaces completionHandler:(void (^)(BOOL success, WhiteFontFace *fontFace, NSError * _Nullable error))completionHandler;

/**
 设置文字工具在本地白板中使用的字体。 

 @since 2.11.3
 **Note:**

 - 该方法只对本地白板生效，不影响远端白板的字体显示。
 - 该方法只能设置文字工具使用的字体，不能用于 PPT 中的文字显示。 
 @param fonts 字体名称。如果用户系统中不存在该字体，则文字工具无法使用该字体。请确保你已经调用 [setupFontFaces](setupFontFaces:) 或 [loadFontFaces](loadFontFaces:completionHandler:)  将指定字体加载到本地白板中。 
 */
- (void)updateTextFont:(NSArray <NSString *>*)fonts;

#pragma mark - CommonCallback

/**
 设置通用回调事件。

 SDK 通过 [WhiteCommonCallbacks](WhiteCommonCallbacks) 类向 app 报告 SDK 运行时的各项事件。
 
 @param callbackDelegate 通用回调事件，详见 [WhiteCommonCallbackDelegate](WhiteCommonCallbackDelegate)。
 */
- (void)setCommonCallbackDelegate:(nullable id<WhiteCommonCallbackDelegate>)callbackDelegate;


@end
NS_ASSUME_NONNULL_END
