//
//  HNConversation.h
//  helpdesk_sdk
//
//  Created by __阿彤木_ on 12/26/16.
//  Copyright © 2016 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNConversation : NSObject

/*!
 *  \~chinese
 *  会话唯一标识
 *
 *  \~english
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;
/*!
 *  \~chinese
 *   会话未读消息数量
 *
 *  \~english
 *  Count of unread messages
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/*!
 *  \~chinese
 *  会话扩展属性
 *
 *  \~english
 *  Conversation extend property
 */
@property (nonatomic, strong) NSDictionary *ext;

/*!
 *  \~chinese
 *  会话最新一条消息
 *
 *  \~english
 *  Conversation latest message
 */
@property (nonatomic, strong, readonly) HMessage *latestMessage;

-(instancetype)initWithConversation:(NSString *)conversationId;

/*!
 *  \~chinese
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 *  \~english
 *  Insert a message to a conversation. ConversationId of the message should be the same as conversationId of the conversation in order to insert the message into the conversation correctly.
 *
 *  @param aMessage Message
 *  @param pError   Error
 */
- (void)insertMessage:(HMessage *)aMessage
                error:(EMError **)pError;

/*!
 *  \~chinese
 *  删除一条消息
 *
 *  @param aMessageId   要删除消失的ID
 *  @param pError       错误信息
 *
 *  \~english
 *  Delete a message
 *
 *  @param aMessageId   MessageId of the message to be deleted
 *  @param pError       Error
 *
 */
- (void)deleteMessageWithId:(NSString *)aMessageId
                      error:(EMError **)pError;
/*!
 *  \~chinese
 *  删除该会话所有消息
 *  @param pError       错误信息
 *
 *  \~english
 *  Delete all message of a conversation
 *  @param pError       Error
 */
- (void)deleteAllMessages:(EMError **)pError;

/*!
 *  \~chinese
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage 要更新的消息
 *  @param pError   错误信息
 *
 *  \~english
 *  Update a local message, conversation's latestMessage and other properties will be updated accordingly. Please note that messageId can not be updated.
 *
 *  @param aMessage Message
 *  @param pError   Error
 *
 */
- (void)updateMessageChange:(HMessage *)aMessage
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  将消息设置为已读
 *
 *  @param aMessageId   要设置消息的ID
 *  @param pError       错误信息
 *
 *  \~english
 *  Mark a message as read
 *
 *  @param aMessageId   MessageID
 *  @param pError       Error
 *
 */
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  将所有未读消息设置为已读
 *
 *  @param pError   错误信息
 *
 *  \~english
 *  Mark all message as read
 *
 *  @param pError   Error
 *
 */
- (void)markAllMessagesAsRead:(EMError **)pError;

/*!
 *  \~chinese
 *  更新会话扩展属性到DB
 *
 *  @result 是否成功
 *
 *  \~english
 *  Update conversation extend properties to DB
 *
 *  @result Extend properties update result, YES: success, No: fail
 */
- (BOOL)updateConversationExtToDB;

#pragma mark - Async method

/*!
 *  \~chinese
 *  获取指定ID的消息
 *
 *  @param aMessageId       消息ID
 *  @param pError           错误信息
 *
 *  \~english
 *  Get a message with the ID
 *
 *  @param aMessageId       MessageID
 *  @param pError           Error
 *
 */
- (HMessage *)loadMessageWithId:(NSString *)aMessageId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
 *
 *  @param aMessageId       参考消息的ID
 *  @param count            获取的条数
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Load messages from a specified message, returning messages are sorted by receiving timestamp. If the aMessageId is nil, return the latest received messages.
 *
 *  @param aMessageId       Reference message's ID
 *  @param aCount           Count of messages to load
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesStartFromId:(NSString *)aMessageId
                          count:(int)aCount
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息取，如果aCount小于等于0当作1处理
 *
 *  @param aType            消息类型
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aUsername        消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Load messages with specified type, returning messages are sorted by receiving timestamp. If reference timestamp is negative, load from the latest messages; if message count is negative, count deal with 1 and load one message that meet the condition.
 *
 *  @param aType            Message type to load
 *  @param aTimestamp       Reference timestamp
 *  @param aLimit           Count of messages to load
 *  @param aUsername        Message sender (optional)
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesWithType:(EMMessageBodyType)aType
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString*)aUsername
             searchDirection:(EMMessageSearchDirection)aDirection
                  completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  从数据库获取包含指定内容的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aCount小于等于0当作1处理
 *
 *  @param aKeywords        搜索关键字，如果为空则忽略
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aSender          消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Load messages with specified keyword, returning messages are sorted by receiving timestamp. If reference timestamp is negative, load from the latest messages; if message count is negative, count deal with 1 and load one message that meet the condition.
 *
 *  @param aKeywords        Search content, will ignore it if it's empty
 *  @param aTimestamp       Reference timestamp
 *  @param aCount           Count of messages to load
 *  @param aSender          Message sender (optional)
 *  @param aDirection       Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeyword
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定时间段内的消息，取到的消息按时间排序，为了防止占用太多内存，用户应当制定加载消息的最大数
 *
 *  @param aStartTimestamp  毫秒级开始时间
 *  @param aEndTimestamp    结束时间
 *  @param aCount           加载消息最大数
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Load messages within specified time range, retruning messages are sorted by receiving timestamp
 *
 *  @param aStartTimestamp  Start time's timestamp in miliseconds
 *  @param aEndTimestamp    End time's timestamp in miliseconds
 *  @param aCount           Message search direction
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount
              completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 *
 *  \~english
 *  Get last received message
 *
 *  @result Message instance
 */
- (HMessage *)lastReceivedMessage;
@end
