//
//  WhiteSDK+Room.h
//  WhiteSDK
//
//  Created by yleaf on 2019/12/10.
//

#import "WhiteSDK.h"
#import "WhiteRoomConfig.h"
#import "WhiteRoomCallbacks.h"

NS_ASSUME_NONNULL_BEGIN

@class WhiteRoom;

@interface WhiteSDK (Room)

/**
 设置房间参数和事件回调并加入互动白板实时房间。 

 @param config  互动白板实时房间的参数配置，详见 [WhiteRoomConfig](WhiteRoomConfig)。
 @param callbacks 房间事件回调，详见 [WhiteRoomCallbackDelegate](WhiteRoomCallbackDelegate)。
 @param completionHandler 调用结果：

 - 如果方法调用成功，将返回房间对象，详见 [WhiteRoom](WhiteRoom)。
 - 如果方法调用失败，将返回错误信息，详见 NSError。
 */
- (void)joinRoomWithConfig:(WhiteRoomConfig *)config callbacks:(nullable id<WhiteRoomCallbackDelegate>)callbacks completionHandler:(void (^) (BOOL success, WhiteRoom * _Nullable room, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
