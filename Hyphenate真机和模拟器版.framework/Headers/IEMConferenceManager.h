/*!
 *  \~chinese
 *  @header IEMConferenceManager.h
 *  @abstract 此协议定义了多人实时音频/视频通话相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMConferenceManager.h
 *  @abstract This protocol defines a multiplayer real-time audio / video call related operation
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef IEMConferenceManager_h
#define IEMConferenceManager_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "EMCallConference.h"
#import "EMConferenceManagerDelegate.h"

#import "EMLocalAudioDataDelegate.h"
#import "EMRemoteAudioDataDelegate.h"

#import "EMCallVideoView.h"
#import "EMWaterMarkOption.h"
#import "EMWhiteboard.h"

/*!
*  \~chinese
*  加入房间时使用的配置信息
*
*  \~english
*  The configuration used while join the room
*/
@interface RoomConfig:NSObject
/*!
*  \~chinese
*  会议类型
*
*  \~english
*  The  type of conference
*/
@property (nonatomic) EMConferenceType confrType;
/*!
*  \~chinese
*  录制时是否合并数据流
*
*  \~english
* Whether to merge data streams while recording
*/
@property (nonatomic) BOOL isMerge;
/*!
*  \~chinese
*  是否开启服务端录制
*
*  \~english
*  Whether to record data streams
*/
@property (nonatomic) BOOL isRecord;
/*!
*  \~chinese
*  是否支持微信小程序
*
*  \~english
*  Weather to support wechat mini program
*/
@property (nonatomic) BOOL isSupportWechatMiniProgram;
/*!
*  \~chinese
*  会议中使用的昵称
*
*  \~english
*  The nickName userd in conference
*/
@property (nonatomic) NSString* nickName;
/*!
*  \~chinese
*  成员扩展信息
*
*  \~english
*  The extension info of member
*/
@property (nonatomic) NSString* ext;
/*!
*  \~chinese
*  会议最大主播数
*
*  \~english
*  The  limit count of talkers
*/
@property (nonatomic) NSInteger maxTalkerCount ;
/*!
*  \~chinese
*  会议最大视频上传数
*
*  \~english
*  The  limit count of video streams
*/
@property (nonatomic) NSInteger maxVideoCount;
/*!
*  \~chinese
*  会议最大观众数
*
*  \~english
*  The  limit count of audience
*/
@property (nonatomic) NSInteger maxAudienceCount;
/*!
*  \~chinese
*  会议最大共享桌面数
*
*  \~english
*  The  limit count of desktop stream
*/
@property (nonatomic) NSInteger maxPubDesktopCount;
/*!
*  \~chinese
*  cdn 直播推流配置
*
*  \~english
*  The  cdn live config
*/
@property (nonatomic) LiveConfig* liveConfig;
@end

/*!
*  \~chinese
*  工具栏在白板的位置
*
*  \~english
*  the toolbar's location
*/
typedef NS_ENUM(NSInteger,EMWBLayout)
{
    /*!
    *  \~chinese
    *  工具栏在白板的底部
    *
    *  \~english
    *  the toolbar layout bottom
    */
    EMWBLayoutBottom,
    /*!
    *  \~chinese
    *  工具栏在白板的右侧
    *
    *  \~english
    *  the toolbar layout right
    */
    EMWBLayoutRight,
    /*!
    *  \~chinese
    *  工具栏在白板的顶部
    *
    *  \~english
    *  the toolbar layout top
    */
    EMWBLayoutTop,
    EMWBLayoutUnknown = -1,
};

typedef NS_ENUM(NSInteger,EMUplaodPattern){
    TOP,
    BEFORE,
    AFTER,
    END
};

typedef NS_ENUM(NSInteger,EMGlobalButton){
    ALL = 0,
    NO_UPLAOD
};

/*!
*  \~chinese
*  白板配置，创建时使用
*
*  \~english
*  The  whiteboard config
*/
@interface EMWhiteboardConfig : NSObject
/*!
*  \~chinese
*  是否允许互动
*
*  \~english
*  weather allow members interact
*/
@property (nonatomic) BOOL interact;
/*!
*  \~chinese
*  工具栏在白板的位置
*
*  \~english
*  the toolbar's location
*/
@property (nonatomic) EMWBLayout layout;
/*!
*  \~chinese
*  白板画布的宽高比例，格式为“宽:高”，建议比例"2:1","4:3","16:9"
*
*  \~english
*  the ratio of whiteboard canvas ,format as "width:height",recommended value like "2:1","4:3","16:9"
*/
@property (nonatomic) NSString* ratio;
/*!
*  \~chinese
*  插入图片位置  (EMUplaodPattern类型,比如当前页前 当前页后等）
*
*  \~english
*  the positon of image inserted，such as before current page or after
*/
@property (nonatomic) EMUplaodPattern pattern;
/*!
*  \~chinese
*  区分加入者和创建者的工具栏操作,ALL(和创建者权限一样),NO_UPLAOD(表示缺一些权限，比如上传附件 增加白板页等）
*
*  \~english
*  the option right of joiner's ,value ALL means the same right as creator,and NO_UPLOAD means joiner can not upload file or instert page
*/
@property (nonatomic) EMGlobalButton button;
@end

@class EMError;

/*!
 *  \~chinese
 *  多人会议场景
 *
 *  \~english
 *  Conference mode
 */
typedef enum {
    EMConferenceModeNormal = 0,    /*! \~chinese 人数较少 \~english A small number of people for video conferencing */
    EMConferenceModeLarge,        /*! \~chinese 人数较多 \~english A large number of people for video conferencing */
} EMConferenceMode EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE");

/*!
 *  \~chinese
 *  多人实时音频/视频通话相关操作
 *
 *  \~english
 *  Multi-user real-time audio / video call related operations
 */
@protocol IEMConferenceManager <NSObject>

@optional

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
- (void)addDelegate:(id<EMConferenceManagerDelegate>)aDelegate
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
- (void)removeDelegate:(id<EMConferenceManagerDelegate>)aDelegate;

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
- (void)addLocalAudioDataDelegate:(id<EMLocalAudioDataDelegate>)aDelegate
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
- (void)removeLocalAudioDataDelegate:(id<EMLocalAudioDataDelegate>)aDelegate;

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
- (void)addRemoteAudioDataDelegate:(id<EMRemoteAudioDataDelegate>)aDelegate
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
- (void)removeRemoteAudioDataDelegate:(id<EMRemoteAudioDataDelegate>)aDelegate;

#pragma mark - Conference

/*!
 *  \~chinese
 *  设置应用Appkey, 环信ID, 环信ID对应的Token
 *
 *  @param aAppkey           应用在环信注册的Appkey
 *  @param aUserName         环信ID
 *  @param aToken            环信ID对应的Token
 *
 *  \~english
 *  Setup MemberName
 *
 *  @param aAppkey           AppKey in Hyphenate
 *  @param aUserName         The Hyphenate ID
 *  @param aToken            The token of Hyphenate ID
 */
- (void)setAppkey:(NSString *)aAppkey
         username:(NSString *)aUsername
            token:(NSString *)aToken;

/*!
 *  \~chinese
 *  构建MemberName
 *
 *  @param aAppkey           应用在环信注册的Appkey
 *  @param aUserName         环信ID
 *
 *  @result MemberName
 *
 *  \~english
 *  Setup MemberName
 *
 *  @param aAppkey           AppKey in Hyphenate
 *  @param aUserName         The Hyphenate ID
 *
 *  @result MemberName
 */
- (NSString *)getMemberNameWithAppkey:(NSString *)aAppkey
                             username:(NSString *)aUserName;

/*!
 *  \~chinese
 *  判断会议是否存在
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Determine if the conference exists
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)getConference:(NSString *)aConfId
             password:(NSString *)aPassword
           completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;


/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param isRecord             是否开启服务端录制
 *  @param isMerge              录制时是否合并数据流
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param isRecord             Whether to record using a server
 *  @param isMerge              Whether to merge data streams while recording
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                                 record:(BOOL)isRecord
                            mergeStream:(BOOL)isMerge
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  创建并加入会议,支持微信小程序设置
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param isRecord             是否开启服务端录制
 *  @param isMerge              录制时是否合并数据流
 *  @param isSupportWechatMiniProgram 是否支持微信小程序
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param isRecord             Whether to record using a server
 *  @param isMerge              Whether to merge data streams while recording
 *  @param isSupportWechatMiniProgram Weather to support client on wechat mini program
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                                 record:(BOOL)isRecord
                            mergeStream:(BOOL)isMerge
             isSupportWechatMiniProgram:(BOOL)isSupportWechatMiniProgram
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  创建并加入会议,支持微信小程序设置,cdn推流设置，最大主播人数及视频人数设置
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param isRecord             是否开启服务端录制
 *  @param isMerge              录制时是否合并数据流
 *  @param isSupportWechatMiniProgram 是否支持微信小程序
 *  @param liveConfig       推流时使用的cdn布局
 *  @param aMaxVideoCount 会议中的最大视频数
 *  @param aMaxTalkerCount 会议中最大主播人数
 *  @param aMaxAudienceCount 会议中最大观众人数
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param isRecord             Whether to record using a server
 *  @param isMerge              Whether to merge data streams while recording
 *  @param isSupportWechatMiniProgram Weather to support client on wechat mini program
 *  @param liveConfig          The config of cdn live
 *  @param aMaxVideoCount The max videos count in the confrence
 *  @param aMaxTalkerCount The max speakers count in the confrence
 *  @param aMaxAudienceCount The max audiences count int the confrence
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                                 record:(BOOL)isRecord
                            mergeStream:(BOOL)isMerge
             isSupportWechatMiniProgram:(BOOL)isSupportWechatMiniProgram
                             liveConfig:(LiveConfig*)aLiveConfig
                          maxVideoCount:(NSInteger)aMaxVideoCount
                         maxTalkerCount:(NSInteger)aMaxTalkerCount
                       maxAudienceCount:(NSInteger)aMaxAudienceCount
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param aConfrConfig   会议属性配置
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param aConfrConfig   The config of conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                            confrConfig:(RoomConfig*)aConfrConfig
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  加入已有会议
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Join a conference
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)joinConferenceWithConfId:(NSString *)aConfId
                        password:(NSString *)aPassword
                      completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加入已有会议
 *
 * @param aConfId           会议ID(EMCallConference.confId)
 * @param aPassword         会议密码
 * @param aRole  加入会议使用的角色
 * @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Join a conference
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aPassword         The password of the conference
 *  @param aRole               The role user join conference with
 *  @param aCompletionBlock  The callback block of completion
*/
- (void)joinConferenceWithConfId:(NSString *)aConfId
                        password:(NSString *)aPassword
                            role:(EMConferenceRole)aRole
                      completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;
/*!
*  \~chinese
*  加入房间
*
*  @param roomName          房间名称
*  @param aPassword          房间密码
*  @param role                      加入房间使用的角色
*  @param aCompletionBlock  完成的回调
*
*  \~english
*  Join a Room
*
*  @param roomName           Room Name
*  @param aPassword          The password of the room
*  @param role                      The role user used
*  @param aCompletionBlock  The callback block of completion
*/
-(void)joinRoom:(NSString*)roomName
       password:(NSString*)aPassword
           role:(EMConferenceRole)role
     completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;
/*!
*  \~chinese
*  加入房间
*
*  @param roomName          房间名称
*  @param aPassword          房间密码
*  @param role                      加入房间使用的角色
*  @param roomConfig         加入房间使用的配置
*  @param aCompletionBlock  完成的回调
*
*  \~english
*  Join a Room
*
*  @param roomName           Room Name
*  @param aPassword           The password of the room
*  @param role                       The role user used
*  @param roomConfig          The configuration used while join the room
*  @param aCompletionBlock  The callback block of completion
*/
-(void)joinRoom:(NSString*)roomName
       password:(NSString*)aPassword
           role:(EMConferenceRole)role
     roomConfig:(RoomConfig*)roomConfig
     completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  加入已有会议
 *
 *  @param aTicket           加入会议的凭证
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Join a conference
 *
 *  @param aTicket           Conference Tickets
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)joinConferenceWithTicket:(NSString *)aTicket
                      completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  上传本地摄像头的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamParam      数据流的配置项
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Publish the data stream of the local camera
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamParam      The config of stream
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)publishConference:(EMCallConference *)aCall
              streamParam:(EMStreamParam *)aStreamParam
               completion:(void (^)(NSString *aPubStreamId, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消上传本地摄像头的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID（在[IEMConferenceManager publishConference:pubConfig:completion:]返回）
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Cancel the publish of the local camera's data stream
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id (in [IEMConferenceManager publishConference:pubConfig:completion:] return)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)unpublishConference:(EMCallConference *)aCall
                   streamId:(NSString *)aStreamId
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  订阅其他人的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID (在[EMConferenceManagerDelegate streamDidUpdate:addStream]中返回)
 *  @param aRemoteView       视频显示页面
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Subscribe to other user`s data streams
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id (in [EMConferenceManagerDelegate streamDidUpdate:addStream] return )
 *  @param aRemoteView       Video display view
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)subscribeConference:(EMCallConference *)aCall
                   streamId:(NSString *)aStreamId
            remoteVideoView:(EMCallRemoteVideoView *)aRemoteView
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消订阅的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Unsubscribe data stream
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)unsubscribeConference:(EMCallConference *)aCall
                     streamId:(NSString *)aStreamId
                   completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  改变成员角色，需要管理员权限
 * 用户角色: Admin > Talker > Audience
 * 当角色升级时,用户需要给管理员发送申请,管理通过该接口改变用户接口.
 * 当角色降级时,用户直接调用该接口即可.
 * 注意: 暂时不支持Admin降级自己
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aMember        成员
 *  @param aRole             成员角色
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Changing member roles, requires administrator privileges
 * Role: Admin > Talker > Audience
 * When role upgrade, you need to send a request to Admin, only Admin can upgrade a role.
 * When role degrade, you can degrade with this method yourself.
 * Attention: Admin can not degrade self.
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aMember        Member
 *  @param aRole             The Role
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)changeMemberRoleWithConfId:(NSString *)aConfId
                            member:(EMCallMember *)aMember
                              role:(EMConferenceRole)toRole
                        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  改变成员角色，需要管理员权限
* 用户角色: Admin > Talker > Audience
* 当角色升级时,用户需要给管理员发送申请,管理通过该接口改变用户接口.
* 当角色降级时,用户直接调用该接口即可.
* 注意: 暂时不支持Admin降级自己
*
*  @param aConfId           会议ID(EMCallConference.confId)
*  @param aMemberName        成员在会议中的memName
*  @param aRole             成员角色
*  @param aCompletionBlock  完成的回调
*
*  \~english
*  Changing member roles, requires administrator privileges
* Role: Admin > Talker > Audience
* When role upgrade, you need to send a request to Admin, only Admin can upgrade a role.
* When role degrade, you can degrade with this method yourself.
* Attention: Admin can not degrade self.
*
*  @param aConfId           Conference ID (EMCallConference.confId)
*  @param aMemberName        The memname of member
*  @param aRole             The Role
*  @param aCompletionBlock  The callback block of completion
*/
- (void)changeMemberRoleWithConfId:(NSString *)aConfId
                        memberName:(NSString *)aMemberName
                              role:(EMConferenceRole)toRole
                        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  踢人，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aMemberNameList   成员名列表
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Kick members, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aMemberNameList   Member Name list
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)kickMemberWithConfId:(NSString *)aConfId
                 memberNames:(NSArray<NSString *> *)aMemberNameList
                  completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  销毁会议，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Destroy conference, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)destroyConferenceWithId:(NSString *)aConfId
                     completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  离开会议（创建者可以离开，最后一个人离开，会议销毁）
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Leave the conference (the creator can leave, the last person to leave, the conference is destroyed)
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)leaveConference:(EMCallConference *)aCall
             completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  开始监听说话者
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aTimeMillisecond  返回回调的间隔，单位毫秒，传0使用300毫秒[EMConferenceManagerDelegate conferenceSpeakerDidChange:speakingStreamIds:]
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Start listening to the speaker
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aTimeMillisecond  The interval of callbacks [EMConferenceManagerDelegate conferenceSpeakerDidChange:speakingStreamIds:], Unit milliseconds, pass 0 using 300 milliseconds
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)startMonitorSpeaker:(EMCallConference *)aCall
               timeInterval:(long long)aTimeMillisecond
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  结束监听说话者
 *
 *  @param aCall             会议实例（自己创建的无效）
 *
 *  \~english
 *  Stop listening to the speaker
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 */
- (void)stopMonitorSpeaker:(EMCallConference *)aCall;

/*!
*  \~chinese
*  修改会议的cdn推流位置
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aReagionList 媒体流的位置信息
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Set region of live stream
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aReagionList The list of all stream region
*  @param aCompletionBlock The callback function
*/
- (void)updateConference:(EMCallConference*)aCall
              setRegions:(NSArray<LiveRegion*>*)aReagionList
              completion:(void(^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  修改会议的cdn推流位置
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aReagionList 媒体流的位置信息
*  @param aLiveId           推流Id
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Set region of live stream
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aLiveId          推流ID
*  @param aReagionList The list of all stream region
*  @param aCompletionBlock The callback function
*/
- (void)updateConference:(EMCallConference*)aCall
                  liveId:(NSString*)aLiveId
              setRegions:(NSArray<LiveRegion*>*)aReagionList
              completion:(void(^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  添加一路推流
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aLiveConfig 推流配置
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Add a live push
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aLiveConfig The config of live
*  @param aCompletionBlock The callback function
*/
- (void)addConferenceLive:(EMCallConference*)aCall
                  LiveCfg:(LiveConfig*)aLiveConfig
               completion:(void(^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  启动/停止自定义录制
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aLiveId 推流/录制Id
*  @param aEnabled 操作，启动/停止
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Add a live push
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aLiveId The live id
*  @param aEnabled operation，start/end
*  @param aCompletionBlock The callback function
*/
- (void)enableRecordLiveStream:(EMCallConference*)aCall
                        liveId:(NSString*)aLiveId
                       enabled:(BOOL)aEnabled
                    completion:(void(^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  删除一路推流
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aLiveId 流Id
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Remove a live push
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aLiveId The live Id
*  @param aCompletionBlock The callback function
*/
- (void)deleteConferenceLive:(EMCallConference*)aCall
                      liveId:(NSString*)aLiveId
                  completion:(void(^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  观众申请连麦成为主播，观众角色调用
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aAdminId 管理员的memId
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Request tobe Speaker,only audience call this function
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aAdminId The memid of admin
*  @param aCompletionBlock The callback function
*/
- (void)requestTobeSpeaker:(EMCallConference *)aCall adminId:(NSString *)aAdminId completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  主播申请成为管理员，主播角色调用
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aAdminId 管理员的memId
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Request tobe Admin,only speraker call this function
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aAdminId The memid of admin
*  @param aCompletionBlock The callback function
 */
- (void)requestTobeAdmin:(EMCallConference *)aCall adminId:(NSString *)aAdminId completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  将指定成员静音/解除静音，管理员调用
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aMemId 指定成员的memId
*  @param aMute 操作，YES为静音，NO为解除静音
*  @param aCompletionBlock 回调函数
*
*  \~english
*  mute/unmute one member,only admin call this function
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aMemId The memid of member
*  @param aMute Opereation,YES means mute,and NO means unmute
*  @param aCompletionBlock The callback function
 */
- (void)setMuteMember:(EMCallConference *)aCall
                memId:(NSString *)aMemId
                 mute:(BOOL)aMute
           completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  管理员同意/拒绝观众的上麦申请，管理员调用
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aMemId 上麦申请的观众的memId
*  @param aResult 操作结果，0为同意，1为拒绝
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Admin agree/disagree  the audience request tobe speaker.only admin call this function
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aMemId The memid of member who requeset tobe speaker
*  @param aMute Opereation result，0 means agree，and 1 means disagree
*  @param aCompletionBlock The callback function
 */
- (void)responseReqSpeaker:(EMCallConference *)aCall
                     memId:(NSString *)aMemId
                    result:(NSInteger)aResult
                completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
*  \~chinese
*  管理员同意/拒绝主播的申请管理员请求，管理员调用
*
*  @param aCall             会议实例（自己创建的无效）
*  @param aMemId 申请管理员的主播的memId
*  @param aResult 操作结果，0为同意，1为拒绝
*  @param aCompletionBlock 回调函数
*
*  \~english
*  Admin agree/disagree  the speaker request tobe admin.only admin call this function
*
*  @param aCall             EMConference instance (invalid by yourself)
*  @param aMemId The memid of speaker who request tobe admin
*  @param aMute Opereation result，0 means agree，and 1 means disagree
*  @param aCompletionBlock The callback function
 */
- (void)responseReqAdmin:(EMCallConference *)aCall memId:(NSString *)aMemId result:(NSInteger)aResult completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - Update

/*!
 *  \~chinese
 *  切换前后摄像头
 *
 *  @param aCall             会议实例（自己创建的无效）
 *
 *  \~english
 *  Switch the camera before and after
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 */
- (void)updateConferenceWithSwitchCamera:(EMCallConference *)aCall;

/*!
 *  \~chinese
 *  设置是否静音
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aIsMute           是否静音
 *
 *  \~english
 *  Set whether to mute
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aIsMute           Is mute
 */
- (void)updateConference:(EMCallConference *)aCall
                  isMute:(BOOL)aIsMute;

/*!
 *  \~chinese
 *  设置视频是否可用
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aEnableVideo      视频是否可用
 *
 *  \~english
 *  Set whether the video is available
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aEnableVideo      Whether the video is available
 */
- (void)updateConference:(EMCallConference *)aCall
             enableVideo:(BOOL)aEnableVideo;

/*!
 *  \~chinese
 *  更新视频显示页面
 *
 *  @param aCall             会议实例
 *  @param aStreamId         数据流ID
 *  @param aRemoteView       显示页面
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Update remote video view
 *
 *  @param aCall              EMConference instance
 *  @param aStreamId          Stream id
 *  @param aRemoteView        Video display view
 *  @param aCompletionBlock   The callback block of completion
 */
- (void)updateConference:(EMCallConference *)aCall
                streamId:(NSString *)aStreamId
         remoteVideoView:(EMCallRemoteVideoView *)aRemoteView
              completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更新视频最大码率
 *
 *  @param aCall             会议实例
 *  @param aMaxVideoKbps     最大码率
 *
 *  \~english
 *  Update video maximum bit rate
 *
 *  @param aCall              EMConference instance
 *  @param aMaxVideoKbps      Maximum bit rate
 */
- (void)updateConference:(EMCallConference *)aCall
            maxVideoKbps:(int)aMaxVideoKbps;

#pragma mark - Input Video Data

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aSampleBuffer      视频采样缓冲区
 *  @param aRotation          旋转方向
 *  @param aCall              会议实例
 *  @param aPubStreamId       调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aCompletionBlock   完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aSampleBuffer      Video sample buffer
 *  @param aRotation          UIDeviceOrientation
 *  @param aCallId            [EMCallSession callId]
 *  @param aCompletionBlock   The callback block of completion
 */
- (void)inputVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                      rotation:(UIDeviceOrientation)aRotation
                    conference:(EMCallConference *)aCall
             publishedStreamId:(NSString *)aPubStreamId
                    completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aPixelBuffer      视频像素缓冲区
 *  @param aTime             视频原始数据时间戳，CMTime time = CMSampleBufferGetPresentationTimeStamp((CMSampleBufferRef)sampleBuffer);
 *  @param aRotation         旋转方向
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aPixelBuffer      Video pixel buffer
 *  @param aCallId           [EMCallSession callId]
 *  @param aTime           CMTime time = CMSampleBufferGetPresentationTimeStamp((CMSampleBufferRef)sampleBuffer);
 *  @param aRotation         UIDeviceOrientation
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoPixelBuffer:(CVPixelBufferRef)aPixelBuffer
             sampleBufferTime:(CMTime)aTime
                     rotation:(UIDeviceOrientation)aRotation
                   conference:(EMCallConference *)aCall
            publishedStreamId:(NSString *)aPubStreamId
                   completion:(void (^)(EMError *aError))aCompletionBlock;


/**
 * \~chinese
 * 设置频道属性,该会议中的所有人(包括自己)都会收到
 * {@link EMConferenceManagerDelegate#conferenceAttributeUpdated:attributeAction:attributeKey:}回调.
 * 该方法需要在加入会议后调用.
 *
 * @param attrKey
 * @param attrValue
 * @param aCompletionBlock
 *
 * \~english
 * Set conference attribute,All members in this conference(include myself) will receive a callback
 * in {@link EMConferenceManagerDelegate#conferenceAttributeUpdated:attributeAction:attributeKey:}.
 * this method can only be used after join a conference.
 *
 * @param attrKey
 * @param attrValue
 * @param aCompletionBlock
 */
- (void)setConferenceAttribute:(NSString *)attrKey
                         value:(NSString *)attrValue
                    completion:(void(^)(EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 删除频道属性,该会议中的所有人(包括自己)都会收到
 * {@link EMConferenceManagerDelegate#conferenceAttributeUpdated:attributeAction:attributeKey:}回调.
 * 该方法需要在加入会议后调用.
 *
 * @param aKey
 * @param aCompletionBlock
 *
 * \~english
 * Delete conference attribute,All members in this conference(include myself) will receive a callback
 * in {@link EMConferenceManagerDelegate#conferenceAttributeUpdated:attributeAction:attributeKey:}.
 * this method can only be used after join a conference.
 *
 * @param aKey
 * @param aCompletionBlock
 */
- (void)deleteAttributeWithKey:(NSString *)aKey
                    completion:(void(^)(EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 创建白板房间
 * @param aUsername         用户名
 * @param aToken            用户的token
 * @param aRoomName         房间名
 * @param aPassword         房间的密码
 * @param bInteract         是否允许互动
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * create room for whiteboard
 * @param aUsername         username
 * @param aToken            user's token
 * @param aRoomName         room name for whiteboard
 * @param aPassword         password for room
 * @param bInteract         weather allow members interact
 * @param aCompletionBlock  callback
 */
- (void)createWhiteboardRoomWithUsername:(NSString *_Nonnull)aUsername
                               userToken:(NSString *_Nonnull)aToken
                                roomName:(NSString *_Nonnull)aRoomName
                            roomPassword:(NSString *_Nonnull)aPassword
                                interact:(BOOL)aInteract
                              completion:(void(^)(EMWhiteboard *aWhiteboard, EMError *aError))aCompletionBlock;
/**
 * \~chinese
 * 创建白板房间
 * @param aUsername         用户名
 * @param aToken            用户的token
 * @param aRoomName         房间名
 * @param aPassword         房间的密码
 * @param aWBConfig         白板房间配置
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * create room for whiteboard
 * @param aUsername         username
 * @param aToken            user's token
 * @param aRoomName         room name for whiteboard
 * @param aPassword         password for room
 * @param aWBConfig         the config of whiteboard
 * @param aCompletionBlock  callback
 */

- (void)createWhiteboardRoomWithUsername:(NSString *_Nonnull)aUsername
                               userToken:(NSString *_Nonnull)aToken
                                roomName:(NSString *_Nonnull)aRoomName
                            roomPassword:(NSString *_Nonnull)aPassword
                                  config:(EMWhiteboardConfig* )aWBConfig
                              completion:(void(^)(EMWhiteboard *aWhiteboard, EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 销毁白板房间
 * @param aUsername         用户名
 * @param aToken            用户的token
 * @param aRoomId           房间id
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * create room for whiteboard
 * @param aUsername         username
 * @param aToken            user's token
 * @param aRoomId           room id for whiteboard
 * @param aCompletionBlock  callback
 */
- (void)destroyWhiteboardRoomWithUsername:(NSString *)aUsername
                                userToken:(NSString *)aToken
                                   roomId:(NSString *)aRoomId
                               completion:(void(^)(EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 通过白板id加入房间
 * @param aRoomId           房间id
 * @param aUsername         用户名
 * @param aToken            用户的token
 * @param aPassword         房间的密码
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * join whiteboard room with id
 * @param aRoomId           room id for whiteboard
 * @param aUsername         username
 * @param aToken            user's token
 * @param aPassword         password for room
 * @param aCompletionBlock  callback
 */
- (void)joinWhiteboardRoomWithId:(NSString *)aRoomId
                        username:(NSString *)aUsername
                       userToken:(NSString *)aToken
                    roomPassword:(NSString *)aPassword
                      completion:(void(^)(EMWhiteboard *aWhiteboard, EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 通过白板名称加入房间
 * @param aRoomName         房间名
 * @param aUsername         用户名
 * @param aToken            用户的token
 * @param aPassword         房间的密码
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * join whiteboard room with name
 * @param aRoomName         room name for whiteboard
 * @param aUsername         username
 * @param aToken            user's token
 * @param aPassword         password for room
 * @param aCompletionBlock  callback
 */
- (void)joinWhiteboardRoomWithName:(NSString *)aRoomName
                          username:(NSString *)aUsername
                         userToken:(NSString *)aToken
                      roomPassword:(NSString *)aPassword
                        completion:(void(^)(EMWhiteboard *aWhiteboard, EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 修改白板的用户互动权限
 * @param aRoomId         房间Id
 * @param aToken            用户的token
 * @param aPassword         房间的密码
 * @param aInteract        是否允许互动，YES为允许互动，NO为不允许互动
 * @param aAll                   是否操作所有成员，YES时操作所有人，aServentIds不起作用
 * @param aServentIds      操作的成员数组,aAll为NO时有效
 * @param aCompletionBlock  请求完成的回调
 *
 * \~english
 * update whiteboard room interact
 * @param aRoomId         room Id
 * @param aUsername         username
 * @param aToken            user's token
 * @param aInteract         weather allow members interact
 * @param aAll                    weather update all members`s interact right.if YES,aServentIds is invalid.
 * @param aServentIds    array of members`s id.invalid when aAll is NO
 * @param aCompletionBlock  callback
 */
- (void)updateWhiteboardRoomWithRoomId:(NSString *)aRoomId
                              username:(NSString *)aUsername
                             userToken:(NSString *)aToken
                               intract:(BOOL)aInteract
                              allUsers:(BOOL)aAll
                            serventIds:(NSArray<NSString *>*)aServentIds
                            completion:(void(^)(EMError *aError))aCompletionBlock;

/**
 * \~chinese
 * 开启本地伴音功能,请在加入会议成功后调用,该伴音配置只存在于该会议存在期间.
 *
 * @param filePath 文件路径
 * @param loop     指定音频文件循环播放的次数：
 *                 正整数：循环的次数
 *                 -1：无限循环
 * @param isSendMix 是否启动远端伴音 启动后播放的音乐对方也可以听到
 *
 * @return {@link EMError#EM_NO_ERROR} - 成功
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - 未加入会议
 *         {@link EMError#CALL_INVALID_PARAMS} - 路径参数下的音频文件不存在
 *
 * \~english
 * Start local audio mixing, this method can only be used after join a conference and only worked
 * during this conference exists.
 *
 * @param filePath Audio file path.
 *                 If file path is start with /assets/, we will find in assets/ dir.
 *                 Otherwise, we will find in absolute path.
 * @param loop     loop mode (0 = no loop, -1 = loop forever)
 * @param isSendMix   send mixed audio
 *
 * @return {@link EMError#EM_NO_ERROR} - Success
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - Not in a conference.
 *         {@link EMError#CALL_INVALID_PARAMS} - File not exists.
 */
- (EMError *)startAudioMixing:(NSURL *)aFileURL loop:(int)aLoop sendMix:(BOOL)isSendMix;


/**
 * \~chinese
 * 关闭本地混音功能,请在加入会议成功后调用
 *
 * @return {@link EMError#EM_NO_ERROR} - 成功
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - 未加入会议
 *
 * \~english
 * Stop local audio mixing,this method can only be used after join a conference.
 *
 * @return {@link EMError#EM_NO_ERROR} - Success
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - Not in a conference.
 */
- (EMError *)stopAudioMixing;

/**
 * \~chinese
 * 设置伴奏音量,请在加入会议成功后调用
 *
 * @param volume 伴奏音量范围为 0~100。默认 100 为原始文件音量
 *
 * @return {@link EMError#EM_NO_ERROR} - 成功
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - 未加入会议
 *
 * \~english
 * Adjust audio mixing volume,this method can only be used after join a conference.
 *
 * @param volume scope: 0~100. Default volume is 100, which is the original audio file volume.
 *
 * @return {@link EMError#EM_NO_ERROR} - Success
 *         {@link EMError#CALL_CONFERENCE_NO_EXIST} - Not in a conference.
 */
- (EMError *)adjustAudioMixingVolume:(int)aVolume;


/**
 * \~chinese
 * mute远端音频
 *
 * @param aStreamId        要操作的Steam id
 * @param isMute            是否静音
 *
 * \~english
 * Mute remote audio
 *
 * @param aStreamId        Steam id
 * @param isMute            is mute
 */
- (void)muteRemoteAudio:(NSString *)aStreamId mute:(BOOL)isMute;

/**
 * \~chinese
 * mute远端视频
 *
 * @param aStreamId        要操作的Steam id
 * @param isMute            是否显示
 *
 * \~english
 * Mute remote video
 *
 * @param aStreamId        Steam id
 * @param isMute            is mute
 */
- (void)muteRemoteVideo:(NSString *)aStreamId mute:(BOOL)isMute;

/**
 * \~chinese
 * 启用统计
 *
 * @param enable 是否启用统计
 *
 * \~english
 * enable statistics
 * @params enable enable statistics
 */
- (void)enableStatistics:(BOOL)isEnable;

/**
* \~chinese
* 开启/停止全体静音
*
* @param enable 是否启用全体静音
* @param completion 回调
*
* \~english
* start/stop mute all members
* @params enable whether to start
* @params completion the callback functio
*/
- (void)muteAll:(BOOL)mute
     completion:(void(^)(EMError *aError))aCompletionBlock;
#pragma mark -  自定义音频数据

/*!
*  \~chinese
*  自定义外部音频数据，PCM格式,一个音频采样16bit，每次最大100ms数据
*
*  @param data              外部音频数据
*
*  \~english
*  Customize external audio data,PCM format,each audio sample contail 16 bits，the maxinum data durateion is 100ms
*
*  @param data      Custom audio data,format with PCM
 */
- (int) inputCustomAudioData:(NSData*)data;

#pragma mark - Watermark
/*!
*  \~chinese
*  开启水印功能
*
*  @param option 水印配置项，包括图片url，marginX,marginY以及起始点
*
*  \~english
*  Enable water mark feature
*
*  @param origin the option of watermark picture,include url,margingX,marginY,margin point
 */
- (void)addVideoWatermark:(EMWaterMarkOption*)option;
/*!
*  \~chinese
*  取消水印功能
*
*  \~english
*  Disable water mark feature
*
 */
- (void)clearVideoWatermark;

#pragma mark - EM_DEPRECATED_IOS 3.5.2

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aSampleBuffer     视频采样缓冲区
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~englishat
 *  Customize local video da
 *
 *  @param aSampleBuffer     Video sample buffer
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                    conference:(EMCallConference *)aCall
             publishedStreamId:(NSString *)aPubStreamId
                        format:(EMCallVideoFormat)aFormat
                      rotation:(int)aRotation
                    completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete, Use -inputVideoSampleBuffer:rotation:conference:publishedStreamId:completion:");

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aPixelBuffer      视频像素缓冲区
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aPixelBuffer      Video pixel buffer
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoPixelBuffer:(CVPixelBufferRef)aPixelBuffer
                   conference:(EMCallConference *)aCall
            publishedStreamId:(NSString *)aPubStreamId
                       format:(EMCallVideoFormat)aFormat
                     rotation:(int)aRotation
                   completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete, Use -inputVideoPixelBuffer:sampleBufferTime:rotation:conference:publishedStreamId:completion:");

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aData             视频数据
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aWidth            宽度
 *  @param aHeight           高度
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aData             Video data
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aWidth            Width
 *  @param aHeight           Height
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoData:(NSData *)aData
            conference:(EMCallConference *)aCall
     publishedStreamId:(NSString *)aPubStreamId
         widthInPixels:(size_t)aWidth
        heightInPixels:(size_t)aHeight
                format:(EMCallVideoFormat)aFormat
              rotation:(int)aRotation
            completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete");

#pragma mark - EM_DEPRECATED_IOS 3.4.3

/*!
 *  \~chinese
 *  多人会议场景
 *
 *  \~english
 *  Conference mode
 */
@property (nonatomic) EMConferenceMode mode EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE");

/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithPassword:(NSString *)aPassword
                                 completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -[EMConferenceManagerDelegate createAndJoinConferenceWithType:password:completion:]");

/*!
 *  \~chinese
 *  邀请人加入会议
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aUserName         被邀请人的环信ID
 *  @param aPassword         会议密码
 *  @param aExt              扩展信息
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Invite user join the conference
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aUserName         The Hyphenate ID of the invited user
 *  @param aPassword         The password of the conference
 *  @param aExt              Extended Information
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inviteUserToJoinConference:(EMCallConference *)aCall
                          userName:(NSString *)aUserName
                          password:(NSString *)aPassword
                               ext:(NSString *)aExt
                             error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE, 在demo层自定义实现");


/*!
 *  \~chinese
 *  改变成员角色，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aMemberNameList   成员名列表
 *  @param aRole             成员角色
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Changing member roles, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aMemberNameList   Member Name list
 *  @param aRole             The Role
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)changeMemberRoleWithConfId:(NSString *)aConfId
                       memberNames:(NSArray<NSString *> *)aMemberNameList
                              role:(EMConferenceRole)aRole
                        completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_5_0, 3_6_0, "Use -[changeMemberRoleWithConfId:memberName:role:completion]");

@end


#endif /* IEMConferenceManager_h */
