//
//  HCallManagerDelegate.h
//  helpdesk_sdk
//
//  Created by __阿彤木_ on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HCallSession.h"

/*!
 *  \~chinese
 *  实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of real time voice/video
 */

@protocol HCallManagerDelegate <NSObject>
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
- (void)callDidReceive:(HCallSession *)aSession;

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
- (void)callDidConnect:(HCallSession *)aSession;

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  User A will receive this callback after user B accept A's call
 *
 *  @param aSession
 */
- (void)callDidAccept:(HCallSession *)aSession;

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
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
- (void)callDidEnd:(HCallSession *)aSession
            reason:(HCallEndReason)aReason
             error:(HError *)aError;

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
- (void)callStateDidChange:(HCallSession *)aSession
                      type:(HCallStreamingStatus)aType;

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 *
 *  \~english
 *  User A and B is on the call, A network status is not stable, A will receive the callback
 *
 *  @param aSession  Session instance
 *  @param aStatus   Current status
 */
- (void)callNetworkDidChange:(HCallSession *)aSession
                      status:(HCallNetworkStatus)aStatus;
@end
