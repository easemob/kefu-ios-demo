//
//  WhiteCombinePlayer.h
//  WhiteSDK
//
//  Created by yleaf on 2019/7/11.
//

#import <Foundation/Foundation.h>
#import "WhitePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "WhiteVideoView.h"
#import "WhiteSliderView.h"

NS_ASSUME_NONNULL_BEGIN



@protocol WhiteNativePlayerProtocol <NSObject>


- (void)play;


- (void)pause;


- (BOOL)desireToPlay;

- (BOOL)hasEnoughBuffer;


- (CMTime)itemDuration;

@end
/**
 `WhiteCombinePlayer` 的回调。
 */
@protocol WhiteCombineDelegate <NSObject>

@optional

/**
 白板回放播放器或本地播放器开始缓冲回调。
 */
- (void)combinePlayerStartBuffering;

/**
 白板回放播放器和本地播放器全部缓冲结束回调。
 */
- (void)combinePlayerEndBuffering;

/**
 本地播放器开始缓冲回调。
 */
- (void)nativePlayerStartBuffering;

/**
 本地播放器结束缓冲回调。
 */
- (void)nativePlayerEndBuffering;
/**
 本地播放器播放结束回调。
 */
- (void)nativePlayerDidFinish;

/**
 `WhiteCombinePlayer` 播放状态发生改变回调。

 @param isPlaying 是否正在播放
 */
- (void)combineVideoPlayStateChange:(BOOL)isPlaying;


/**
 `WhiteCombinePlayer` 无法进行播放，需要重新创建 [WhiteCombinePlayer](WhiteCombinePlayer) 进行播放。

 @param error 错误原因
 */
- (void)combineVideoPlayerError:(NSError *)error;

/**
 `WhiteCombinePlayer` 加载时间范围发生改变回调。

 @param loadedTimeRanges 加载时间范围。
 */
- (void)loadedTimeRangeChange:(NSArray<NSValue *> *)loadedTimeRanges;
@end

#pragma mark - WhiteSyncManagerPauseReason

/**
 `WhiteCombinePlayer` 播放状态及暂停原因。
 */
typedef NS_OPTIONS(NSUInteger, WhiteSyncManagerPauseReason) {
    /** 正常播放。*/
    WhiteSyncManagerPauseReasonNone                           = 0,
    /** 暂停，暂停原因：白板缓冲。*/
    WhiteSyncManagerPauseReasonWaitingWhitePlayerBuffering    = 1 << 0,
    /** 暂停，暂停原因：音视频缓冲。*/
    WhiteSyncManagerPauseReasonWaitingNativePlayerBuffering   = 1 << 1,
    /** 暂停，暂停原因：主动暂停。*/
    SyncManagerWaitingPauseReasonPlayerPause                  = 1 << 2,
    /** 初始状态：暂停，白板和音视频缓冲。*/
    WhiteSyncManagerPauseReasonInit                           = WhiteSyncManagerPauseReasonWaitingWhitePlayerBuffering | WhiteSyncManagerPauseReasonWaitingNativePlayerBuffering | SyncManagerWaitingPauseReasonPlayerPause,
};


#pragma mark - WhiteCombinePlayer

/**
 同步本地视频播放器与白板回放播放器的播放状态。某一个进入缓冲状态，另一个则暂停等待。
 */
@interface WhiteCombinePlayer : NSObject

@property (nonatomic, strong, readonly) AVPlayer *nativePlayer;

/** 白板回放播放器。详见 [WhitePlayer](WhitePlayer)。
 */
@property (nonatomic, strong, nullable, readwrite) WhitePlayer *whitePlayer;

/** 白板回放回调。详见 [WhiteCombineDelegate](WhiteCombineDelegate)。
 */
@property (nonatomic, weak, nullable) id<WhiteCombineDelegate> delegate;

/** 白板回放的播放速率。即使暂停回放，该值也不会变为 0。详见 [WhitePlayer](WhitePlayer)。 */
@property (nonatomic, assign) CGFloat playbackSpeed;

/** 白板回放的暂停原因。详见 [WhiteSyncManagerPauseReason](WhiteSyncManagerPauseReason)。*/
@property (nonatomic, assign, readonly) NSUInteger pauseReason;

/**
 初始化一个同时持有本地音视频播放器与白板回放播放器的混合播放器对象。

 @param nativePlayer 本地视频播放器。
 @param replayer 白板回放播放器。详见 [WhitePlayer](WhitePlayer)。

 @return 初始化的 `WhiteCombinePlayer` 对象。
*/
- (instancetype)initWithNativePlayer:(AVPlayer *)nativePlayer whitePlayer:(WhitePlayer *)replayer;

/**
 指定媒体资源地址并初始化混合播放器。

 @param mediaUrl 媒体资源地址。
 @param replayer 白板回放播放器。详见 [WhitePlayer](WhitePlayer)。

 @return 初始化的 `WhiteCombinePlayer` 对象。
*/
- (instancetype)initWithMediaUrl:(NSURL *)mediaUrl whitePlayer:(WhitePlayer *)replayer;

/**
 指定媒体资源地址并初始化本地播放器（AV Player），需要在生成后，自行设置白板播放器属性。

 @param mediaUrl 媒体资源地址。

 @return 初始化的 `WhiteCombinePlayer` 对象。
*/
- (instancetype)initWithMediaUrl:(NSURL *)mediaUrl;
/**
 初始化本地视频播放器（AV Player），需要在生成后，自行设置白板播放器属性。

 @param nativePlayer 本地视频播放器。

 @return 初始化的 `WhiteCombinePlayer` 对象。
*/
- (instancetype)initWithNativePlayer:(AVPlayer *)nativePlayer NS_DESIGNATED_INITIALIZER;

/** 视频回放的持续时长。*/
- (NSTimeInterval)videoDuration;

/**
 播放视频。
*/
- (void)play;
/**
 暂停播放视频。
*/
- (void)pause;
/**
 定位到视频指定位置。

 定位到本地视频播放器的指定位置后，你可以调用该方法，将白板回放播放器调整到对应位置。
 
 @param time 时间长度（s)。
 @param completionHandler 调用结果：
 
 - `YES`：调用已经完成。
 - `No`：调用未完成。

*/
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

/**
 更新白板回放播放器的播放状态。
 
 当白板回放播放器的播放状态发生变化时，White Player 会触发该回调，向你报告板回放播放器的播放状态。

 @param phase [WhitePlayer](WhitePlayer) 的播放状态。
 
 **Note:** 在该回调中，需要主动调用 [WhitePlayerPhase](WhitePlayerPhase) 方法，将状态同步给 [WhitePlayer](WhitePlayer)。
 */
- (void)updateWhitePlayerPhase:(WhitePlayerPhase)phase;


@end

NS_ASSUME_NONNULL_END
