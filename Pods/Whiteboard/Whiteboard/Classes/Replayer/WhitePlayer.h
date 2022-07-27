//
//  WhitePlayer.h
//  WhiteSDK
//
//  Created by yleaf on 2019/2/28.
//

#import <Foundation/Foundation.h>
#import "WhitePlayerConsts.h"
#import "WhitePlayerState.h"
#import "WhitePlayerTimeInfo.h"
#import "WhiteDisplayer.h"
#import "WhiteSDK+Replayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhitePlayer : WhiteDisplayer

#pragma mark - 同步 API

@property (nonatomic, copy, readonly) NSString *uuid;

/** 白板回放的阶段。详见 [WhitePlayerPhase](WhitePlayerPhase)。 */
@property (nonatomic, assign, readonly) WhitePlayerPhase phase;

/** 白板回放的状态。详见 [WhitePlayerState](WhitePlayerState)。 */
@property (nonatomic, strong, readonly, nullable) WhitePlayerState *state;

/** 白板回放的时间信息。详见 [WhitePlayerTimeInfo](WhitePlayerTimeInfo)。 */
@property (nonatomic, strong, readonly) WhitePlayerTimeInfo *timeInfo;

#pragma mark - Action API

/**
 开始白板回放。
 */
- (void)play;
/**
 暂停白板回放。
 */
- (void)pause;

/**
 停止白板回放。
 **Note:** 白板回放停止后，`WhitePlayer` 资源会被释放。如果想要重新播放，需要重新初始化 `WhitePlayer` 对象。
 */
- (void)stop;

/** 
 白板回放的播放倍速，如 1.0、1.5、2.0 倍速，默认为 1.0。
 回放暂停时，返回值不会为 0。
*/
@property (nonatomic, assign) CGFloat playbackSpeed;

/**
 设置白板回放的起始播放位置。
 白板回放的起始时间点为 0，成功调用该方法后，白板回放会在指定位置开始播放。

 @param beginTime 开始播放位置（秒）
 */
- (void)seekToScheduleTime:(NSTimeInterval)beginTime;

/**
 设置白板回放的查看模式。

 @param mode 白板回放的查看模式，详见 [WhiteObserverMode](WhiteObserverMode)。
 */
- (void)setObserverMode:(WhiteObserverMode)mode;

@end


/**
 用于操作白板的回放。
 */
@interface WhitePlayer (Asynchronous)

#pragma mark - get API

/**
 获取白板回放的阶段。

 在 `WhitePlayer` 生命周期内，你可以调用该方法获取白板回放当前所处的阶段。其中初始状态为 `WhitePlayerPhaseWaitingFirstFrame`，表示正在等待白板回放的第一帧。

 @param result 回调。返回白板回放的阶段，详见 [WhitePlayerPhase](WhitePlayerPhase)。
 */
- (void)getPhaseWithResult:(void (^)(WhitePlayerPhase phase))result;

/**
 获取白板回放的状态。

 如果白板回放的阶段处于 `WhitePlayerPhaseWaitingFirstFrame`，则该方法返回 `null`。
 @param result 回调。返回白板回放的状态，详见 [WhitePlayerState](WhitePlayerState)。
 */
- (void)getPlayerStateWithResult:(void (^)(WhitePlayerState * _Nullable state))result;

/**
 获取白板回放的时间信息。

 该方法获取的时间信息，包含当前的播放进度，回放的总时长，以及回放的起始时间，单位为秒。
 @param result 回调。返回白板回放的时间信息，详见 [WhitePlayerTimeInfo](WhitePlayerTimeInfo)。
 */
- (void)getPlayerTimeInfoWithResult:(void (^)(WhitePlayerTimeInfo *info))result;

/**
 设置白板回放的倍速。
 
 该方法获取的是播放倍速，如 1.0、1.5、2.0 倍速。因此回放暂停时，返回值也不会为 0。
 @param result 回调。返回白板回放的倍速。
 */
- (void)getPlaybackSpeed:(void (^) (CGFloat speed))result;

@end

NS_ASSUME_NONNULL_END
