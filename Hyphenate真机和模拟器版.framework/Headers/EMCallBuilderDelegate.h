/*!
 *  \~chinese
 *  @header EMCallBuilderDelegate.h
 *  @abstract 此协议定义了实时语音/视频相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallBuilderDelegate.h
 *  @abstract This protocol defined the callbacks of real time voice/video
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@protocol EMCallBuilderDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户A给用户B拨打实时通话，用户B不在线，并且用户A设置了[EMCallOptions.isSendPushIfOffline == YES],则用户A会收到该回调
 *
 *  @param aRemoteName  用户B的环信ID
 *
 *  \~english
 *  User A sends a real-time call to user B, user B is not online, and user A has set [EMCallOptions.isSendPushIfOffline == YES], user A will receive the callback
 *
 *  @param aRemoteName  The Hyphenate ID of user B
 */
- (void)callRemoteOffline:(NSString *)aRemoteName;

@end
