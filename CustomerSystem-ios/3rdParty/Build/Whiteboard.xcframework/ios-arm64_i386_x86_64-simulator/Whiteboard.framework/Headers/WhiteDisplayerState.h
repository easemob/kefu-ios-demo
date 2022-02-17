//
//  WhiteDisplayerState.h
//  WhiteSDK
//
//  Created by yleaf on 2019/7/22.
//

#import "WhiteObject.h"
#import "WhiteGlobalState.h"
#import "WhiteRoomMember.h"
#import "WhiteSceneState.h"
#import "WhiteCameraState.h"
#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 互动白板实时房间和回放房间共有的状态。 */
@interface WhiteDisplayerState : WhiteObject<YYModel>

/**
 设置自定义全局状态。

 设置后，所有 `WhiteGlobalState` 都会转换为该类的对象。

 @param clazz 自定义全局状态类，自定义的 `WhiteGlobalState` 类必须继承 [WhiteGlobalState](WhiteGlobalState)，否则会清空该配置。

 **Note:** 如果你使用 Swift，在配置 [WhiteGlobalState](WhiteGlobalState) 子类属性时，需要对属性添加 `@objc` 修饰符。

 @return 
 
  - `YES`：配置成功。
  - `No`：配置失败，恢复为 [WhiteGlobalState](WhiteGlobalState) 类。
 */
+ (BOOL)setCustomGlobalStateClass:(Class)clazz;

/** 房间的全局状态。详见 [WhiteGlobalState](WhiteGlobalState)。 */
@property (nonatomic, strong, readonly, nullable) WhiteGlobalState *globalState;

/** 房间中所有的互动模式（具有读写权限）的用户。详见 [WhiteRoomMember](WhiteRoomMember)。 */
@property (nonatomic, strong, readonly, nullable) NSArray<WhiteRoomMember *> *roomMembers;

/** 当前场景组下的场景状态。详见 [WhiteSceneState](WhiteSceneState)。 */
@property (nonatomic, strong, readonly, nullable) WhiteSceneState *sceneState;

/** 白板内部视角状态。详见 [WhiteCameraState](WhiteCameraState)。 */
@property (nonatomic, strong, readonly, nullable) WhiteCameraState *cameraState;

@end

NS_ASSUME_NONNULL_END
