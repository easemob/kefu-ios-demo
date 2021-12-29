/*!
 *  \~chinese
 *  @header EMCallManagerDelegate.h
 *  @abstract 此协议定义了实时语音/视频相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallManagerDelegate.h
 *  @abstract This protocol defined the callbacks of real time voice/video
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallSession.h"

@class EMError;

/*!
 *  \~chinese 
 *  实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of real time voice/video
 */
@protocol EMCallManagerDelegate <NSObject>
    
@optional

/*!
 *  \~chinese 
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  User B will receive this callback after user A dial user B
 *
 *  @param aSession  Session instance
 */
- (void)callDidReceive:(EMCallSession *)aSession;

/*!
 *  \~chinese 
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Both user A and B will receive this callback after connection is established
 *
 *  @param aSession  Session instance
 */
- (void)callDidConnect:(EMCallSession *)aSession;

/*!
 *  \~chinese 
 *  用户B同意用户A拨打的通话后，用户A和B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  User A and B will receive this callback after user B accept A's call
 *
 *  @param aSession
 */
- (void)callDidAccept:(EMCallSession *)aSession;

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，双方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 *
 *  \~english
 *  1.The another peer will receive this callback after user A or user B terminate the call.
 *  2.Both user A and B will receive this callback after error occur.
 *
 *  @param aSession  Session instance
 *  @param aReason   Terminate reason
 *  @param aError    Error
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError;

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 *
 *  \~english
 *  User A and B is on the call, A pause or resume the data stream, B will receive the callback
 *
 *  @param aSession  Session instance
 *  @param aType     Type
 */
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType;

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调。若未开启录制，用户B也会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 *
 *  \~english
 *  User A and B is on the call, A network status is not stable, A will receive the callback.If record option is NO,B will receive the callback too.
 *
 *  @param aSession  Session instance
 *  @param aStatus   Current status
 */
- (void)callNetworkDidChange:(EMCallSession *)aSession
                      status:(EMCallNetworkStatus)aStatus;

/*!
 *  \~chinese
 *  建立通话时，自定义语音类别
 *
 *  @param aCategory  会话语音类别
 *
 *  \~english
 *  Custom audio catrgory when setting up a call
 *
 *  @param aCategory  Audio catrgory
 */
- (void)callDidCustomAudioSessionCategoryOptionsWithCategory:(NSString *)aCategory;

@end
