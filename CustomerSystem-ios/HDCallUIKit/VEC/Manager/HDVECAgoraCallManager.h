//
//  HDAgoraCallManager.h
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "HDVECAgoraCallOptions.h"
#import "HDVECAgoraCallManagerDelegate.h"
#import "HDVECInitLayoutModel.h"
#import "HDVECEnterpriseInfo.h"
#import "HDCallAppManger.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * _Nonnull kVECUserDefaultState = @"KEY_BXL_DEFAULT_STATE"; // 接收屏幕共享(开始/结束 状态)监听的Key
static NSString * _Nonnull kVECAppGroup = @"group.com.easemob.kf.demo.customer";

@interface HDVECAgoraCallManager : NSObject
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) AgoraScreenCaptureParameters2 * screenCaptureParams;
@property (nonatomic, weak) id <HDVECAgoraCallManagerDelegate> roomDelegate;
@property (nonatomic, strong) HDKeyCenter *keyCenter;
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) HDVECInitLayoutModel *layoutModel;
@property (nonatomic, strong) UIViewController *currentVC;


// 视频需要的必要参数
@property (nonatomic, strong) NSString *vec_configid;
@property (nonatomic, strong) NSString *vec_imServiceNum;
@property (nonatomic, strong) HDVisitorInfo *vec_visitorInfo;


+ (instancetype _Nullable )shareInstance;

/// vec 视频界面的主入口
- (void)vec_showMainWindowConfigId:(NSString *)configid withImServecionNumer:(NSString *)imServecionNumer withVisiorInfo:(HDVisitorInfo*)visitorinfo;

/// 初始化排队界面数据 
/// @param aCompletion 回调接口数据
- (void)vec_initSetting:(NSString *)configid WithCompletion:(void(^)(id  responseObject, HDError *error))aCompletion ;
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
- (void)vec_setCallOptions:(HDVECAgoraCallOptions *_Nullable)aOptions;

/*!
 *  \~chinese
 *  获取通话状态  YES 通话中。NO 未通话
 */
- (BOOL)vec_getCallState;
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
- (HDVECAgoraCallOptions *)vec_getCallOptions;

/*!
 *  \~chinese
 *   接受视频会话
 *
 *   @param nickname 传递自己的昵称到对方
 *   @param completion 完成回调
 *
 */
- (void)vec_acceptCallWithNickname:(NSString *)nickname completion:(void (^_Nullable)(id, HDError *))completion;

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
- (NSArray *_Nullable)vec_hasJoinedMembers;
/*!
 *  \~chinese
 *   切换摄像头
 *
 *  \~english
 *  Switching cameras
 */

- (void)vec_switchCamera;

/*!
 *  \~chinese
 *   当前摄像头 是不是 前置摄像头
 */
- (BOOL)vec_getCurrentFrontFacingCamera;
/*!
 *  \~chinese
 *  暂停语音数据传输
 *  \~english
 *  Suspend voice data transmission
 */
- (void)vec_pauseVoice;

/*!
 *  \~chinese
 *  恢复语音数据传输
 *  \~english
 *  Resume voice data transmission
 */
- (void)vec_resumeVoice;

/*!
 *  \~chinese
 *  暂停视频图像数据传输
 *
 *  \~english
 * Suspend video data transmission
 */
- (void)vec_pauseVideo;

/*!
 *  \~chinese
 *  开启/关闭视频模块
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)vec_enableLocalVideo:(BOOL )enabled;

/*!
 *  \~chinese
 *  恢复视频图像数据传输
 *
 *  \~english
 *  Resume video data transmission
 */
- (void)vec_resumeVideo;
/*!
 *  \~chinese
 *  开启/关闭扬声器播放。

 *  \~english
 *  Enables/Disables the audio route to the speakerphone
 */
- (void)vec_setEnableSpeakerphone:(BOOL)enableSpeaker;

/*!
 *  \~chinese
 *  开启/关闭 虚拟背景。

 *  \~english
 *  Enables/Disables enableVirtualBackground
 */
- (void)vec_setEnableVirtualBackground:(BOOL)enable;

/*!
 *  \~chinese
 *  离开房间
 */
- (void)vec_leaveChannel;
/*!
 *  \~chinese
 *  加入房间
 */
- (void)vec_joinAgoraRoom;


/*!
 *  \~chinese
 *  结束视频会话。 未接通前 振铃放弃

 *  \~english
 *  Ending a Video Session
 */
- (void)vec_ringGiveUp;
/*!
 *  \~chinese
 *  结束视频会话
 *  NORMAL  正常结束（接通后结束）

 *  \~english
 *  Ending a Video Session
 */
- (void)vec_normalEndCall;

/*!
 *  \~chinese
 *  拒绝视频会话。
 *  VISITOR_REJECT   访客拒接（振铃过程中访客主动挂断）
 *  \~english
 *  Ending a Video Session
 */
- (void)vec_rejectCall;
/*!
 *  \~chinese
 *  销毁对象
 *  一个 App ID 只能用于创建一个 AgoraRtcEngineKit。如需更换 App ID，必须先调用 destroy 销毁当前 AgoraRtcEngineKit，并在 destroy 成功返回后，再调用 sharedEngineWithAppId 重新创建 AgoraRtcEngineKit。

 *  \~english
 *  destroy
 */
- (void)vec_destroy;

/// 初始化本地视图。
/// @param localView 设置本地视频显示属性。
- (void)vec_setupLocalVideoView:(UIView *)localView;

/// 初始化远端视图。
/// @param remoteView  远端试图
/// @param uid  远端的uid
- (void)vec_setupRemoteVideoView:(UIView *)remoteView withRemoteUid:(NSInteger )uid;



//摄像头控制相关
///isCameraTorchSupported    检查设备是否支持打开闪光灯
-(BOOL)vec_isCameraTorchSupported;
///isCameraFocusPositionInPreviewSupported    检测设备是否支持手动对焦功能
-(BOOL)vec_isCameraFocusPositionInPreviewSupported;
//isCameraExposurePositionSupported    检测设备是否支持手动曝光功能
-(BOOL)vec_isCameraExposurePositionSupported;
//setCameraFocusPositionInPreview    设置手动对焦位置，并触发对焦
- (BOOL)vec_setCameraFocusPositionInPreview:(CGPoint)position;
//setCameraExposurePosition    设置手动曝光位置
- (BOOL)vec_setCameraExposurePosition:(CGPoint)positionInView;
//setCameraTorchOn    设置是否打开闪光灯
- (BOOL)vec_setCameraTorchOn:(BOOL)isOn;
//cameraFocusDidChangedToRect    摄像头对焦区域已改变
//cameraExposureDidChangedToRect    摄像头曝光区域已改变
- (HDVECEnterpriseInfo *)vec_getEnterpriseInfo;
- (void)vec_getConfigInfoCompletion:(void (^)(HDVECEnterpriseInfo * model, HDError * error))aCompletion;

//文件相关
//保存 数据
-(void)vec_saveInitSettingData:(NSDictionary *)dic;
//获取数据
-(NSDictionary *)vec_getInitSettingData;
- (HDVECInitLayoutModel *)setModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
