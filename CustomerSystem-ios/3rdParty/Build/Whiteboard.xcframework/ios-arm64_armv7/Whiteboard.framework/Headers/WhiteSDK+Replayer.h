//
//  WhiteSDK+Replayer.h
//  WhiteSDK
//
//  Created by yleaf on 2019/12/10.
//

#import "WhiteSDK.h"
#import "WhitePlayerEvent.h"
#import "WhitePlayerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class WhitePlayer;

@interface WhiteSDK (Replayer)
#pragma mark - Player

/** 创建互动白板回放房间。

 @param config 白板回放的参数配置，详见 [WhitePlayerConfig](WhitePlayerConfig)。
 @param eventCallbacks 白板回放事件的回调。详见 [WhitePlayerEventDelegate](WhitePlayerEventDelegate)。
 @param completionHandler 你可以通过该接口获取 `createReplayerWithConfig` 的调用结果： 

  - 如果方法调用成功，将返回新创建的回放房间对象，详见 [WhitePlayer](WhitePlayer)。
  - 如果方法调用失败，将返回错误信息。
 */
- (void)createReplayerWithConfig:(WhitePlayerConfig *)config callbacks:(nullable id<WhitePlayerEventDelegate>)eventCallbacks completionHandler:(void (^) (BOOL success, WhitePlayer * _Nullable player, NSError * _Nullable error))completionHandler;

/** 查看房间是否能够回放。

 当播放器状态改变时，Player 会触发该回调，向你报告新的播放状态。
 @since 2.11.0

 @param config 白板回放的参数配置，详见 [WhitePlayerConfig](WhitePlayerConfig)。
 @param result 回调。返回房间是否能够回放。
   
  -`YES`：该房间能够回放。   
  - `NO`：该房间不能回放。
 */
- (void)isPlayable:(WhitePlayerConfig *)config result:(void (^)(BOOL isPlayable))result;

@end

NS_ASSUME_NONNULL_END
