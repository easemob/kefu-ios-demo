//
//  WhitePlayerEvent.h
//  WhiteSDK
//
//  Created by yleaf on 2019/3/1.
//

#import <Foundation/Foundation.h>
#import "WhitePlayerState.h"
#import "WhitePlayerConsts.h"
#import "WhiteEvent.h"

NS_ASSUME_NONNULL_BEGIN

/** 白板回放的回调。 */
@protocol WhitePlayerEventDelegate <NSObject>

@optional

/** 播放状态切换回调。 
 @param phase 白板回放的播放状态。详见 [WhitePlayer](WhitePlayer)。
 */
- (void)phaseChanged:(WhitePlayerPhase)phase;
/** 首帧加载回调。 */
- (void)loadFirstFrame;
- (void)sliceChanged:(NSString *)slice;
/** 回放状态发生变化的回调，只会包含实际发生改变的属性。
 @param modifyState 白板回放已经改变的的状态。详见 [WhitePlayerState](WhitePlayerState)。 */
- (void)playerStateChanged:(WhitePlayerState *)modifyState;
/** 出错导致回放暂停的回调。
 @param error 错误信息。 */
- (void)stoppedWithError:(NSError *)error;
/** 回放进度发生变化回调。
 @param time 回放进度（s）。*/
- (void)scheduleTimeChanged:(NSTimeInterval)time;
/** 添加帧出错的回调。
 @param error 错误信息。 */
- (void)errorWhenAppendFrame:(NSError *)error;
/** 渲染时出错的回调。
 @param error 错误信息。 */
- (void)errorWhenRender:(NSError *)error;
/**
 白板自定义事件回调。
 @param event 白板自定义事件。详见 [WhiteEvent](WhiteEvent)。
 */
- (void)fireMagixEvent:(WhiteEvent *)event;
/**
 高频自定义事件一次性回调。

 @param events 高频自定义事件。详见 [WhiteEvent](WhiteEvent)。
 */
- (void)fireHighFrequencyEvent:(NSArray<WhiteEvent *>*)events;

@end
/**
 白板回放的事件回调。
 */
@interface WhitePlayerEvent : NSObject

@property (nonatomic, weak, nullable) id<WhitePlayerEventDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
