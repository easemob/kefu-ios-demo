//
//  HCallSession.h
//  helpdesk_sdk
//
//  Created by __阿彤木_ on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCallLocalView.h"
#import "HCallRemoteView.h"

/*!
 *  \~chinese
 *  1v1会话
 *
 *  \~english
 *  Call session
 */

@interface HCallSession : NSObject


/*!
 *  \~chinese
 *  会话标识符
 *
 *  \~english
 *  Unique call id
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
@property (nonatomic, readonly) HCallType type;

/*!
 *  \~chinese
 *  主叫还是被叫
 *
 *  \~english
 *  Whether it is the caller
 */
@property (nonatomic, readonly) BOOL isCaller;

/*!
 *  \~chinese
 *  对方的username
 *
 *  \~english
 *  The other side's username
 */
@property (nonatomic, strong, readonly) NSString *remoteName;

/*!
 *  \~chinese
 *  通话的状态
 *
 *  \~english
 *  Call session status
 */
@property (nonatomic, readonly) HCallSessionStatus status;

/*!
 *  \~chinese
 *  视频通话时自己的图像显示区域
 *
 *  \~english
 *  Local display view
 */
@property (nonatomic, strong) HCallLocalView *localVideoView;

/*!
 *  \~chinese
 *  视频通话时对方的图像显示区域
 *
 *  \~english
 *  Remote display view
 */
@property (nonatomic, strong) HCallRemoteView *remoteVideoView;

#pragma mark - Statistics Property

/*!
 *  \~chinese
 *  连接类型
 *
 *  \~english
 *  Connection type
 */
@property (nonatomic, readonly) HCallConnectType connectType;

/*!
 *  \~chinese
 *  视频的延迟时间，单位是毫秒，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Video latency, in milliseconds, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int videoLatency;

/*!
 *  \~chinese
 *  本地视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video frame rate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int localVideoFrameRate;

/*!
 *  \~chinese
 *  对方视频的帧率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote video frame rate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int remoteVideoFrameRate;

/*!
 *  \~chinese
 *  本地视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local the other party's bitrate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int localVideoBitrate;

/*!
 *  \~chinese
 *  对方视频通话对方的比特率kbps，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Remote the other party's bitrate, changing in real time
 *  Didn't get to show -1
 */
@property (nonatomic, readonly) int remoteVideoBitrate;

/*!
 *  \~chinese
 *  本地视频丢包率，实时变化
 *  未获取到返回-1
 *
 *  \~english
 *  Local video package lost rate, changing in real time
 *  Didn't get to show -1
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
 *  Didn't get to show (-1,-1)
 */
@property (nonatomic, readonly) CGSize remoteVideoResolution;

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
 *  Suspend voice data transmission
 *
 *  @result Error
 */
- (HError *)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *  @result 错误
 *
 *  \~english
 *  Resume voice data transmission
 *
 *  @result Error
 */
- (HError *)resumeVoice;

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
- (HError *)pauseVideo;

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
- (HError *)resumeVideo;

#pragma mark - Camera

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  aIsFrontCamera    是否使用前置摄像头, YES使用前置, NO使用后置
 *
 *  \~english
 *  Use front camera or back camera, default use front
 *
 *  @param  aIsFrontCamera    YES for front camera, NO for back camera.
 */
- (void)switchCameraPosition:(BOOL)aIsFrontCamera;

@end
