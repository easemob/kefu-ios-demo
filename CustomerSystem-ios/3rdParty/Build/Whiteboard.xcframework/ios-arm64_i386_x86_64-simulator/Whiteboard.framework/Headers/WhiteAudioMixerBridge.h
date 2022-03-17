//
//  AudioMixerBridge.h
//  Whiteboard
//
//  Created by yleaf on 2020/8/13.
//

#import <Foundation/Foundation.h>
#import "WhiteBoardView.h"

NS_ASSUME_NONNULL_BEGIN


/**
 用 RTC SDK 的混音方法播放动态 PPT 中的音频文件。
 
 在使用如下方法前，需要先调用 [initWithBridge](initWithBridge:) 方法，详见 [WhiteAudioMixerBridge](WhiteAudioMixerBridge)。
 */
@protocol WhiteAudioMixerBridgeDelegate <NSObject>


/**
 开始播放音乐文件及混音。

 进行混音后，需要将混音结果通过 [setMediaState]([WhiteAudioMixerBridge setMediaState:errorCode:]) 传递给动态 PPT 内部。

 @param filePath 指定需要混音的本地或在线音频文件的绝对路径。

 @param loopback 是否只有本地用户可以听到混音后的音频流：

 - `YES`：只有本地可以听到混音的音频流。
 - `NO`：本地和对方都可以听到混音的音频流。

 @param replace 是否播放麦克风采集的音频：

 - `YES`： 只播放音频文件，不播放麦克风采集的音频。
 - `NO`: 将音频文件和麦克风采集的音频混音后播放。

 @param cycle 音乐文件的播放次数。

 - ≥ 0: 播放次数。例如，`0` 表示不播放；`1` 表示播放 `1` 次。
 - -1: 无限循环播放。
 */
- (void)startAudioMixing:(NSString *)filePath loopback:(BOOL)loopback replace:(BOOL)replace cycle:(NSInteger)cycle;

/** 
 停止播放音乐文件及混音。
 */
- (void)stopAudioMixing;


/**
 设置音乐文件的播放位置。

 @param position 整数。进度条位置，单位为毫秒。
*/
- (void)setAudioMixingPosition:(NSInteger)position;

@end

/** 
 用于桥接 Agora RTC SDK 的混音方法和白板 SDK。

 当用户同时使用音视频功能和互动白板，且在互动白板中展示的动态 PPT 包含音频文件时，可能遇到以下问题：

 - 播放 PPT 内的音频时声音很小。
 - 播放 PPT 内的音频时有回声。

 为解决上述问题，你可以使用该类以调用 RTC SDK 的混音方法播放动态 PPT 中的音频文件。

 **Note:** 该类基于 Agora RTC SDK 的混音方法设计，如果你使用的实时音视频 SDK 不是 Agora RTC SDK，但也具有混音接口和混音状态回调，你也可以调用该类。
 */
@interface WhiteAudioMixerBridge : NSObject

/**
 初始化 `WhiteAudioMixerBridge` 对象。

 @param bridge 白板界面。详见 [WhiteBoardView](WhiteBoardView)。
 @param delegate 用 RTC SDK 的混音方法播放动态 PPT 中的音频文件。详见 [WhiteAudioMixerBridgeDelegate](WhiteAudioMixerBridgeDelegate)。
 @return 初始化的 `WhiteAudioMixerBridge` 对象。
*/
- (instancetype)initWithBridge:(WhiteBoardView *)bridge deletegate:(id<WhiteAudioMixerBridgeDelegate>)delegate __deprecated_msg("use initWithBridge:delegate:");

/**
 初始化 `WhiteAudioMixerBridge` 对象。

 @param bridge 白板界面。详见 [WhiteBoardView](WhiteBoardView)。
 @param delegate 用 RTC SDK 的混音方法播放动态 PPT 中的音频文件。详见 [WhiteAudioMixerBridgeDelegate](WhiteAudioMixerBridgeDelegate)。
 @return 初始化的 `WhiteAudioMixerBridge` 对象。
*/
- (instancetype)initWithBridge:(WhiteBoardView *)bridge delegate:(id<WhiteAudioMixerBridgeDelegate>)delegate;

/**
 设置音乐文件播放状态。

 你需要在 Agora RTC SDK 触发的 `localAudioMixingStateDidChanged` 回调中调用该方法，将音乐文件播放状态传递给白板中的 PPT。

 PPT 根据收到的音频播放状态判断是否显示画面，以确保音画同步。

 **Note:** 如果你使用的实时音视频 SDK 没有混音状态回调方法，会导致播放的 PPT 音画不同步。

 @param stateCode 音乐文件播放状态：

 - 710: RTC SDK 成功调用 `startAudioMixing` 播放音乐文件或 `resumeAudioMixing` 恢复播放音乐文件。
 - 711: RTC SDK 成功调用 `pauseAudioMixing` 暂停播放音乐文件。
 - 713: RTC SDK 成功调用 `stopAudioMixing` 停止播放音乐文件。
 - 714: 音乐文件播放失败。SDK 会在 `errorCode` 参数中返回具体的报错原因。
 
 @param errorCode 音乐文件播放失败的原因：

 - 701：音乐文件打开出错。
 - 702：音乐文件打开太频繁。
 - 703：音乐文件播放异常中断。
*/
- (void)setMediaState:(NSInteger)stateCode errorCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
