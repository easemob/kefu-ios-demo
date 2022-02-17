//
//  RoomState.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/14.
//


#import "WhiteDisplayerState.h"
#import "WhiteMemberState.h"
#import "WhiteBroadcastState.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * WhiteWindowBoxState NS_STRING_ENUM;

FOUNDATION_EXPORT WhiteWindowBoxState const WhiteWindowBoxStateNormal;
FOUNDATION_EXPORT WhiteWindowBoxState const WhiteWindowBoxStateMini;
FOUNDATION_EXPORT WhiteWindowBoxState const WhiteWindowBoxStateMax;

/** 房间状态。 */
@interface WhiteRoomState : WhiteDisplayerState

/** 实时房间内当前的工具状态。详见 [WhiteReadonlyMemberState](WhiteReadonlyMemberState)。 */
@property (nonatomic, strong, readonly, nullable) WhiteReadonlyMemberState *memberState;

/** 实时房间内当前的视角状态。详见 [WhiteBroadcastState](WhiteBroadcastState)。 */
@property (nonatomic, strong, readonly, nullable) WhiteBroadcastState *broadcastState;

/** 实时房间内当前的视角缩放比例。*/
@property (nonatomic, strong, readonly, nullable) NSNumber *zoomScale;

@property (nonatomic, copy, readonly, nullable) WhiteWindowBoxState windowBoxState;

@end

NS_ASSUME_NONNULL_END
