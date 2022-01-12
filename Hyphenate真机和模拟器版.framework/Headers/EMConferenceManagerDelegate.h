/*!
 *  \~chinese
 *  @header EMConferenceManagerDelegate.h
 *  @abstract 此协议定义了多人实时语音/视频相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMConferenceManagerDelegate.h
 *  @abstract This protocol defines a multiplayer real-time voice / video related callback
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef EMConferenceManagerDelegate_h
#define EMConferenceManagerDelegate_h

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMCallEnum.h"
#import "EMCallConference.h"
#import "EMCallStream.h"
#import "EMConferenceAttribute.h"
#import "EMRTCStatsReport.h"

@class EMError;

/*!
 *  \~chinese
 *  多人实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of multiplayer real time voice/video
 */

@protocol EMConferenceManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  有人加入会议
 *
 *  @param aConference       会议实例
 *  @param aMember           加入的用户
 *
 *  \~english
 *  Someone joined the conference
 *
 *  @param aConference       EMConference instance
 *  @param aMember           The joined user
 */
- (void)memberDidJoin:(EMCallConference *)aConference
               member:(EMCallMember *)aMember;

/*!
 *  \~chinese
 *  有人离开会议
 *
 *  @param aConference       会议实例
 *  @param aMember           离开的用户
 *
 *  \~english
 *  Someone leaved the conference
 *
 *  @param aConference       EMConference instance
 *  @param aMember           The leaved user
 */
- (void)memberDidLeave:(EMCallConference *)aConference
                member:(EMCallMember *)aMember;

/*!
 *  \~chinese
 *  自己的角色发生变化
 *
 *  @param aConference       会议实例
 *
 *  \~english
 *  The role has changed
 *
 *  @param aConference       EMConference instance
 */
- (void)roleDidChanged:(EMCallConference *)aConference;

/*!
 *  \~chinese
 *  管理员新增
 *
 *  @param aConference       会议实例
 *  @param adminmemid         新的管理员memid
 *
 *  \~english
 *  The admin has added
 *
 *  @param aConference       EMConference instance
 *  @param adminmemid         The new admin memid
 */
- (void)adminDidChanged:(EMCallConference *)aConference
               newAdmin:(NSString*)adminmemid;

/*!
 *  \~chinese
 *  管理员放弃
 *
 *  @param aConference       会议实例
 *  @param adminmemid         放弃管理员的memid
 *
 *  \~english
 *  The admin has removed
 *
 *  @param aConference       EMConference instance
 *  @param adminmemid         The removed admin memid
 */
- (void)adminDidChanged:(EMCallConference *)aConference
            removeAdmin:(NSString*)adminmemid;

/*!
*  \~chinese
*  本地pub流失败
*
*  @param aConference       会议实例
*  @param aError                  错误信息
*
*  \~english
*  The local stream pub failed
*
*  @param aConference       EMConference instance
*  @param aError                  The error info
*/
- (void)streamPubDidFailed:(EMCallConference *)aConference
                     error:(EMError*)aError;
/*!
*  \~chinese
* 发布共享桌面流失败
*
*  @param aConference       会议实例
*  @param aError                  错误信息
*
*  \~english
*  Publish desktop stream failed
*
*  @param aConference       EMConference instance
*  @param aError                  The error info
*/
- (void)DesktopStreamDidPubFailed:(EMCallConference *)aConference
                            error:(EMError*)aError;

/*!
*  \~chinese
*  本地update流失败
*
*  @param aConference       会议实例
*  @param aError                  错误信息
*
*  \~english
*  The local stream pub failed
*
*  @param aConference       EMConference instance
*  @param aError                  The error info
*/
- (void)streamUpdateDidFailed:(EMCallConference *)aConference
                        error:(EMError*)aError;

/*!
 *  \~chinese
 *  有新的数据流上传
 *
 *  @param aConference       会议实例
 *  @param aStream           数据流实例
 *
 *  \~english
 *  New data streams pulished
 *
 *  @param aConference       EMConference instance
 *  @param aStream           EMCallStream instance
 */
- (void)streamDidUpdate:(EMCallConference *)aConference
              addStream:(EMCallStream *)aStream;

/*!
 *  \~chinese
 *  有数据流移除
 *
 *  @param aConference       会议实例
 *  @param aStream           数据流实例
 *
 *  \~english
 *  Stream removed
 *
 *  @param aConference       EMConference instance
 *  @param aStream           EMCallStream instance
 */
- (void)streamDidUpdate:(EMCallConference *)aConference
           removeStream:(EMCallStream *)aStream;

/*!
 *  \~chinese
 *  数据流有更新（是否静音，视频是否可用）
 *
 *  @param aConference       会议实例
 *  @param aStream           数据流实例
 *
 *  \~english
 *  Stream is updated (whether it is mute, video is available)
 *
 *  @param aConference       EMConference instance
 *  @param aStream           EMCallStream instance
 */
- (void)streamDidUpdate:(EMCallConference *)aConference
                 stream:(EMCallStream *)aStream;

/*!
 *  \~chinese
 *  会议已经结束
 *
 *  @param aConference       会议实例
 *  @param aReason           结束原因
 *  @param aError            错误信息
 *
 *  \~english
 *  The conference is over
 *
 *  @param aConference       EMConference instance
 *  @param aReason           The end reason
 *  @param aError            The error
 */
- (void)conferenceDidEnd:(EMCallConference *)aConference
                  reason:(EMCallEndReason)aReason
                   error:(EMError *)aError;

/*!
 *  \~chinese
 *  数据流已经开始传输数据
 *
 *  @param aConference       会议实例
 *  @param aStreamId         数据流ID
 *
 *  \~english
 *  The stream has already begun to transfer data
 *
 *  @param aConference       EMConference instance
 *  @param aStreamId         Stream ID
 */
- (void)streamStartTransmitting:(EMCallConference *)aConference
                       streamId:(NSString *)aStreamId;

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
- (void)conferenceNetworkDidChange:(EMCallConference *)aConference
                            status:(EMCallNetworkStatus)aStatus;


/*!
 *  \~chinese
 *  用户A用户B在同一个会议中，用户A开始说话时，用户B会收到该回调
 *
 *  @param aSession     会话实例
 *  @param aStreamIds   数据流ID列表
 *
 *  \~english
 *  User A and B is on the call, when A starts speaking, B will receive the callback
 *
 *  @param aSession     Session instance
 *  @param aStreamIds   The list of stream id
 */
- (void)conferenceSpeakerDidChange:(EMCallConference *)aConference
                 speakingStreamIds:(NSArray *)aStreamIds;

- (void)conferenceAttributeUpdated:(EMCallConference *)aConference
                        attributes:(NSArray <EMConferenceAttribute *>*)attrs;

/*!
 * \~chinese
 * 收到全体静音/解除全体静音的回调
 *
 * @param aConference     会议
 * @param aMuteAll   是否全体静音
 *
 *\~english
 * callback when admin set muteAll/unmuteAll
 *
 * @param aConference     EMCallConference instance
 * @param aMuteAll  Weather muteAll or not
*/
- (void)conferenceDidUpdated:(EMCallConference *)aConference
                  muteAll:(BOOL)aMuteAll;

/*!
 * \~chinese
 * 收到观众申请主播的请求，只有管理员会触发
 *
 * @param aConference     会议
 * @param aMemId   申请人memId
 * @param aNickName 申请人昵称
 * @param aMemName 申请人memName
 *
 *\~english
 * callback when admin recv the request of become speaker
 *
 * @param aConference     EMCallConference instance
 * @param aMemId   The memId of requster
 * @param aNickName  The nickname of requster
 * @param aMemName  The memname of requster
*/
- (void)conferenceReqSpeaker:(EMCallConference*)aConference memId:(NSString*)aMemId nickName:(NSString*)aNickName memName:(NSString*)aMemName;

/*!
 * \~chinese
 * 收到主播申请管理员的请求，只有管理员会触发
 *
 * @param aConference     会议
 * @param aMemId   申请人memId
 * @param aNickName 申请人昵称
 * @param aMemName 申请人memName
 *
 *\~english
 * callback when admin recv the request of become admin
 *
 * @param aConference     EMCallConference instance
 * @param aMemId   The memId of requster
 * @param aNickName  The nickname of requster
 * @param aMemName  The memname of requster
*/
- (void)conferenceReqAdmin:(EMCallConference*)aConference memId:(NSString*)aMemId nickName:(NSString*)aNickName memName:(NSString*)aMemName;

/*!
 * \~chinese
 * 收到静音/解除静音的回调
 *
 * @param aConference     会议
 * @param aMute   是否静音
 *
 *\~english
 * callback when recv mute command
 *
 * @param aConference     EMCallConference instance
 * @param aMute  Weather mute or not
*/
- (void)conferenceDidUpdated:(EMCallConference*)aConference
                        mute:(BOOL)aMute;

/*!
 * \~chinese
 * 收到申请主播请求被拒绝的回调
 *
 * @param aConference     会议
 * @param aAdminId   管理员ID
 *
 *\~english
 * callback when admin refuse the request of become speaker
 *
 * @param aConference     EMCallConference instance
 * @param aAdminId  The admin id
*/
- (void)conferenceReqSpeakerRefused:(EMCallConference*)aConference adminId:(NSString*)aAdminId;

/*!
 * \~chinese
 * 收到申请管理员请求被拒绝的回调
 *
 * @param aConference     会议
 * @param aAdminId   管理员ID
 *
 * \~english
 * callback when admin refuse the request of become admin
 *
 * @param aConference     EMCallConference instance
 * @param aAdminId  The admin id
*/
- (void)conferenceReqAdminRefused:(EMCallConference*)aConference adminId:(NSString*)aAdminId;

/*!
 * \~chinese
 * 收到LiveCfg的回调，只有管理员能收到
 *
 * @param aConference     会议
 * @param aLiveConfig   收到的推流cdn配置LiveCfg
 * @param liveId 推流cdn的liveid
 *
 *\~english
 * callback when recv livecfg, only admin can recv
 *
 * @param aConference     EMCallConference instance
 * @param aLiveConfig  The cdn config
 * @param liveId The liveid of livecfg
*/
- (void)conferenceDidUpdated:(EMCallConference*)aConference liveCfg:(NSDictionary*) aLiveConfig;
/*!
 * \~chinese
 * 收到streamId的回调，发布流成功后收到此回调
 *
 * @param aConference     会议
 * @param rtcId   流的rtcId
 * @param streamId 流ID
 *
 *\~english
 * get the streamId of stream.callback when publish success
 *
 * @param aConference     EMCallConference instance
 * @param rtcId  The rtcId
 * @param streamId The streamId
*/
- (void)streamIdDidUpdate:(EMCallConference*)aConference rtcId:(NSString*)rtcId streamId:(NSString*)streamId;
/*!
 * \~chinese
 * 下行音频流无数据时，收到此回调
 *
 * @param aConference     会议
 * @param aType 流类型，音频或视频
 * @param streamId 流ID
 *
 *\~english
 * callback when the sub audio stream has no datas
 *
 * @param aConference     EMCallConference instance
 * @param aType Weather the stream is audio or video
 * @param streamId The streamId
*/
- (void)streamStateUpdated:(EMCallConference*)aConference type:(EMMediaType)aType state:(EMMediaState)state streamId:(NSString*)streamId;
/*!
 * \~chinese
 * 发送第一帧音视频数据时，收到此回调
 *
 * @param aConference     会议
 * @param aType 流类型，音频或视频
 * @param streamId 流ID
 *
 *\~english
 * callback when the pub stream send the first audio/video frame
 *
 * @param aConference     EMCallConference instance
 * @param aType Weather the stream is audio or video
 * @param streamId The streamId
*/
- (void)streamDidFirstFrameSended:(EMCallConference*)aConference type:(EMMediaType)aType streamId:(NSString*)streamId;

/*!
 * \~chinese
 * 接收流第一帧音视频数据时，收到此回调
 *
 * @param aConference     会议
 * @param aType 流类型，音频或视频
 * @param streamId 流ID
 *
 *\~english
 * callback when the sub stream recieve the first audio/video frame
 *
 * @param aConference     EMCallConference instance
 * @param aType Weather the stream is audio or video
 * @param streamId The streamId
*/
- (void)streamDidFirstFrameReceived:(EMCallConference*)aConference type:(EMMediaType)aType streamId:(NSString*)streamId;

/*!
 * \~chinese
 * 自动订阅音频失败
 *
 * @param aConference     会议
 * @param streamId 流ID
 * @param aError 失败信息
 *
 *\~english
 * auto subscribe audio stream fail
 *
 * @param aConference     EMCallConference instance
 * @param streamId The streamId
 * @param aError The fail description
*/
- (void)autoAudioStreamDidSubFail:(EMCallConference*)aConference streamId:(NSString*)streamId error:(EMError*)aError;

/*!
 * \~chinese
 * 自动取消订阅音频失败
 *
 * @param aConference     会议
 * @param streamId 流ID
 * @param aError 失败信息
 *
 *\~english
 * auto unsubscribe audio stream fail
 *
 * @param aConference     EMCallConference instance
 * @param streamId The streamId
 * @param aError The fail description
*/
- (void)autoAudioStreamDidUnsubFail:(EMCallConference*)aConference streamId:(NSString*)streamId error:(EMError*)aError;

/*!
 * \~chinese
 * 会议状态改变时，收到此回调
 *
 * @param aConference     会议
 * @param streamId 流ID
 *
 *\~english
 * callback when the conference state has updated
 *
 * @param aConference     EMCallConference instance
 * @param streamId The streamId
*/
- (void)confrenceDidUpdated:(EMCallConference*)aConference state:(EMConferenceState)aState;

/*!
 * \~chinese
 * 当前会议的媒体流质量报告回调
 *
 * @param aConference     会议
 * @param streamId 流ID
 * @param aReport   会议的质量参数
 *
 *\~english
 * get the streamId of stream.callback when publish success
 *
 * @param aConference     EMCallConference instance
 * @param streamId streamId
 * @param aReport  The stat report of stream
*/
- (void)conferenceDidUpdate:(EMCallConference*)aConference streamId:(NSString*)streamId statReport:(EMRTCStatsReport *)aReport;


#pragma mark - EM_DEPRECATED_IOS 3.4.3

/*!
 *  \~chinese
 *  有人加入会议
 *
 *  @param aConference       会议实例
 *  @param aUserName         加入的用户
 *
 *  \~english
 *  Someone joined the conference
 *
 *  @param aConference       EMConference instance
 *  @param aUserName         The joined user
 */
- (void)userDidJoin:(EMCallConference *)aConference
               user:(NSString *)aUserName EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -[EMConferenceManagerDelegate memberDidJoin:member:]");

/*!
 *  \~chinese
 *  有人离开会议
 *
 *  @param aConference       会议实例
 *  @param aMember           离开的用户
 *
 *  \~english
 *  Someone leaved the conference
 *
 *  @param aConference       EMConference instance
 *  @param aMember           The leaved user
 */
- (void)userDidLeave:(EMCallConference *)aConference
                user:(NSString *)aUserName EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -[EMConferenceManagerDelegate memberDidLeave:member:]");

/*!
 *  \~chinese
 *  被邀请加入会议
 *
 *  @param aConfId       会议ID (EMCallConference.confId)
 *  @param aPassword     会议密码
 *  @param aExt          扩展信息
 *
 *  \~english
 *  Invited to join the conference
 *
 *  @param aConfId       Conference ID (EMCallConference.confId)
 *  @param aPassword     The password of the conference
 *  @param aExt          Extended Information
 */
- (void)userDidRecvInvite:(NSString *)aConfId
                 password:(NSString *)aPassword
                      ext:(NSString *)aExt EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE");


@end


#endif /* EMConferenceManagerDelegate_h */
