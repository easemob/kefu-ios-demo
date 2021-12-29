/*!
 *  \~chinese
 *  @header EMCallSession.h
 *  @abstract 会话
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallSession.h
 *  @abstract Call session
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallEnum.h"
#import "EMCommonDefs.h"

#import "EMCallVideoView.h"

/*!
 *  \~chinese
 *  1v1会话
 *
 *  \~english
 *  Call session
 */
@class EMError;
@interface EMCallSession : NSObject

/*!
 *  \~chinese
 *  会话标识符
 *
 *  \~english
 *  Unique call id. The call session ID is obtained after initiated a call startCall:remoteName:ext:completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock;
 */
@property (nonatomic, strong, readonly) NSString *callId;

/*!
 *  \~chinese 
 *  通话本地的username
 *
 *  \~english
 *  Local username
 */
@property (nonatomic, strong, readonly) NSString *localName;

/*!
 *  \~chinese
 *  通话的类型
 *
 *  \~english
 *  Call type
 */
@property (nonatomic, readonly) EMCallType type;

/*!
 *  \~chinese
 *  是否为主叫方
 *
 *  \~english
 *  Whether it is the caller, the call initiator
 */
@property (nonatomic, readonly) BOOL isCaller;

/*!
 *  \~chinese 
 *  对方的username
 *
 *  \~english
 *  Remote party's username
 */
@property (nonatomic, strong, readonly) NSString *remoteName;

/*!
 *  \~chinese 
 *  通话的状态
 *
 *  \~english 
 *  Call session status
 */
@property (nonatomic, readonly) EMCallSessionStatus status;

/*!
 *  \~chinese
 *  视频通话时自己的图像显示区域
 *
 *  \~english
 *  Local display view
 */
@property (nonatomic, strong) EMCallLocalVideoView *localVideoView;

/*!
 *  \~chinese
 *  视频通话时对方的图像显示区域
 *
 *  \~english
 *  Remote display view
 */
@property (nonatomic, strong) EMCallRemoteVideoView *remoteVideoView;

#pragma mark - Statistics Property

/*!
 *  \~chinese
 *  连接类型
 *
 *  \~english
 *  Connection type
 */
@property (nonatomic, readonly) EMCallConnectType connectType;

/*!
 *  \~chinese
 *  视频的延迟时间，单位是毫秒，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Video latency, in milliseconds, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int videoLatency;

/*!
 *  \~chinese
 *  本地视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video frame rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoFrameRate;

/*!
 *  \~chinese
 *  对方视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote party video frame rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int remoteVideoFrameRate;

/*!
 *  \~chinese
 *  本地视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local bitrate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoBitrate;

/*!
 *  \~chinese
 *  对方视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote party bitrate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int remoteVideoBitrate;

/*!
 *  \~chinese
 *  本地视频丢包率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video package lost rate, changing in real time
 *  return -1 if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) int localVideoLostRateInPercent;

/*!
 *  \~chinese
 *  对方视频丢包率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote video package lost rate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int remoteVideoLostRateInPercent;

/*!
 *  \~chinese
 *  对方视频分辨率
 *  未获取到返回 (-1,-1)
 *
 *  \~english
 *  Remote video resolution
 *  return (-1, 1) if no data is available. Usually no data until few seconds of calling later.
 */
@property (nonatomic, readonly) CGSize remoteVideoResolution;

/*!
 *  \~chinese
 *  服务端录制文件的id
 *
 *  \~english
 *  The id of the server recorded file
 */
@property (nonatomic, strong, readonly) NSString * serverVideoId;

/*!
 *  \~chinese
 *  是否启用服务器录制
 *
 *  \~english
 *  Whether server recording is enabled
 */
@property (nonatomic, readonly) BOOL willRecord;


/*!
 *  \~chinese
 *  消息扩展
 *
 *  类型必须是NSString
 *
 *  \~english
 *  Call extention
 *
 *  Type must be NSString
 */
@property (nonatomic, readonly) NSString *ext;

#pragma mark - Control Stream

/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Mute the voice during call by suspending voice data transmission
 *
 *  @result Error
 */
- (EMError *)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Unmute the voice during call by suspending voice data transmission
 *
 *  @result Error
 */
- (EMError *)resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  @result 错误
 *
 *  \~english
 * Suspend video data transmission
 *
 *  @result Error
 */
- (EMError *)pauseVideo;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Resume video data transmission
 *
 *  @result Error
 */
- (EMError *)resumeVideo;

#pragma mark - Camera

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  aIsFrontCamera    是否使用前置摄像头, YES使用前置, NO使用后置
 *
 *  \~english
 *  Use front camera or back camera. Default is front camera
 *
 *  @param  aIsFrontCamera    YES for front camera, NO for back camera.
 */
- (void)switchCameraPosition:(BOOL)aIsFrontCamera;

@end
