/*!
 *  \~chinese
 *  @header IEMChatManager.h
 *  @abstract 此协议定义了聊天相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatManager.h
 *  @abstract This protocol defines the operations of chat
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatManagerDelegate.h"
#import "EMConversation.h"

#import "EMMessage.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMCmdMessageBody.h"
#import "EMFileMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"
#import "EMCustomMessageBody.h"
#import "EMCursorResult.h"

#import "EMGroupMessageAck.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天相关操作
 *  目前消息都是从DB中加载，沒有從server端加载
 *
 *  \~english
 *  Operations of chat
 *  Current message are loaded from local database, not from server
 */
@protocol IEMChatManager <NSObject>

@required

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
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<EMChatManagerDelegate>)aDelegate
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
- (void)removeDelegate:(id<EMChatManagerDelegate>)aDelegate;

#pragma mark - Conversation

/*!
 *  \~chinese
 *  获取所有会话，如果内存中不存在会从DB中加载
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Get all conversations from local databse. Will load conversations from cache first, otherwise local database
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)getAllConversations;

/*!
 *  \~chinese
 *  从服务器获取所有会话
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Get all conversations from local server
 */
- (void)getConversationsFromServer:(void (^)(NSArray *aCoversations, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  获取一个已存在的会话
 *
 *  @param aConversationId  会话ID
 *
 *  @result 会话对象
 *
 *  \~english
 *  Get a conversation from local database
 *
 *  @param aConversationId  Conversation id
 *
 *  @result Conversation
 */
- (EMConversation *)getConversationWithConvId:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  获取一个会话
 *
 *  @param aConversationId  会话ID
 *  @param aType            会话类型
 *  @param aIfCreate        如果不存在是否创建
 *
 *  @result 会话对象
 *
 *  \~english
 *  Get a conversation from local database
 *
 *  @param aConversationId  Conversation id
 *  @param aType            Conversation type (Must be specified)
 *  @param aIfCreate        Whether create conversation if not exist
 *
 *  @result Conversation
 */
- (EMConversation *)getConversation:(NSString *)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId      会话ID
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Delete a conversation from local database
 *
 *  @param aConversationId      Conversation id
 *  @param aIsDeleteMessages    if delete messages
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)deleteConversation:(NSString *)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^)(NSString *aConversationId, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations       会话列表<EMConversation>
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Delete multiple conversations
 *
 *  @param aConversations       Conversation list<EMConversation>
 *  @param aIsDeleteMessages    Whether delete messages
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)deleteConversations:(NSArray *)aConversations
           isDeleteMessages:(BOOL)aIsDeleteMessages
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations   会话列表<EMConversation>
 *  @param aCompletionBlock 完成的回调
 *
 *
 *  \~english
 *  Import multiple conversations to local database
 *
 *  @param aConversations       Conversation list<EMConversation>
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)importConversations:(NSArray *)aConversations
                 completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Message

- (EMMessage *)getMessageWithMessageId:(NSString *)aMessageId;

/*!
 *  \~chinese
 *  获取消息附件路径，存在这个路径的文件，删除会话时会被删除
 *
 *  @param aConversationId  会话ID
 *
 *  @result 附件路径
 *
 *  \~english
 *  Get message attachment local path for the conversation. Delete the conversation will also delete the files under the file path
 *
 *  @param aConversationId  Conversation id
 *
 *  @result Attachment path
 */
- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages        消息列表<EMMessage>
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Import multiple messages to local database
 *
 *  @param aMessages            Message list<EMMessage>
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)importMessages:(NSArray *)aMessages
            completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage         消息
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Update a message in local database. latestMessage of the conversation and other properties will be updated accordingly. messageId of the message cannot be updated
 *
 *  @param aMessage             Message
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)updateMessage:(EMMessage *)aMessage
           completion:(void (^)(EMMessage *aMessage, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage             消息id
 *  @param aUsername            已读接收方
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Send read acknowledgement for message
 *
 *  @param aMessageId           Message id
 *  @param aUsername            ack receiver
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)sendMessageReadAck:(NSString *)aMessageId
                    toUser:(NSString *)aUsername
                completion:(void (^)(EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  发送群消息已读回执
 *
 *  异步方法
 *
 *  @param aMessageId           消息id
 *  @param aGroupId             群id
 *  @param aContent             附加消息
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Send read acknowledgement for message
 *
 *  @param aMessageId           Message id
 *  @param aGroupId             group receiver
 *  @param aContent             Content
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)sendGroupMessageReadAck:(NSString *)aMessageId
                        toGroup:(NSString *)aGroupId
                        content:(NSString *)aContent
                     completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送会话已读消息，将通知服务器将此会话未读数置为0
 *
 *  异步方法
 *
 *  @param conversationId            会话id
 *  @param aCompletionBlock       完成的回调
 *
 *  \~english
 *  Send read conversation ack to server, which makes the conversation read
 *
 *  @param conversationId             conversation id
 *  @param aCompletionBlock         The callback of completion block
 *
 */
- (void)ackConversationRead:(NSString *)conversationId
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  撤回消息
*
*  异步方法
*
*  @param aMessageId           消息Id
*  @param aCompletionBlock     完成的回调
*
*  \~english
*  Recall a message
*
*
*  @param aMessageId           Message id
*  @param aCompletionBlock     The callback block of completion
*
*/
- (void)recallMessageWithMessageId:(NSString *)aMessageId
                        completion:(void (^)(EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *
 *  \~english
 *  Send a message
 *
 *  @param aMessage             Message instance
 *  @param aProgressBlock       The block of attachment upload progress in percentage, 0~100.
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)sendMessage:(EMMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  重发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *
 *  \~english
 *  Resend Message
 *
 *  @param aMessage             Message instance
 *  @param aProgressBlock       The callback block of attachment upload progress
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)resendMessage:(EMMessage *)aMessage
             progress:(void (^)(int progress))aProgressBlock
           completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *
 *  \~english
 *  Manual download the message thumbnail (thumbnail of image message or first frame of video image).
 *  SDK handles the thumbnail downloading automatically, no need to download thumbnail manually unless automatic download failed.
 *
 *  @param aMessage             Message instance
 *  @param aProgressBlock       The callback block of attachment download progress
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)downloadMessageThumbnail:(EMMessage *)aMessage
                        progress:(void (^)(int progress))aProgressBlock
                      completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *
 *  \~english
 *  Download message attachment (voice, video, image or file). SDK handles attachment downloading automatically, no need to download attachment manually unless automatic download failed
 *
 *  @param aMessage             Message object
 *  @param aProgressBlock       The callback block of attachment download progress
 *  @param aCompletionBlock     The callback of completion block
 */
- (void)downloadMessageAttachment:(EMMessage *)aMessage
                         progress:(void (^)(int progress))aProgressBlock
                       completion:(void (^)(EMMessage *message, EMError *error))aCompletionBlock;



/**
 *  \~chinese
 *  从服务器获取指定会话的历史消息
 *
 *  @param  aConversationId     要获取漫游消息的Conversation id
 *  @param  aConversationType   要获取漫游消息的Conversation type
 *  @param  aStartMessageId     参考起始消息的ID
 *  @param  aPageSize           获取消息条数
 *  @param  pError              错误信息
 *
 *  @return     获取的消息结果
 *
 *
 *  \~english
 *  Fetch conversation roam messages from server.
 
 *  @param aConversationId      The conversation id which select to fetch roam message.
 *  @param aConversationType    The conversation type which select to fetch roam message.
 *  @param aStartMessageId      The start search roam message, if empty start from the server leastst message.
 *  @param aPageSize            The page size.
 *  @param pError               EMError used for output.
 *
 *  @return    The result
 */
- (EMCursorResult *)fetchHistoryMessagesFromServer:(NSString *)aConversationId
                                  conversationType:(EMConversationType)aConversationType
                                    startMessageId:(NSString *)aStartMessageId
                                          pageSize:(int)aPageSize
                                             error:(EMError **)pError;


/**
 *  \~chinese
 *  从服务器获取指定会话的历史消息
 *
 *  异步方法
 *
 *  @param  aConversationId     要获取漫游消息的Conversation id
 *  @param  aConversationType   要获取漫游消息的Conversation type
 *  @param  aStartMessageId     参考起始消息的ID
 *  @param  aPageSize           获取消息条数
 *  @param  aCompletionBlock    获取消息结束的callback
 *
 *
 *  \~english
 *  Fetch conversation roam messages from server.
 
 *  @param aConversationId      The conversation id which select to fetch roam message.
 *  @param aConversationType    The conversation type which select to fetch roam message.
 *  @param aStartMessageId      The start search roam message, if empty start from the server leastst message.
 *  @param aPageSize            The page size.
 *  @param aCompletionBlock     The callback block of fetch complete
 */
- (void)asyncFetchHistoryMessagesFromServer:(NSString *)aConversationId
                           conversationType:(EMConversationType)aConversationType
                             startMessageId:(NSString *)aStartMessageId
                                   pageSize:(int)aPageSize
                                 completion:(void (^)(EMCursorResult *aResult, EMError *aError))aCompletionBlock;


/**
 *  \~chinese
 *  从服务器获取指定群已读回执
 *
 *  异步方法
 *
 *  @param  aMessageId           要获取的消息id
 *  @param  aGroupId             要获取回执对应的群id
 *  @param  aGroupAckId          要获取的群回执id
 *  @param  aPageSize            获取消息条数
 *  @param  aCompletionBlock     获取消息结束的callback
 *
 *
 *  \~english
 *  Fetch group read back receipt from the server
 
 *  @param  aMessageId           The message id which select to fetch.
 *  @param  aGroupId             The group id which select to fetch.
 *  @param  aGroupAckId          The group ack id which select to fetch.
 *  @param  aPageSize            The page size.
 *  @param  aCompletionBlock     The callback block of fetch complete
 */
- (void)asyncFetchGroupMessageAcksFromServer:(NSString *)aMessageId
                                     groupId:(NSString *)aGroupId
                             startGroupAckId:(NSString *)aGroupAckId
                                    pageSize:(int)aPageSize
                                  completion:(void (^)(EMCursorResult *aResult, EMError *error, int totalCount))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.6.1

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage             消息
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Send read acknowledgement for message
 *
 *  @param aMessage             Message instance
 *  @param aCompletionBlock     The callback of completion block
 *
 */
- (void)sendMessageReadAck:(EMMessage *)aMessage
                completion:(void (^)(EMMessage *aMessage, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_3_0, 3_6_1, "Use -[IEMChatManager sendMessageReadAck:toUser:completion:]");


/*!
 *  \~chinese
 *  撤回消息
 *
 *  异步方法
 *
 *  @param aMessage             消息
 *  @param aCompletionBlock     完成的回调
 *
 *  \~english
 *  Recall a message
 *
 *
 *  @param aMessage             Message instance
 *  @param aCompletionBlock     The callback block of completion
 *
 */
- (void)recallMessage:(EMMessage *)aMessage
           completion:(void (^)(EMMessage *aMessage, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_3_0, 3_6_1, "Use -[IEMChatManager recallMessageWithMessageId:completion:]");


#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMChatManagerDelegate>)aDelegate EM_DEPRECATED_IOS(3_1_0, 3_2_2, "Use -[IEMChatManager addDelegate:delegateQueue:]");

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  从数据库中获取所有的会话，执行后会更新内存中的会话列表
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Load all conversations from DB, will update conversation list in memory after this method is called
 *
 *  Synchronization method will block the current thread
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)loadAllConversationsFromDB __deprecated_msg("Use -getAllConversations");

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId  会话ID
 *  @param aDeleteMessage   是否删除会话中的消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete a conversation
 *
 *  @param aConversationId  Conversation id
 *  @param aDeleteMessage   Whether delete messages
 *
 *  @result Whether deleted successfully
 */
- (BOOL)deleteConversation:(NSString *)aConversationId
            deleteMessages:(BOOL)aDeleteMessage __deprecated_msg("Use -deleteConversation:isDeleteMessages:completion:");

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations  会话列表<EMConversation>
 *  @param aDeleteMessage  是否删除会话中的消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete multiple conversations
 *
 *  @param aConversations  Conversation list<EMConversation>
 *  @param aDeleteMessage  Whether delete messages
 *
 *  @result Whether deleted successfully
 */
- (BOOL)deleteConversations:(NSArray *)aConversations
             deleteMessages:(BOOL)aDeleteMessage __deprecated_msg("Use -deleteConversations:isDeleteMessages:completion:");

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations  会话列表<EMConversation>
 *
 *  @result 是否成功
 *
 *  \~english
 *  Import multiple conversations to DB
 *
 *  @param aConversations  Conversation list<EMConversation>
 *
 *  @result Whether imported successfully
 */
- (BOOL)importConversations:(NSArray *)aConversations __deprecated_msg("Use -importConversations:completion:");

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  @result 是否成功
 *
 *  \~english
 *  Import multiple messages
 *
 *  @param aMessages  Message list<EMMessage>
 *
 *  @result Whether imported successfully
 */
- (BOOL)importMessages:(NSArray *)aMessages __deprecated_msg("Use -importMessages:completion:");

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage  消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Update message to DB
 *
 *  @param aMessage  Message
 *
 *  @result Whether updated successfully
 */
- (BOOL)updateMessage:(EMMessage *)aMessage __deprecated_msg("Use -updateMessage:completion:");

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage  消息
 *
 *  \~english
 *  Send read ack for message
 *
 *  Asynchronous methods
 *
 *  @param aMessage  Message instance
 */
- (void)asyncSendReadAckForMessage:(EMMessage *)aMessage __deprecated_msg("Use -sendMessageReadAck:completion:");

/*!
 *  \~chinese
 *  发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *
 *  \~english
 *  Send a message
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The block of attachment upload progress
 *
 *  @param aCompletion         The block of send complete
 */
- (void)asyncSendMessage:(EMMessage *)aMessage
                progress:(void (^)(int progress))aProgressCompletion
              completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -sendMessage:progress:completion:");

/*!
 *  \~chinese
 *  重发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *
 *  \~english
 *  Resend Message
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment upload progress
 *  @param aCompletion         The callback block of send complete
 */
- (void)asyncResendMessage:(EMMessage *)aMessage
                  progress:(void (^)(int progress))aProgressCompletion
                completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -resendMessage:progress:completion:");

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message thumbnail attachments (thumbnails of image message or first frame of video image), SDK can download thumbail automatically, so user should NOT download thumbail manually except automatic download failed
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)asyncDownloadMessageThumbnail:(EMMessage *)aMessage
                             progress:(void (^)(int progress))aProgressCompletion
                           completion:(void (^)(EMMessage * message, EMError *error))aCompletion __deprecated_msg("Use -downloadMessageThumbnail:progress:completion:");

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message attachment(voice, video, image or file), SDK can download voice automatically, so user should NOT download voice manually except automatic download failed
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)asyncDownloadMessageAttachments:(EMMessage *)aMessage
                               progress:(void (^)(int progress))aProgressCompletion
                             completion:(void (^)(EMMessage *message, EMError *error))aCompletion __deprecated_msg("Use -downloadMessageAttachment:progress:completion");
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
 *  Load messages with specified message type from local database. Returning messages are sorted by receiving timestamp based on EMMessageSearchDirection.
 *
 *  @param aType            Message type to load
 *  @param aTimestamp       load based on reference timestamp. If aTimestamp=-1, will load from the most recent (the latest) message
 *  @param aCount           Max number of messages to load. if aCount<0, will be handled as count=1
 *  @param aUsername        Message sender (optional). Use aUsername=nil to ignore
 *  @param aDirection       Message search direction
 EMMessageSearchDirectionUp: get aCount of messages before aMessageId;
 EMMessageSearchDirectionDown: get aCount of messages after aMessageId
 *  @param aCompletionBlock The callback of completion block
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
 *  Load messages with specified keyword from local database, returning messages are sorted by receiving timestamp based on EMMessageSearchDirection. If reference timestamp is negative, load from the latest messages; if message count is negative, will be handled as count=1
 *
 *  @param aKeyword         Search keyword. aKeyword=nil to ignore
 *  @param aTimestamp       load based on reference timestamp. If aTimestamp=-1, will load from the most recent (the latest) message
 *  @param aCount           Max number of messages to load
 *  @param aSender          Message sender (optional). Pass nil to ignore
 *  @param aDirection       Message search direction
 EMMessageSearchDirectionUp: get aCount of messages before aMessageId;
 EMMessageSearchDirectionDown: get aCount of messages after aMessageId *  ----
 *  @param aCompletionBlock The callback of completion block
 *
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, EMError *aError))aCompletionBlock;

@end
