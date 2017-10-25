//
//  Chat.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HChatDelegate.h"
#import "HConversation.h"
#import "HError.h"

@interface HChat : NSObject

/**
    正在会话的conversationId，只读
 */
@property(nonatomic,copy,readonly) NSString *currentConversationId __attribute__((deprecated("已过期")));


#pragma mark - 第二通道

- (void)startPollingCname:(NSString *)cname __attribute__((deprecated("已过期, 请使用bindChatWithConversationId")));

/**
 开启第二通道,参数为会话ID
 @param conversationId 会话ID,一般为IM服务号
 */
- (void)bindChatWithConversationId:(NSString *)conversationId;


- (void)endPolling __attribute__((deprecated("已过期, 请使用unbind")));

/**
 关闭第二通道
 */
- (void)unbind;


#pragma mark - Delegate

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
- (void)addDelegate:(id<HChatDelegate>)aDelegate;

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
- (void)addDelegate:(id<HChatDelegate>)aDelegate
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
- (void)removeDelegate:(id<HChatDelegate>)aDelegate;

#pragma mark - Conversation

/*!
 *  \~chinese
 *  从数据库中获取所有的会话，执行后会更新内存中的会话列表
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 会话列表<HConversation>
 *
 *  \~english
 *  Load all conversations from DB, will update conversation list in memory after this method is called
 *
 *  Synchronization method will block the current thread
 *
 *  @result Conversation list<HConversation>
 */
- (NSArray *)loadAllConversations;

/*!
 *  \~chinese
 *  获取一个会话
 *
 *  @param aConversationId  会话ID
 *
 *  @result 会话对象
 *
 *  \~english
 *  Get a conversation
 *
 *  @param aConversationId  Conversation id
 *  @param aIfCreate        Whether create conversation if not exist
 *
 *  @result Conversation
 */
- (HConversation *)getConversation:(NSString *)aConversationId;
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
            deleteMessages:(BOOL)aDeleteMessage;

#pragma mark - Message

/*!
 *  \~chinese
 *  获取消息附件路径, 存在这个路径的文件，删除会话时会被删除
 *
 *  @param aConversationId  会话ID
 *
 *  @result 附件路径
 *
 *  \~english
 *  Get message attachment path for the conversation, files in this path will also be deleted when delete the conversation
 *
 *  @param aConversationId  Conversation id
 *
 *  @result Attachment path
 */
- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock      发送完成回调block
 *
 *  \~english
 *  Send a message
 *
 *
 *  @param aMessage            Message instance
 *  @param aProgressBlock      The block of attachment upload progress
 *  @param aCompletionBlock         The block of send complete
 */
- (void)sendMessage:(HMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(HMessage *aMessage, HError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  重发送消息
 *
 *
 *  @param aMessage            消息
 *
 *  \~english
 *  Resend Message
 *
 *
 *  @param aMessage            Message instance
 */
- (void)resendMessage:(HMessage *)aMessage
             progress:(void (^)(int progress))aProgressCompletion
           completion:(void (^)(HMessage *message,
                                HError *error))aCompletion;

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage  消息
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Update message
 *
 *  @param aMessage  Message
 *  @param aSuccessBlock    The callback block of completion
 *
 */
- (void)updateMessage:(HMessage *)aMessage
           completion:(void (^)(HMessage *aMessage, HError *aError))aCompletionBlock;

- (void)downloadMessageThumbnail:(HMessage *)aMessage
                        progress:(void (^)(int progress))aProgressBlock
                      completion:(void (^)(HMessage *message, HError *error))aCompletionBlock __attribute__((deprecated("已过期, 请使用downloadThumbnail")));

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message thumbnail (thumbnail of image message or first frame of video image), SDK downloads thumbails automatically, no need to download thumbail manually unless automatic download failed.
 *
 *  @param aMessage            Message instance
 *  @param aProgressBlock      The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)downloadThumbnail:(HMessage *)aMessage
                        progress:(void (^)(int progress))aProgressBlock
                      completion:(void (^)(HMessage *message, HError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message attachment(voice, video, image or file), SDK downloads attachment automatically, no need to download attachment manually unless automatic download failed
 *
 *
 *  @param aMessage            Message instance
 *  @param aProgressBlock      The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)downloadAttachment:(HMessage *)aMessage
                         progress:(void (^)(int progress))aProgressBlock
                       completion:(void (^)(HMessage *message, HError *error))aCompletionBlock;

- (void)downloadMessageAttachment:(HMessage *)aMessage
                         progress:(void (^)(int progress))aProgressBlock
                       completion:(void (^)(HMessage *message, HError *error))aCompletionBlock __attribute__((deprecated("已过期, 请使用downloadAttachment")));
/**
 
 设置语音消息为已播放

 @param message 需要设置的消息
 */
- (void)setMessageListened:(HMessage *)message;

#pragma mark - 自定义表情包


/**
 获取表情包列表

 @param completion 完成回调
 */
- (void)getEmojiPackageListCompletion:(void(^)(NSArray <NSDictionary *> *emojiPackages,HError *error))completion;


/**
 获取单个表情包的表情文件

 @param packageId 表情包id
 @param completion 完成回调
 */
- (void)getEmojisWithPackageId:(NSString *)packageId
                   completion:(void(^)(NSArray <NSDictionary *> *emojis,HError *error))completion;

@end

