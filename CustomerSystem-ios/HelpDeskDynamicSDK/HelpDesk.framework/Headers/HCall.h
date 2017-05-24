//
//  HCall.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>
#import <Hyphenate/EMCallLocalView.h>
#import <Hyphenate/EMCallRemoteView.h>
#import <Hyphenate/EMOptions.h>
#import <Hyphenate/EMOptions+PrivateDeploy.h>
#import "HError.h"
#import "HCallOptions.h"
#import "HCallEnum.h"
#import "HCallLocalView.h"
#import "HCallManagerDelegate.h"
#import "HCallRemoteView.h"
#import "HCallSession.h"

#import "HCall.h"

@interface HCall : NSObject

+ (instancetype)shareInstance;

#pragma mark - Delegate
/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<HCallManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;
/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<HCallManagerDelegate>)aDelegate;

#pragma mark - Options

/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 *
 *  @param aOptions  Setting options
 */
- (void)setCallOptions:(HCallOptions *)aOptions;

/*!
 *  \~chinese
 *  获取设置项
 *
 *  @result 设置项
 *
 *  \~english
 *  Get setting options
 *
 *  @result Setting options
 */
- (HCallOptions *)getCallOptions;

#pragma mark - Make and Answer and End

/*!
 *  \~chinese
 *  发起实时会话
 *
 *  @param aType            通话类型
 *  @param aRemoteName      被呼叫的用户（不能与自己通话）
 *  @param aExt             通话扩展信息，会传给被呼叫方
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a call
 *
 *  @param aType            Call type
 *  @param aRemoteName      The callee
 *  @param aExt             Call extention, to the callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startCall:(HCallType)aType
       remoteName:(NSString *)aRemoteName
              ext:(NSString *)aExt
       completion:(void (^)(HCallSession *aCallSession, HError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  接收方同意通话请求
 *
 *  @param  aCallId     通话ID
 *
 *  @result 错误信息
 *
 *  \~english
 *  Receiver answer the call
 *
 *  @param  aCallId     Call Id
 *  @param  aRemoteName Remote name
 *
 *  @result Error
 */
- (HError *)answerIncomingCall:(NSString *)aCallId;

/*!
 *  \~chinese
 *  结束通话
 *
 *  @param aCallId     通话的ID
 *  @param aReason     结束原因
 *
 *  @result 错误
 *
 *  \~english
 *  End the call
 *
 *  @param aCallId     Call ID
 *  @param aReason     End reason
 *
 *  @result Error
 */
- (HError *)endCall:(NSString *)aCallId
              reason:(HCallEndReason)aReason;
@end
