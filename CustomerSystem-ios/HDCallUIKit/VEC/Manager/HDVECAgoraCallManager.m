//
//  HDAgoraCallManager.m
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import "HDVECAgoraCallManager.h"
#import <ReplayKit/ReplayKit.h>
#import <CoreMedia/CoreMedia.h>
#import "HDVECAgoraCallMember.h"
#import "HDCallFileManager.h"
#import "HDVECCallViewController.h"


#define kForService @"com.easemob.kf.demo.customer.ScreenShare"
#define kSaveAgoraToken @"call_agoraToken"
#define kSaveAgoraChannel @"call_agoraChannel"
#define kSaveAgoraAppID @"call_agoraAppid"
#define kSaveAgoraShareUID @"call_agoraShareUID"
#define kSaveAgoraCallId @"call_agoraCallId"

@interface HDVECAgoraCallManager () <AgoraRtcEngineDelegate,HDChatManagerDelegate>
{
    HDVECAgoraCallOptions *_options;
    AgoraRtcVideoCanvas *_canvas;
    NSString *_nickName;
    NSDictionary *_ext;
    NSString *_ticket;


    
   __block BOOL _isSetupLocalVideo; //判断是否已经设置过了；
  __block  BOOL _isCurrentFrontFacingCamera; //判断 当前摄像头状态。默认 前置 ；
    
    HDVECEnterpriseInfo *_enterprisemodel;
}

@property (nonatomic, strong) NSMutableArray *members;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKitScreenShare;


@property (nonatomic, copy) void (^Completion)(id, HDError *)  ;


@end
@implementation HDVECAgoraCallManager
{
    __block BOOL _onCalling; //正在通话
    NSString * _pubViewId;
    dispatch_queue_t _callQueue;
}
static HDVECAgoraCallManager *shareCall = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCall = [[HDVECAgoraCallManager alloc] init];
       
    });
    return shareCall;
}
#pragma mark - base
- (instancetype)init {
    self = [super init];
    if (self) {
        _onCalling = NO;
        _callQueue = dispatch_queue_create("com.CustomerSystem-ios.agoracall.queue", NULL);
        //添加消息监听
        [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

    }
    return self;
}
- (HDVECGuidanceModel *)setGuidancePostNotificationParWithConfigId:(NSString *)configid withImServecionNumer:(NSString *)imServecionNumer withCECSessionid:(NSString *)sessionId withCECVisitorId:(NSString *)visitorId{
    
    
    HDVECGuidanceModel * model = [[HDVECGuidanceModel alloc] init];
    model.vec_cecSessionId = sessionId;
    model.vec_cecVisitorId = visitorId;
    model.vec_imServiceNum = imServecionNumer;
    model.vec_configid = configid;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic hd_setValue:imServecionNumer forKey:@"easemob_vec_imservecnum"];
    [dic hd_setValue:configid forKey:@"easemob_vec_configid"];
    [dic hd_setValue:sessionId forKey:@"easemob_cec_relatedSessionId"];
    [dic hd_setValue:visitorId forKey:@"easemob_cec_relatedVisitorUserId"];
    return model;
}


- (void)vec_setCallOptions:(HDVECAgoraCallOptions *)aOptions{
    _options = aOptions;
}
- (HDVECAgoraCallOptions *)vec_getCallOptions{
    
    return _options;
}
- (void)setVec_imServiceNum:(NSString *)vec_imServiceNum{
    
    _vec_imServiceNum = vec_imServiceNum;
    
    [HDClient sharedClient].callManager.vec_imServiceNum = vec_imServiceNum;
    
    
}
#pragma mark - 收到消息代理
- (void)messagesDidReceive:(NSArray *)aMessages{
     //收到普通消息,格式:<HDMessage *>
    if (aMessages.count == 0) {
        return;
    }
    for (EMChatMessage *msg in aMessages) {
        if (msg.ext) {
            NSDictionary *dic = [msg.ext objectForKey:@"msgtype"];
            if (dic) {
                if ([[dic allKeys] containsObject: @"videoPlayback"]) {
                    
                   NSDictionary  *videoPlaybackDic = [dic valueForKey:@"videoPlayback"];
                    
                    NSString *  msg  = (NSString *) [videoPlaybackDic valueForKey:@"msg"];
                
                    if([msg isEqualToString:@"playback"]){
                        
                        NSDictionary *  videoObjDic  = [videoPlaybackDic valueForKey:@"videoObj"];
                        NSString *  callId ;
                        if([[videoObjDic allKeys] containsObject: @"callId"]){
                            
                            callId  = (NSString *) [videoPlaybackDic valueForKey:@"callId"];
                        }
                        //调用挂掉视频操作
                        [self agentHangUpCall:callId];
                        return;
                    }
                }
            }
        }
    }
}
#pragma mark - 懒加载
- (AgoraRtcEngineKit *)agoraKit {
    if (!_agoraKit) {
        _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId: [HDVECAgoraCallManager shareInstance].keyCenter.agoraAppid delegate:self];
        //设置频道场景
        [_agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        //设置角色
        [_agoraKit setClientRole:AgoraClientRoleBroadcaster];
        //启用视频模块
        [_agoraKit enableVideo];
    
        // set video configuration
        float size = _options.dimension.width;
        AgoraVideoEncoderConfiguration *configuration =[[AgoraVideoEncoderConfiguration alloc] initWithSize: (size>0 ? _options.dimension :AgoraVideoDimension480x480 ) frameRate:AgoraVideoFrameRateFps24 bitrate:_options.bitrate ? _options.bitrate :AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeAdaptative mirrorMode:AgoraVideoMirrorModeDisabled];
    
        [_agoraKit setVideoEncoderConfiguration:configuration];
        
        _isCurrentFrontFacingCamera = YES;
        [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:_callQueue];
    }
    return _agoraKit;
}
#pragma mark - 设置相关
- (void)vec_setEnableVirtualBackground:(BOOL)enable{
    
    AgoraVirtualBackgroundSource *backgroundSource = [[AgoraVirtualBackgroundSource alloc] init];
    backgroundSource.backgroundSourceType = AgoraVirtualBackgroundColor;
    
    AgoraSegmentationProperty  * seg = [[AgoraSegmentationProperty alloc] init];
    seg.modelType = SegModelAgoraAi;
    [self.agoraKit enableVirtualBackground:enable backData:backgroundSource segData:seg];
}
- (void)vec_setupLocalVideoView:(UIView *)localView{
    
    //这个地方添加判断是 为了防止调用setupLocalVideo 多次导致本地view 卡死
    if (_isSetupLocalVideo) {
        return;
    }
    _isSetupLocalVideo = YES;
    [HDLog logD:@"===%s setupLocalVideoView",__func__];
    AgoraRtcVideoCanvas * canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = [[HDVECAgoraCallManager shareInstance].keyCenter.agoraUid integerValue];
    canvas.view = localView;
    canvas.renderMode = AgoraVideoRenderModeHidden ;
    [self.agoraKit setupLocalVideo:canvas];
    [self.agoraKit startPreview];
    
}
- (void)vec_setupRemoteVideoView:(UIView *)remoteView withRemoteUid:(NSInteger)uid{
    [HDLog logD:@"===%s setupRemoteVideoView",__func__];
    AgoraRtcVideoCanvas * canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.view = remoteView;
    canvas.renderMode = AgoraVideoRenderModeFit;
    [self.agoraKit setupRemoteVideo:canvas];
    [self.agoraKit startPreview];
    
}

#pragma mark - 音视频事件

- (void)vec_switchCamera{
    
    [self.agoraKit switchCamera];
    
    _isCurrentFrontFacingCamera = !_isCurrentFrontFacingCamera;
}


- (BOOL)vec_getCurrentFrontFacingCamera{
    
    return _isCurrentFrontFacingCamera;
    
}

- (void)vec_pauseVoice{
    
    [self.agoraKit muteLocalAudioStream:YES];
}

- (void)vec_resumeVoice{
    
    [self.agoraKit muteLocalAudioStream:NO];
    
}
- (void)vec_enableLocalVideo:(BOOL)enabled{
    
    [self.agoraKit  enableLocalVideo:enabled];
}
- (void)vec_pauseVideo{
    [self.agoraKit  muteLocalVideoStream:YES];
}
- (void)vec_resumeVideo{
    
    [self.agoraKit  muteLocalVideoStream:NO];
}
- (void)vec_leaveChannel{
    _isSetupLocalVideo = NO;
    [self.agoraKit leaveChannel:nil];
    [_members removeAllObjects];
    
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self vec_destroy];
}
- (void)vec_joinAgoraRoom{
    [self hd_joinChannelByToken:[HDVECAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDVECAgoraCallManager shareInstance].keyCenter.agoraChannel info:nil uid:[[HDVECAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        _isCurrentFrontFacingCamera = YES;
        [HDLog logD:@"===%s joinSuccess joinChannelByToken channel=%@  uid=%lu",__func__,channel,(unsigned long)uid];
    }];
    
}

- (void)vec_normalEndCall{
    
    [self vec_leaveChannel];
    
    [HDLog logD:@"===%s closeVecCall",__func__];
    [[HDClient sharedClient].callManager vec_hangUpSessionId:[HDClient sharedClient].callManager.rtcSessionId WithImServiceNum:[HDVECAgoraCallManager shareInstance].vec_imServiceNum Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        
    }];
    
}
- (void)vec_ringGiveUp{
    [self vec_leaveChannel];
    
    HDMessage * message = [[HDClient sharedClient].callManager  vec_ringGiveUpMessageWithRtcSessionId:[HDClient sharedClient].callManager.rtcSessionId withImServiceNum:[HDVECAgoraCallManager shareInstance].vec_imServiceNum withCallId:[HDVECAgoraCallManager shareInstance].keyCenter.callid>0 ?[HDVECAgoraCallManager shareInstance].keyCenter.callid : [NSString stringWithFormat:@"null"]];
    
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
    }];

}
- (void)vec_rejectCall{
   
    HDMessage * message = [[HDClient sharedClient].callManager  vec_rejectMessageWithRtcSessionId:[HDClient sharedClient].callManager.rtcSessionId withImServiceNum:[HDVECAgoraCallManager shareInstance].vec_imServiceNum withCallId:[HDVECAgoraCallManager shareInstance].keyCenter.callid>0 ?[HDVECAgoraCallManager shareInstance].keyCenter.callid : [NSString stringWithFormat:@"null"]];
    
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
        
    }];
    [self vec_leaveChannel];
    
//    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
//    [self destroy];
}

/// 坐席主动挂断视频
/// @param callid  呼叫id
- (void)agentHangUpCall:(NSString *)callid{
    
    if (self.members.count != 0 ) {
        return;
    }
    if([self.roomDelegate respondsToSelector:@selector(onCallEndReason:)]){
        
        [self.roomDelegate onCallEndReason:@"agent-call-colse"];
    }
    //移除消息监控
    [[HDClient sharedClient].chatManager removeDelegate:self];
    [self vec_leaveChannel];

}
- (int)startPreview{
    return [self.agoraKit startPreview];
}
- (int)stopPreview{
    
    return [self.agoraKit stopPreview];
}
- (void)vec_destroy{
    _onCalling = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [AgoraRtcEngineKit destroy];
        self.agoraKit = nil;
        self.agoraKitScreenShare = nil;
    });
}
- (void)vec_setEnableSpeakerphone:(BOOL)enableSpeaker{
    
    [self.agoraKit setEnableSpeakerphone:enableSpeaker];
    
}
- (NSArray *)vec_hasJoinedMembers {
    return self.members;
}

- (NSMutableArray *)members{
    if (!_members) {
        _members = [[NSMutableArray alloc] init];
    }
    
    return _members;
}
- (void)vec_sendReportEvent{
    
    if (self.vec_isAutoReport) {
        [[HDClient sharedClient] vec_sendReportEventImServiceNum:[HDVECAgoraCallManager shareInstance].vec_imServiceNum];
    }
    
}
- (void)vec_offlinReportEvent{
    
    [[HDClient sharedClient].chatManager fetchCurrentVisitorId:[HDVECAgoraCallManager shareInstance].vec_imServiceNum completion:^(HDError *aError, NSString *visitorId) {
    
        if (visitorId) {
           
            [[HDClient sharedClient] vec_offLineReportEventVisitorId:visitorId];
        }
       
    }];
    
}
/**
 接受视频会话

 @param nickname 传递自己的昵称到对方
 @param completion 完成回调
 */
- (void)vec_acceptCallWithNickname:(NSString *)nickname completion:(void (^)(id, HDError *))completion{
    self.Completion = completion;
    [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 acceptCallWithNickname=%@",[HDVECAgoraCallManager shareInstance].keyCenter.agoraChannel];
    [self hd_joinChannelByToken:[HDVECAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDVECAgoraCallManager shareInstance].keyCenter.agoraChannel info:@"test123" uid:[[HDVECAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        
        [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 joinSuccess channel "];
        self.Completion(nil, nil);
        
    }];

}

- (BOOL)vec_getCallState{
    
    return  _onCalling;
    
}
- (void)hd_joinChannelByToken:(NSString *)token channelId:(NSString *)channelId info:(NSString *)info uid:(NSUInteger)uid joinSuccess:(void (^)(NSString * _Nullable, NSUInteger, NSInteger))joinSuccessBlock{
    
    [self.agoraKit joinChannelByToken: token channelId: channelId info:info uid: uid  joinSuccess:joinSuccessBlock];
}
- (HDVECAgoraCallMember *)getHDAgoraCallMember:(NSUInteger )uid {
    
    NSMutableDictionary * extensionDic =[NSMutableDictionary dictionaryWithDictionary:_ext];
    
    [extensionDic setValue:_nickName forKey:@"nickname"];
    
    HDVECAgoraCallMember *member = [[HDVECAgoraCallMember alloc] init];
    [member setValue:[NSString stringWithFormat:@"%lu",(unsigned long)uid] forKeyPath:@"memberName"];
    [member setValue:extensionDic forKeyPath:@"extension"];
    member.agentNickName = [HDVECAgoraCallManager shareInstance].keyCenter.agentNickName;
    return member;
}
#pragma mark - <AgoraRtcEngineDelegate>
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    [HDLog logD:@"HD===%s join Member  uid----%lu",__func__,(unsigned long)uid];
    HDVECAgoraCallMember *mem = [self getHDAgoraCallMember:uid];
    @synchronized(self.members){
        BOOL isNeedAdd = YES;
        for ( HDVECAgoraCallMember *member in self.members) {
            if ([member.memberName isEqualToString:mem.memberName]) {
                isNeedAdd = NO;
                break;
            }
        }
        if (isNeedAdd) {
            [self.members addObject: mem];
        }
    };
    if([self.roomDelegate respondsToSelector:@selector(onMemberJoin:)]){
        [self.roomDelegate onMemberJoin:mem];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed{
    
    [HDLog logD:@"HD==agoraRtcSDK=%s",__func__];
}



/// Reports an error during SDK runtime.
/// @param engine - RTC engine instance
/// @param errorCode - see complete list on this page
///         https://docs.agora.io/en/Video/API%20Reference/oc/Constants/AgoraErrorCode.html
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    HDError *dhError = [[HDError alloc] initWithDescription:@"Occur error " code:(HDErrorCode)errorCode];
    !self.Completion?:self.Completion(nil,dhError);
    [HDLog logD:@"HD==agoraRtcSDK=%s",__func__];
}


/// 远端用户（通信场景）/主播（直播场景）离开当前频道回调
/// @param engine engine
/// @param uid 离线的用户 ID。
/// @param reason 离线原因
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason{
  
    HDVECAgoraCallMember *mem = [self getHDAgoraCallMember:uid];
   
    HDVECAgoraCallMember *needRemove = nil;
    @synchronized(_members){
        for (HDVECAgoraCallMember *_member in self.members) {
            if ([_member.memberName isEqualToString:mem.memberName]) {
                needRemove = _member;
            }
        }
        if (needRemove) {
            [self.members removeObject:needRemove];
        }
    };
    
    [HDLog logI:@"HD================vec1.2=====didOfflineOfUid reason=%lu _thirdAgentUid= %lu",(unsigned long)reason,(unsigned long)uid];
    //如果房间里边人 都么有了 就发送通知 关闭。如果有人 就不关闭
//  [self agentHangUpCall:[HDAgoraCallManager shareInstance].keyCenter.callid];
   
    //通知代理
    if([self.roomDelegate respondsToSelector:@selector(onMemberExit:)]){
        [self.roomDelegate onMemberExit:mem];
    }
  
    
}
/// 远端用户音频静音回调
/// @param engine AgoraRtcEngineKit
/// @param muted muted
/// @param uid  uid
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid{
    
    
    //通知代理
    if([self.roomDelegate respondsToSelector:@selector(onCalldidAudioMuted:byUid:)]){
        
        [self.roomDelegate onCalldidAudioMuted:muted byUid:uid];
    }
}
/// 远端用户关闭视频回调
/// @param engine AgoraRtcEngineKit
/// @param muted muted
/// @param uid  uid
- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid{
    //通知代理
    if([self.roomDelegate respondsToSelector:@selector(onCalldidVideoMuted:byUid:)]){
        
        [self.roomDelegate onCalldidVideoMuted:muted byUid:uid];
    }
    
}
#pragma mark - AgoraRtcEngineKit 屏幕分享 相关
/// 保持动态数据 给其他app 进程通信
/// @param keyCenter 对象参数
- (void)saveAppKeyCenter:(HDKeyCenter *)keyCenter{

    self.userDefaults =[[NSUserDefaults alloc] initWithSuiteName:kVECAppGroup];
   
    
    [self.userDefaults setObject:keyCenter.agoraAppid forKey:kSaveAgoraAppID];
    
    [self.userDefaults setObject:keyCenter.agoraToken forKey:kSaveAgoraToken];
    
    [self.userDefaults setObject:keyCenter.agoraChannel forKey:kSaveAgoraChannel];
    
    [self.userDefaults setObject:[NSString stringWithFormat:@"%@",keyCenter.callid] forKey:kSaveAgoraCallId];
    
    [self.userDefaults setObject:[NSString stringWithFormat:@"%@",keyCenter.agoraUid] forKey:kSaveAgoraShareUID];
}

- (HDKeyCenter *)getAppKeyCenter{
    HDKeyCenter * keycenter= [[HDKeyCenter  alloc] init];
    keycenter.agoraAppid = [[HDVECAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraAppID];
    keycenter.agoraToken = [[HDVECAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraToken];
    keycenter.agoraChannel = [[HDVECAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraChannel];
    keycenter.shareUid = [[HDVECAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraShareUID];
    keycenter.agoraUid = [[HDVECAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraCallId];
    
    return  keycenter;
}

- (BOOL)isScreenShareUid:(NSUInteger)uid{
    HDKeyCenter * shareKey = [self getAppKeyCenter];
    if (shareKey.shareUid.length > 0) {
        if (uid == [shareKey.shareUid integerValue]) {
            return  YES;
        }
        return  NO;
    }
//    return uid >= SCREEN_SHARE_UID_MIN && uid <= SCREEN_SHARE_UID_MAX;
    return YES;
}
- (AgoraScreenCaptureParameters2 *)screenCaptureParams{
    
    if (!_screenCaptureParams) {
        _screenCaptureParams = [[AgoraScreenCaptureParameters2 alloc] init];
        _screenCaptureParams.captureAudio = YES;
        _screenCaptureParams.captureVideo = YES;
        
        AgoraScreenAudioParameters *audioParams = [[AgoraScreenAudioParameters alloc] init];
        audioParams.captureSignalVolume = 50;
            
       AgoraScreenVideoParameters *videoParams = [[AgoraScreenVideoParameters alloc] init];
       videoParams.dimensions = [self screenShareVideoDimension];
        videoParams.frameRate = AgoraVideoFrameRateFps30;
      _screenCaptureParams.videoParams = videoParams;
        _screenCaptureParams.audioParams = audioParams;
    
    }
    
    return _screenCaptureParams;
}
-(CGSize)screenShareVideoDimension{
    
    CGRect screenSize = [UIScreen mainScreen].bounds  ;
    CGSize boundingSize = CGSizeMake(540, 960);
    CGFloat mW = boundingSize.width / screenSize.size.width;
    CGFloat mH = boundingSize.height / screenSize.size.height;
          if (mH < mW) {
              boundingSize.width = boundingSize.height / screenSize.size.height * screenSize.size.width;
          } else if (mW < mH) {
              boundingSize.height = boundingSize.width / screenSize.size.width * screenSize.size.height;
          }
    return boundingSize;
}

- (void)vec_showMainWindowConfigId:(NSString *)configid withImServecionNumer:(NSString *)imServecionNumer withVisiorInfo:( HDVisitorInfo *)visitorinfo withCECSessionid:(NSString *)sessionid withCECVisitorId:( NSString *)visitorId{
    
    self.vec_imServiceNum= imServecionNumer;
    self.vec_configid = configid;
    self.vec_cecSessionId = sessionid;
    self.vec_cecVisitorId = visitorId;
    
    [self vec_initSetting:configid WithCompletion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
            
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主动发起的时候keyCenter 不需要传
        [[HDVECCallViewController sharedManager] showViewWithKeyCenter:nil withType:HDVECDirectionSend withVisitornickName:visitorinfo.nickName];
            [HDVECCallViewController sharedManager].hangUpVideoCallback = ^(HDVECCallViewController * _Nonnull callVC, NSString * _Nonnull timeStr) {
                [[HDVECCallViewController sharedManager]  removeView];

                [[HDVECCallViewController sharedManager] removeSharedManager];
            };
        });
    }];
}

- (void)vec_initSetting:(NSString *)configid WithCompletion:(void (^)(id responseObject, HDError * error))aCompletion {
    kWeakSelf
    [self vec_getConfigInfoCompletion:^(HDVECEnterpriseInfo * _Nonnull model, HDError *  error) {
        
            [[HDClient sharedClient].callManager vec_getInitConfigId:configid Completion:^(id  responseObject, HDError *error) {
                if (!error && [responseObject isKindOfClass:[NSDictionary class]] ) {
                    NSDictionary * dic= responseObject;
                    if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                        NSDictionary * tmp = [dic objectForKey:@"entity"];
                        NSString *configJson = [tmp objectForKey:@"configJson"];
                        NSDictionary *jsonDic = [[HDCallAppManger shareInstance] dictWithString:configJson];
                    //接口请求成功
                //        UI更新代码
                        HDVECInitLayoutModel * model = [weakSelf setModel:jsonDic];
                        [HDVECAgoraCallManager shareInstance].layoutModel = model;
                        
                        // 保存 model 到本地
                        [self vec_saveInitSettingData:jsonDic];
                    }
                }
                if (aCompletion) {
                    aCompletion(responseObject,nil);
                }
            }];
    }];
}

- (void)vec_getConfigInfoCompletion:(void (^)(HDVECEnterpriseInfo * model, HDError * error))aCompletion{
    // 获取插件信息
    [[HDClient sharedClient].callManager vec_getConfigInfoCompletion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        
        if (error ==nil&& [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            NSDictionary *entity = [dic valueForKey:@"entity"];
            if ([HDSDKHelper isNSDictionary:entity] ) {
                
                _enterprisemodel = [HDVECEnterpriseInfo hdyy_modelWithJSON:entity];
                
                if (_enterprisemodel) {
                    
                    if (aCompletion) {
                        aCompletion(_enterprisemodel,nil);
                    }
                }
            }
        }else{
            if (aCompletion) {
                aCompletion(nil,error);
            }
        }
    }];
}
- (HDVECEnterpriseInfo *)vec_getEnterpriseInfo{
    if (_enterprisemodel) {
        
        return _enterprisemodel;
    }
    
    return nil;
    
}

- (HDVECInitLayoutModel *)setModel:(NSDictionary *)dic{
    
    HDVECInitLayoutModel * model = [[HDVECInitLayoutModel alloc] init];
        if ([[dic allKeys] containsObject:@"functionSettings"]) {
            NSDictionary *functionSettings = [dic valueForKey:@"functionSettings"];
            model.visitorCameraOff = [[functionSettings valueForKey:@"visitorCameraOff"] integerValue];
            model.skipWaitingPage = [[functionSettings valueForKey:@"skipWaitingPage"] integerValue];
        }
        if ([[dic allKeys] containsObject:@"styleSettings"]) {
            NSDictionary *styleSettings = [dic valueForKey:@"styleSettings"];
            model.waitingPrompt = [styleSettings valueForKey:@"waitingPrompt"];
            model.waitingBackgroundPic = [styleSettings valueForKey:@"waitingBackgroundPic"];
            model.callingPrompt = [styleSettings valueForKey:@"callingPrompt"];
            model.callingBackgroundPic = [styleSettings valueForKey:@"callingBackgroundPic"];
            model.queuingPrompt = [styleSettings valueForKey:@"queuingPrompt"];
            model.queuingBackgroundPic = [styleSettings valueForKey:@"queuingBackgroundPic"];
            model.endingPrompt = [styleSettings valueForKey:@"endingPrompt"];
            model.endingBackgroundPic = [styleSettings valueForKey:@"endingBackgroundPic"];
        }
       
    return model;
}

//摄像头控制相关
//isCameraTorchSupported    检查设备是否支持打开闪光灯 只有后置摄像头 才启作用
-(BOOL)vec_isCameraTorchSupported{
    
    return [self.agoraKit isCameraTorchSupported];
    
}
///isCameraFocusPositionInPreviewSupported    检测设备是否支持手动对焦功能 只有后置摄像头 才启作用
-(BOOL)vec_isCameraFocusPositionInPreviewSupported{
    return [self.agoraKit isCameraFocusPositionInPreviewSupported];
}
///isCameraExposurePositionSupported    检测设备是否支持手动曝光功能
-(BOOL)vec_isCameraExposurePositionSupported{
    return [self.agoraKit isCameraExposurePositionSupported];
}

//setCameraFocusPositionInPreview    设置手动对焦位置，并触发对焦
- (BOOL)vec_setCameraFocusPositionInPreview:(CGPoint)position{
    
    return [self.agoraKit setCameraFocusPositionInPreview:position];
    
}
//setCameraExposurePosition    设置手动曝光位置
- (BOOL)vec_setCameraExposurePosition:(CGPoint)positionInView{
    return [self.agoraKit setCameraExposurePosition:positionInView];
}
//setCameraTorchOn    设置是否打开闪光灯
- (BOOL)vec_setCameraTorchOn:(BOOL)isOn{
    return [self.agoraKit setCameraTorchOn:isOn];
}

- (void)vec_saveInitSettingData:(NSDictionary *)dic{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([self class]), [HDVECAgoraCallManager shareInstance].vec_configid];
    
    [[HDCallFileManager shareCacheFileInstance] writeDictionary:dic atPath:path];
}
- (NSDictionary *)vec_getInitSettingData{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([self class]), [HDVECAgoraCallManager shareInstance].vec_configid];
    return [[HDCallFileManager shareCacheFileInstance] readDictionaryAtPath:path];
    
}
@end
