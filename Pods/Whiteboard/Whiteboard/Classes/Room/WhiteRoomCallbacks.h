//
//  WhiteNativeApi.h
//  Pods
//
//  Created by leavesster on 2018/8/12.
//

#import <Foundation/Foundation.h>

#pragma mark - ENUM
/**
 房间连接状态。
 */
typedef NS_ENUM(NSInteger, WhiteRoomPhase) {
    /**
     连接中。
     */
    WhiteRoomPhaseConnecting,          
    /**
     已连接。
     */
    WhiteRoomPhaseConnected,      
    /**
     正在重连。
     */
    WhiteRoomPhaseReconnecting, 
    /**
     正在断开连接。
     */                             
    WhiteRoomPhaseDisconnecting,       
    /**
     已经断开连接。
     */
    WhiteRoomPhaseDisconnected,        
};

@class WhiteRoomState, WhiteEvent;

/** 房间事件回调。*/
@protocol WhiteRoomCallbackDelegate <NSObject>

@optional

/** 房间连接状态发生变化回调。
 @param phase 房间的连接状态，详见 [WhiteRoomPhase](WhiteRoomPhase)。
 */
- (void)firePhaseChanged:(WhiteRoomPhase)phase;

/**
 房间状态属性发生变化回调。

 该回调仅返回发生变化的房间状态属性，未发生变化的房间状态字段，均为空。

 @param modifyState 发生变化的房间状态属性，详见 [WhiteRoomState](WhiteRoomState)。
 */
- (void)fireRoomStateChanged:(WhiteRoomState *)modifyState;

/**
 白板 SDK 与白板服务器连接中断回调。

 @param error 错误信息。
 */
- (void)fireDisconnectWithError:(NSString *)error;

/**
 用户被服务器移出房间回调。

 @param reason 用户被移除房间的原因。
 */
- (void)fireKickedWithReason:(NSString *)reason;

/**
 同步用户行为发生错误回调。

 **Note:** 该回调通常是可以忽略的，你可以根据业务情况自行决定是否监听。
 
 @param userId 用户 ID。
 @param error 错误原因。
 */
- (void)fireCatchErrorWhenAppendFrame:(NSUInteger)userId error:(NSString *)error;

/**
 可撤销次数发生变化回调。

 当本地用户调用 [undo](undo) 撤销上一步操作时，会触发该回调，报告剩余的可撤销次数。
 
 @param canUndoSteps 剩余的可撤销次数。
 */
- (void)fireCanUndoStepsUpdate:(NSInteger)canUndoSteps;

 /**
 可重做次数发生变化回调。

 当本地用户调用 [redo](redo) 重做上一步操作时，会触发该回调，报告剩余的可重做次数。
 
 @param canRedoSteps 剩余的可重做次数。
 */
- (void)fireCanRedoStepsUpdate:(NSInteger)canRedoSteps;

/**
 白板自定义事件回调。
 
 @param event 自定义事件。详见 [WhiteEvent](WhiteEvent)。
 */
- (void)fireMagixEvent:(WhiteEvent *)event;

/**
 高频自定义事件一次性回调。

 @param events 高频自定义事件。详见 [WhiteEvent](WhiteEvent)。
 */
- (void)fireHighFrequencyEvent:(NSArray<WhiteEvent *>*)events;

@end

#pragma mark - WhiteRoomCallbacks

/** 房间事件回调。 */
@interface WhiteRoomCallbacks : NSObject

/** 房间事件回调。详见 [WhiteRoomCallbackDelegate](WhiteRoomCallbackDelegate)。 */
@property (nonatomic, weak) id<WhiteRoomCallbackDelegate> delegate;


@end
