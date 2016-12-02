//
//  ChatDelegate.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMessage.h"
@protocol HChatDelegate<NSObject>
#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Delegate method will be invoked when receiving new messages
 *
 *  @param aMessages  Receivecd message list<EMMessage>
 */
- (void)messagesDidReceive:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Delegate method will be invoked when receiving command messages
 *
 *  @param aCmdMessages  Command message list<EMMessage>
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages;

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *   Delegate method will be invoked when receiving read acknowledgements for message list
 *
 *  @param aMessages  Acknowledged message list<EMMessage>
 */
- (void)messagesDidRead:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 * Delegate method will be invoked when receiving deliver acknowledgements for message list
 *
 *  @param aMessages  Acknowledged message list<EMMessage>
 */
- (void)messagesDidDeliver:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Delegate method will be invoked when message status has changed
 *
 *  @param aMessage  Message whose status has changed
 *  @param aError    Error info
 */
- (void)messageStatusDidChange:(HMessage *)aMessage
                         error:(EMError *)aError;

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Delegate method will be invoked when message attachment status has changed
 *
 *  @param aMessage  Message attachment status has changed
 *  @param aError    Error
 */
- (void)messageAttachmentStatusDidChange:(HMessage *)aMessage
                                   error:(EMError *)aError;



@end
