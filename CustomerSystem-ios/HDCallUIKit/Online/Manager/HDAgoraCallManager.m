//
//  HDAgoraCallManager.m
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import "HDAgoraCallManager.h"
#import <ReplayKit/ReplayKit.h>
#import <CoreMedia/CoreMedia.h>
#import "HDAgoraCallMember.h"

#define kForService @"com.easemob.kf.demo.customer.ScreenShare"
#define kSaveAgoraToken @"call_agoraToken"
#define kSaveAgoraChannel @"call_agoraChannel"
#define kSaveAgoraAppID @"call_agoraAppid"
#define kSaveAgoraShareUID @"call_agoraShareUID"
#define kSaveAgoraCallId @"call_agoraCallId"

// 存放屏幕分享的状态
#define kSaveScreenShareState @"Easemob_ScreenShareState"
//static NSInteger audioSampleRate = 48000;
//static NSInteger audioChannels = 2;
//static uint32_t SCREEN_SHARE_UID_MIN  = 501;
//static uint32_t SCREEN_SHARE_UID_MAX  = 1000;

@interface HDAgoraCallManager () <AgoraRtcEngineDelegate,HDChatManagerDelegate>
{
    HDAgoraCallOptions *_options;
    AgoraRtcVideoCanvas *_canvas;
    NSString *_nickName;
    NSDictionary *_ext;
    NSString *_ticket;
   __block BOOL _isSetupLocalVideo; //判断是否已经设置过了；
  __block  BOOL _isCurrentFrontFacingCamera; //判断 当前摄像头状态。默认 前置 ；
    
}

@property (nonatomic, strong) NSMutableArray *members;

@property (nonatomic, copy) void (^Completion)(id, HDError *)  ;


@end
@implementation HDAgoraCallManager
{
    __block BOOL _onCalling; //正在通话
    dispatch_queue_t _callQueue;
}
static HDAgoraCallManager *shareCall = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCall = [[HDAgoraCallManager alloc] init];
       
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

- (void)setCallOptions:(HDAgoraCallOptions *)aOptions{
    _options = aOptions;
}
- (HDAgoraCallOptions *)getCallOptions{
    
    return _options;
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
        _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId: [HDAgoraCallManager shareInstance].keyCenter.agoraAppid delegate:self];
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
- (void)setEnableVirtualBackground:(BOOL)enable{
    
    AgoraVirtualBackgroundSource *backgroundSource = [[AgoraVirtualBackgroundSource alloc] init];
    backgroundSource.backgroundSourceType = AgoraVirtualBackgroundColor;
    AgoraSegmentationProperty  * seg = [[AgoraSegmentationProperty alloc] init];
    seg.modelType = SegModelAgoraAi;
    [self.agoraKit enableVirtualBackground:enable backData:backgroundSource segData:seg];
}
- (void)setupLocalVideoView:(UIView *)localView{
    
    //这个地方添加判断是 为了防止调用setupLocalVideo 多次导致本地view 卡死
    if (_isSetupLocalVideo) {
        return;
    }
    _isSetupLocalVideo = YES;
    [HDLog logD:@"===%s setupLocalVideoView",__func__];
    AgoraRtcVideoCanvas * canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = [[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue];
    canvas.view = localView;
    canvas.renderMode = AgoraVideoRenderModeHidden ;
    [self.agoraKit setupLocalVideo:canvas];
    [self.agoraKit startPreview];
    
}
- (void)setupRemoteVideoView:(UIView *)remoteView withRemoteUid:(NSInteger)uid{
    [HDLog logD:@"===%s setupRemoteVideoView",__func__];
    AgoraRtcVideoCanvas * canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.view = remoteView;
    canvas.renderMode = AgoraVideoRenderModeFit;
    [self.agoraKit setupRemoteVideo:canvas];
    [self.agoraKit startPreview];
    
}

#pragma mark - 音视频事件

- (void)switchCamera{
    
    [self.agoraKit switchCamera];
    
    _isCurrentFrontFacingCamera = !_isCurrentFrontFacingCamera;
}


- (BOOL)getCurrentFrontFacingCamera{
    
    return _isCurrentFrontFacingCamera;
    
}

- (void)pauseVoice{
    
    [self.agoraKit muteLocalAudioStream:YES];
}

- (void)resumeVoice{
    
    [self.agoraKit muteLocalAudioStream:NO];
    
}
- (void)enableLocalVideo:(BOOL)enabled{
    
    [self.agoraKit  enableLocalVideo:enabled];
}
- (void)pauseVideo{
    [self.agoraKit  muteLocalVideoStream:YES];
}
- (void)resumeVideo{
    
    [self.agoraKit  muteLocalVideoStream:NO];
}
- (void)leaveChannel{
    _isSetupLocalVideo = NO;
    [self.agoraKit leaveChannel:nil];
    [HDCallManager shareInstance].isVecVideo =NO;
    [_members removeAllObjects];
    
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self destroy];
}
- (void)joinChannel{
    [self hd_joinChannelByToken:[HDAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDAgoraCallManager shareInstance].keyCenter.agoraChannel info:nil uid:[[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        _isCurrentFrontFacingCamera = YES;
        [HDLog logD:@"===%s joinSuccess joinChannelByToken channel=%@  uid=%lu",__func__,channel,(unsigned long)uid];
    }];
    
}
- (void)endCall{
    
    //发送透传消息cmd。
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"Agorartcmedia"];
    NSString *from = [[HDClient sharedClient] currentUsername];
    HDMessage *message = [[HDMessage alloc] initWithConversationID:[[HDCallManager shareInstance] conversationId] from:from to:[[HDCallManager shareInstance] conversationId] body:body];
    NSDictionary *dic = @{
                          @"type":@"agorartcmedia/video",
                          @"msgtype":@{
                                  @"visitorCancelInvitation":@{
                                      @"callId":[HDAgoraCallManager shareInstance].keyCenter.callid>0 ?[HDAgoraCallManager shareInstance].keyCenter.callid : [NSString stringWithFormat:@"null"]
                                          }
                                  }
                          };
    message.ext = dic;
    
   
    
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
        
    }];
    
    [self leaveChannel];
    
   
}


- (void)refusedCall{
    
    //发送透传消息cmd
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"Agorartcmedia"];
    NSString *from = [[HDClient sharedClient] currentUsername];
    HDMessage *message = [[HDMessage alloc] initWithConversationID:[[HDCallManager shareInstance] conversationId] from:from to:[[HDCallManager shareInstance] conversationId] body:body];
    NSDictionary *dic = @{
                          @"type":@"agorartcmedia/video",
                          @"msgtype":@{
                                  @"visitorRejectInvitation":@{
                                          @"callId":[HDAgoraCallManager shareInstance].keyCenter.callid>0 ?[HDAgoraCallManager shareInstance].keyCenter.callid : [NSString stringWithFormat:@"null"]
                                          }
                                  }
                          };
    message.ext = dic;
    
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
        
        
    }];
    [self leaveChannel];
    
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
    [self leaveChannel];

}
- (int)startPreview{
    return [self.agoraKit startPreview];
}
- (int)stopPreview{
    
    return [self.agoraKit stopPreview];
}
- (void)destroy{
    _onCalling = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [AgoraRtcEngineKit destroy];
        self.agoraKit = nil;
    });
}
- (void)setEnableSpeakerphone:(BOOL)enableSpeaker{
    
    [self.agoraKit setEnableSpeakerphone:enableSpeaker];
    
}
- (NSArray *)hasJoinedMembers {
    return self.members;
}

- (NSMutableArray *)members{
    if (!_members) {
        _members = [[NSMutableArray alloc] init];
    }
    
    return _members;
}

/**
 接受视频会话

 @param nickname 传递自己的昵称到对方
 @param completion 完成回调
 */
- (void)acceptCallWithNickname:(NSString *)nickname completion:(void (^)(id, HDError *))completion{
    self.Completion = completion;
    [HDLog logI:@"================在线中的视频=====收到坐席回呼cmd消息 acceptCallWithNickname=%@",[HDAgoraCallManager shareInstance].keyCenter.agoraChannel];
    [self hd_joinChannelByToken:[HDAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDAgoraCallManager shareInstance].keyCenter.agoraChannel info:@"test123" uid:[[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        
        [HDLog logI:@"================在线中的视频=====收到坐席回呼cmd消息 joinSuccess channel "];
        self.Completion(nil, nil);
        
    }];

}

- (BOOL)getCallState{
    
    return  _onCalling;
    
}
- (void)hd_joinChannelByToken:(NSString *)token channelId:(NSString *)channelId info:(NSString *)info uid:(NSUInteger)uid joinSuccess:(void (^)(NSString * _Nullable, NSUInteger, NSInteger))joinSuccessBlock{
    
    [self.agoraKit joinChannelByToken: token channelId: channelId info:info uid: uid  joinSuccess:joinSuccessBlock];
}
- (HDAgoraCallMember *)getHDAgoraCallMember:(NSUInteger )uid {
    
    NSMutableDictionary * extensionDic =[NSMutableDictionary dictionaryWithDictionary:_ext];
    
    [extensionDic setValue:_nickName forKey:@"nickname"];
    
    HDAgoraCallMember *member = [[HDAgoraCallMember alloc] init];
    [member setValue:[NSString stringWithFormat:@"%lu",(unsigned long)uid] forKeyPath:@"memberName"];
    [member setValue:extensionDic forKeyPath:@"extension"];
    member.agentNickName = [HDAgoraCallManager shareInstance].keyCenter.agentNickName;
    return member;
}
#pragma mark - <AgoraRtcEngineDelegate>
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    [HDLog logD:@"HD===%s join Member  uid----%lu",__func__,(unsigned long)uid];
    HDAgoraCallMember *mem = [self getHDAgoraCallMember:uid];
    @synchronized(self.members){
        BOOL isNeedAdd = YES;
        for ( HDAgoraCallMember *member in self.members) {
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
  
    HDAgoraCallMember *mem = [self getHDAgoraCallMember:uid];
   
    HDAgoraCallMember *needRemove = nil;
    @synchronized(_members){
        for (HDAgoraCallMember *_member in self.members) {
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

- (NSDictionary *)dictWithString:(NSString *)string {
    if (string && 0 != string.length) {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return nil;
        }
        return jsonDict;
    }
    
    return nil;
}

@end
