//
//  BroadcastState.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/14.
//

#import "WhiteObject.h"
#import "WhiteMemberInformation.h"

/**
 视角模式
 */
typedef NS_ENUM(NSInteger, WhiteViewMode) {
    /**
    （默认）自由模式。
  
     该模式下用户可以主动调整视角，不受其他用户视角模式设置的影响，也不会影响其他用户的视角模式设置。
     
     **Note:** 当房间内不存在视角为主播模式的用户时，所有用户的视角都默认为自由模式。
     */
    WhiteViewModeFreedom,
    /**
     跟随模式。
  
     该模式下用户的视角会跟随主播的视角。

     **Note:**
     - 当一个用户的视角设置为主播模式后，房间内其他所有用户（包括新加入房间的用户）的视角会被自动设置为跟随模式。
     - 跟随模式的用户进行白板操作时，其视角会自动切换为自由模式。
     - 切换该模式需要房间中存在主播，否则会保持为自由模式

     如有需要，可以调用 [disableOperations](disableOperations) 禁止用户操作，以锁定用户的视角模式。
     */
    WhiteViewModeFollower,
    /**
     主播模式。
     
     该模式下用户可以主动调整视角，并将自己的视角同步给房间内所有其他用户。
     
     **Note:** 
     - 每个房间只能有一个主播模式视角的用户。
     - 当一个用户的视角设置为主播模式后，房间内所有其他用户（包括新加入房间的用户）的视角会被自动设置为跟随模式。
     */
    WhiteViewModeBroadcaster,
};

NS_ASSUME_NONNULL_BEGIN

/** 主播模式用户的用户信息。 */
@interface WhiteBroadcasterInformation : WhiteObject
/** 主播模式用户在房间中的用户 ID。数据类型为 NSNumber。
 */
@property (nonatomic, assign, readonly) NSNumber *id;
/** 主播模式用户的用户信息。 
 */
@property (nonatomic, assign, readonly, nullable) id payload;

@end

/** 视角状态，包含视角为主播模式的用户信息。 */
@interface WhiteBroadcastState : WhiteObject

/**
 主播模式用户的视角模式。 
 */
@property (nonatomic, assign, readonly) WhiteViewMode viewMode;

/**
 主播模式用户在房间中的用户 ID。详见 [WhiteBroadcasterInformation](WhiteBroadcasterInformation)。

 @since 2.4.7
 */
@property (nonatomic, assign, nullable, readonly) NSNumber *broadcasterId;
/**
 主播模式用户的用户信息。详见 [WhiteBroadcasterInformation](WhiteBroadcasterInformation)。
 */
@property (nonatomic, strong, nullable, readonly) WhiteBroadcasterInformation *broadcasterInformation;

@end

NS_ASSUME_NONNULL_END
