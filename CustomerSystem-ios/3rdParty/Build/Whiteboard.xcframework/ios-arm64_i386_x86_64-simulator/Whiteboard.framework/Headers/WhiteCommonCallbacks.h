//
//  WhiteBaseCallbacks.h
//  WhiteSDK
//
//  Created by yleaf on 2019/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 白板通用回调。 */
@protocol WhiteCommonCallbackDelegate <NSObject>

@optional

/** SDK 出现未捕获的全局错误回调。
 
 @param error 错误信息。
 */
- (void)throwError:(NSError *)error;


/**
 图片拦截回调。
 
 **Note:** 
 
 - 要触发该回调，必须在初始化白板 SDK 时，设置 `enableInterrupterAPI(YES)` 开启图片拦截替换功能。详见 [WhiteSdkConfiguration](WhiteSdkConfiguration)。
 - 开启图片拦截替换功能后，在白板中插入图片或场景时，会触发该回调。
 @param url 图片原地址。
 @return 替换后的图片地址。
 */
- (NSString *)urlInterrupter:(NSString *)url;

/**
 播放动态 PPT 中的音视频回调。
 */
- (void)pptMediaPlay;

/**
 暂停播放动态 PPT 中的音视频回调。
 */
- (void)pptMediaPause;

/**
  SDK 初始化失败回调。

  @since 2.9.13

  如果 SDK 初始化失败，调用加入实时房间或回放房间时会处于一直无响应状态，需要重新初始化 SDK。
  
  SDK 初始化失败可能由以下原因导致：
  
  - 初始化 SDK 时候，网络异常，导致获取配置信息失败。
  - 传入了不合法的 App Identifier。

  @param error 错误信息。

 */
- (void)sdkSetupFail:(NSError *)error;

/**
 接收到网页发送的消息回调。
 
 消息回调包括：

 - 字典格式的 iframe 数据
 - 图片加载失败信息
 - ppt 播放/暂停回调信息

 当本地用户收到了网页（如 iframe 插件、动态 PPT）发送的消息时会触发该回调。

 @param dict 字典格式的消息。只有当消息为字典格式时，本地用户才能收到。
 */
- (void)customMessage:(NSDictionary *)dict;

/**
 * @param dict {funName: string, message: id} funName 为对应 API 的名称
 */
- (void)logger:(NSDictionary *)dict;

@end


/**
 通用回调。
 */
@interface WhiteCommonCallbacks : NSObject

/**
 通用回调。详见 [WhiteCommonCallbackDelegate](WhiteCommonCallbackDelegate)。
 */
@property (nonatomic, weak) id<WhiteCommonCallbackDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
