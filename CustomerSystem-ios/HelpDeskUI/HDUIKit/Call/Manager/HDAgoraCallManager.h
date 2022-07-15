//
//  HDAgoraCallManager.h
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "HDAgoraCallOptions.h"
#import "HDAgoraCallManagerDelegate.h"
#import "HDVideoLayoutModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nonnull kUserDefaultState = @"KEY_BXL_DEFAULT_STATE"; // 接收屏幕共享(开始/结束 状态)监听的Key

static NSString * _Nonnull kAppGroup = @"group.com.easemob.enterprise.demo.customer";
static void *KVOContext = &KVOContext;
@interface HDAgoraCallManager : NSObject
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, weak) id <HDAgoraCallManagerDelegate> roomDelegate;
@property (nonatomic, strong) HDKeyCenter *keyCenter;
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) HDVideoLayoutModel *layoutModel;
@property (nonatomic, strong) UIWindow *currentWindow;


+ (instancetype _Nullable )shareInstance;

/*!
 *  \~chinese
 *  发起视频邀请，发起后，客服会收到申请，客服同意后，会自动给访客拨过来。
 *
 *  @param aImId   会话id
 *  @param aContent   文本内容
 *
 */
- (HDMessage *)creteVideoInviteMessageWithImId:(NSString *)aImId
                                       content:(NSString *)aContent;
#pragma mark - Options
/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 */
- (void)setCallOptions:(HDAgoraCallOptions *_Nullable)aOptions;

/*!
 *  \~chinese
 *  获取通话状态  YES 通话中。NO 未通话
 */
- (BOOL)getCallState;
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
- (HDAgoraCallOptions *_Nullable)getCallOptions;

/*!
 *  \~chinese
 *   接受视频会话
 *
 *   @param nickname 传递自己的昵称到对方
 *   @param completion 完成回调
 *
 */
- (void)acceptCallWithNickname:(NSString *)nickname completion:(void (^_Nullable)(id, HDError *))completion;

/*!
 *  \~chinese
 *  获取已经加入的members
 *
 *  @result 已经加入的成员
 *
 *  \~english
 *  Get has joined members
 *
 *  @result has joined members
 */
- (NSArray *_Nullable)hasJoinedMembers;
/*!
 *  \~chinese
 *   切换摄像头
 *
 *  \~english
 *  Switching cameras
 */

- (void)switchCamera;
/*!
 *  \~chinese
 *  暂停语音数据传输
 *
 *  \~english
 *  Suspend voice data transmission
 */
- (void)pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *
 *
 *  \~english
 *  Resume voice data transmission
 *
 */
- (void)resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  \~english
 * Suspend video data transmission
 */
- (void)pauseVideo;

/*!
 *  \~chinese
 *  开启/关闭视频模块
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)enableLocalVideo:(BOOL )enabled;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)resumeVideo;
/*!
 *  \~chinese
 *  开启/关闭扬声器播放。

 *  \~english
 *  Enables/Disables the audio route to the speakerphone
 */
- (void)setEnableSpeakerphone:(BOOL)enableSpeaker;

/*!
 *  \~chinese
 *  开启/关闭 虚拟背景。

 *  \~english
 *  Enables/Disables enableVirtualBackground
 */
- (void)setEnableVirtualBackground:(BOOL)enable;

/*!
 *  \~chinese
 *  离开房间
 */
- (void)leaveChannel;
/*!
 *  \~chinese
 *  加入房间
 */
- (void)joinChannel;
/*!
 *  \~chinese
 *  结束视频会话。

 *  \~english
 *  Ending a Video Session
 */
- (void)endCall;

/*!
 *  \~chinese
 *  结束视频会话。 vec 独立访客端

 *  \~english
 *  Ending a Video Session
 */
- (void)endVecCall;
/*!
 *  \~chinese
 *  结束视频会话  通话中结束。 vec 独立访客端

 *  \~english
 *  Ending a Video Session
 */
- (void)closeVecCall;

/*!
 *  \~chinese
 *  拒绝视频会话。

 *  \~english
 *  Ending a Video Session
 */
- (void)refusedCall;
/*!
 *  \~chinese
 *  拒绝视频会话。 vec独立访客端

 *  \~english
 *  Ending a Video Session
 */
- (void)refusedVecCall;
/*!
 *  \~chinese
 *  销毁对象
 *  一个 App ID 只能用于创建一个 AgoraRtcEngineKit。如需更换 App ID，必须先调用 destroy 销毁当前 AgoraRtcEngineKit，并在 destroy 成功返回后，再调用 sharedEngineWithAppId 重新创建 AgoraRtcEngineKit。

 *  \~english
 *  destroy
 */
- (void)destroy;

/// 初始化本地视图。
/// @param localView 设置本地视频显示属性。
- (void)setupLocalVideoView:(UIView *)localView;
/// 初始化远端视图。
/// @param remoteView  远端试图
/// @param uid  远端的uid
- (void)setupRemoteVideoView:(UIView *)remoteView withRemoteUid:(NSInteger )uid;
- (void)initSettingWithCompletion:(void(^)(id  responseObject, HDError *error))aCompletion ;

/// 保存屏幕共享需要的数据
- (void)hd_saveShareDeskData:(HDKeyCenter*)keyCenter;

//摄像头控制相关
//isCameraTorchSupported    检查设备是否支持打开闪光灯
-(BOOL)isCameraTorchSupported;
//isCameraFocusPositionInPreviewSupported    检测设备是否支持手动对焦功能
-(BOOL)isCameraFocusPositionInPreviewSupported;
//isCameraExposurePositionSupported    检测设备是否支持手动曝光功能
-(BOOL)isCameraExposurePositionSupported;

//setCameraFocusPositionInPreview    设置手动对焦位置，并触发对焦
- (BOOL)setCameraFocusPositionInPreview:(CGPoint)position;
//setCameraExposurePosition    设置手动曝光位置
- (BOOL)setCameraExposurePosition:(CGPoint)positionInView;
//setCameraTorchOn    设置是否打开闪光灯
- (BOOL)setCameraTorchOn:(BOOL)isOn;

//cameraFocusDidChangedToRect    摄像头对焦区域已改变
//cameraExposureDidChangedToRect    摄像头曝光区域已改变


@end

NS_ASSUME_NONNULL_END
