//
//  WhiteRoomMember.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/14.
//

#import "WhiteObject.h"
#import "WhiteMemberState.h"
#import "WhiteMemberInformation.h"

NS_ASSUME_NONNULL_BEGIN

/** 实时房间内互动模式（具有读写权限）用户信息。 */
@interface WhiteRoomMember : WhiteObject

@property (nonatomic, copy, readonly) WhiteApplianceNameKey currentApplianceName DEPRECATED_MSG_ATTRIBUTE("使用 memberState.currentApplianceName 获取");

/** 
用户 ID。

在用户加入互动白板实时房间时，会自动分配用户 ID，用于标识房间内的用户。同一房间中的每个用户具有唯一的用户 ID。
*/
@property (nonatomic, assign, readonly) NSInteger memberId;

/** 用户当前使用的工具。详见 [WhiteReadonlyMemberState。](WhiteReadonlyMemberState) */
@property (nonatomic, strong, readonly) WhiteReadonlyMemberState *memberState;

/**
 @deprecated 已废弃。请使用 `payload`。
 
 用户加入房间时携带的用户信息。
 */
@property (nonatomic, strong, readonly, nullable) WhiteMemberInformation *information;

/**
 用户加入房间时携带的自定义用户信息。

 允许转换为 JSON，字符串或数字。

 @since iOS 2.1.0
 
 **Note:** 如果想要使用 SDK 默认头像显示，请使用 `avatar` 字段设置用户头像。
 */
@property (nonatomic, strong, readonly, nullable) id payload;

@end

NS_ASSUME_NONNULL_END
