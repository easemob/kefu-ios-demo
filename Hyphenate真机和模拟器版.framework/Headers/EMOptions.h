/*!
 *  \~chinese
 *  @header EMOptions.h
 *  @abstract SDK的设置选项
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMOptions.h
 *  @abstract SDK setting options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"

/*!
 *  \~chinese 
 *  日志输出级别
 *
 *  \~english 
 *  Log output level
 */
typedef enum {
    EMLogLevelDebug = 0, /*! \~chinese 输出所有日志 \~english Output all logs */
    EMLogLevelWarning,   /*! \~chinese 输出警告及错误 \~english Output warnings and errors */
    EMLogLevelError      /*! \~chinese 只输出错误 \~english Output errors only */
} EMLogLevel;

/*!
 *  \~chinese 
 *  SDK的设置选项
 *
 *  \~english 
 *  SDK setting options
 */
@interface EMOptions : NSObject

/*!
 *  \~chinese 
 *  app唯一标识符
 *
 *  \~english 
 *  Application's unique identifier
 */
@property (nonatomic, copy, readonly) NSString *appkey;

/*!
 *  \~chinese 
 *  控制台是否输出log, 默认为NO
 *
 *  \~english 
 *  Whether print log to console, default is NO
 */
@property (nonatomic, assign) BOOL enableConsoleLog;

/*!
 *  \~chinese 
 *  日志输出级别, 默认为EMLogLevelDebug
 *
 *  \~english 
 *  Log output level, default is EMLogLevelDebug
 */
@property (nonatomic, assign) EMLogLevel logLevel;

/*!
 *  \~chinese
 *  是否只使用https, 默认为NO
 *
 *  \~english
 *  Whether using https only, default is NO
 */
@property (nonatomic, assign) BOOL usingHttpsOnly;

/*!
 *  \~chinese 
 *  是否自动登录, 默认为YES
 *
 *  只有在sdk初始化前设置有效。
 *
 *  \~english
 *  Whether auto login, default is YES
 *
 *  The Settings are only valid before the SDK is initialized.
 */
@property (nonatomic, assign) BOOL isAutoLogin;

/*!
 *  \~chinese 
 *  离开群组时是否删除该群所有消息, 默认为YES
 *
 *  \~english
 *  Whether to delete all the group messages when leaving the group, default is YES
 */
@property (nonatomic, assign) BOOL isDeleteMessagesWhenExitGroup;

/*!
 *  \~chinese
 *  离开聊天室时是否删除所有消息, 默认为YES
 *
 *  \~english 
 *  Whether to delete all the chat room messages when leaving the chat room, default is YES
 */
@property (nonatomic, assign) BOOL isDeleteMessagesWhenExitChatRoom;

/*!
 *  \~chinese 
 *  是否允许聊天室Owner离开, 默认为YES
 *
 *  \~english
 *  if allow chat room's owner can leave the chat room, default is YES.
 */
@property (nonatomic, assign) BOOL isChatroomOwnerLeaveAllowed;

/*!
 *  \~chinese 
 *  用户自动同意群邀请, 默认为YES
 *
 *  \~english 
 *  Whether to automatically accept group invitation, default is YES
 */
@property (nonatomic, assign) BOOL isAutoAcceptGroupInvitation;

/*!
 *  \~chinese 
 *  自动同意好友申请, 默认为NO
 *
 *  \~english 
 *  Whether to automatically approve friend request, default is NO
 */
@property (nonatomic, assign) BOOL isAutoAcceptFriendInvitation;

/*!
 *  \~chinese
 *  是否自动下载图片和视频缩略图及语音消息, 默认为YES
 *
 *  \~english
 *  Whether to automatically download thumbnail of image&video and audio, default is YES
 */
@property (nonatomic, assign) BOOL isAutoDownloadThumbnail;


/**
 * \~chinese
 * 是否需要消息接受方已读确认，缺省YES
 *
 * \~english
 * whether receive message read by receiving user event
 */
@property (nonatomic, assign) BOOL enableRequireReadAck;
/*!
 *  \~chinese 
 *  是否发送消息送达回执, 默认为NO，如果设置为YES，SDK收到单聊消息时会自动发送送达回执
 *
 *  \~english 
 *  Whether to send delivery acknowledgement, default is NO. If set to YES, SDK will automatically send a delivery acknowledgement when receiving a chat message
 */
@property (nonatomic, assign) BOOL enableDeliveryAck;

/*!
 *  \~chinese 
 *  从数据库加载消息时是否按服务器时间排序，默认为YES，按服务器时间排序
 *
 *  \~english 
 *  Whether to sort messages by server received time when loading message from database, default is YES.
 */
@property (nonatomic, assign) BOOL sortMessageByServerTime;

/*!
 *  \~chinese
 * 是否自动上传或者下载消息中的附件，默认为YES
 *
 *  \~english
 *  Whether to automatically upload or download the attachment in the message, default is YES.
 */
@property (nonatomic, assign) BOOL isAutoTransferMessageAttachments;

@property (nonatomic, assign) BOOL isUseRtcConfig;

/*!
 *  \~chinese 
 *  iOS特有属性，推送证书的名称
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  Certificate name of Apple Push Notification Service
 *
 *  Can only be set when initializing the SDK with [EMClient initializeSDKWithOptions:], can't be altered in runtime.
 */
@property (nonatomic, copy) NSString *apnsCertName;

/*!
 *  \~chinese
 *  iOS特有属性，PushKit证书名称
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  Certificate name of Apple PushKit Service
 *
 *  Can only be set when initializing the SDK with [EMClient initializeSDKWithOptions:], can't be altered in runtime.
 */
@property (nonatomic, copy) NSString *pushKitCertName;

/*!
 *  \~chinese 
 *  获取实例
 *
 *  @param aAppkey  App的appkey
 *
 *  @result SDK设置项实例
 *
 *  \~english
 *  Get a SDK setting options instance
 *
 *  @param aAppkey  App‘s unique identifier
 *
 *  @result SDK’s setting options instance
 */
+ (instancetype)optionsWithAppkey:(NSString *)aAppkey;

#pragma mark - EM_DEPRECATED_IOS 3.2.3

/*!
 *  \~chinese
 *  是否使用开发环境, 默认为NO
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  Whether using development environment, default is NO
 *
 *  Can only be set when initializing the sdk with [EMClient initializeSDKWithOptions:], can't be altered in runtime.
 */
@property (nonatomic, assign) BOOL isSandboxMode EM_DEPRECATED_IOS(3_0_0, 3_2_2);

#pragma mark - EM_DEPRECATED_IOS 3.2.2

/*!
 *  \~chinese
 *  是否使用https, 默认为YES
 *
 *  \~english
 *  Whether using https, default is YES
 */
@property (nonatomic, assign) BOOL usingHttps EM_DEPRECATED_IOS(3_0_0, 3_2_1);

@end
