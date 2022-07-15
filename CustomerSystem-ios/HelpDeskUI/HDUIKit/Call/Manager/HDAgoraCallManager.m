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
#import "HDSSKeychain.h"
#import "HDAgoraCallMember.h"
#define kToken @"00674855635d3a64920b0c7ee3684f68a9fIACA8a3yaqUdWNcyB5POBY85dP6+vnuMp8fVlCcFYHwStBo6pkUAAAAAEAD45Mp2OAPyYQEAAQA4A/Jh";
#define kAPPid  @"74855635d3a64920b0c7ee3684f68a9f";
#define kChannelName @"huanxin"

#define kForService @"com.easemob.enterprise.demo.customer.ScreenShare"
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


    
    BOOL _isSetupLocalVideo; //判断是否已经设置过了；
}

@property (nonatomic, strong) NSMutableArray *members;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKitScreenShare;


@property (nonatomic, copy) void (^Completion)(id, HDError *)  ;


@end
@implementation HDAgoraCallManager
{
    BOOL _onCalling; //正在通话
    NSMutableDictionary *_cacheStreams; //没有点击接受的时候缓存的stream
    NSMutableArray *_waitingQueue;  //正在加入会话
    NSString * _pubViewId;
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
        _cacheStreams = [NSMutableDictionary dictionaryWithCapacity:0];
        _waitingQueue = [NSMutableArray arrayWithCapacity:0];
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
//                        [self agentHangUpCall:callId];
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
    
        //开启虚拟背景
//        AgoraVirtualBackgroundSource *backgroundSource = [[AgoraVirtualBackgroundSource alloc] init];
//        backgroundSource.backgroundSourceType = AgoraVirtualBackgroundColor;
//        [_agoraKit enableVirtualBackground:NO backData:backgroundSource];
        //开启enableDeepLearningDenoiseSDK 默认开启传统降噪，以消除大部分平稳噪声。AI 降噪是指在传统降噪的基础上消除非平稳噪声。集成 AI 降噪插件后，你可以调用 enableDeepLearningDenoise 开启 AI 降噪
        [_agoraKit enableDeepLearningDenoise:YES];
        // set video configuration
        float size = _options.dimension.width;
        
         
//        _options.dimension = CGSizeMake( [UIScreen mainScreen].bounds.size, [UIScreen mainScreen].bounds.h)
        
        
        AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:  (size>0 ? _options.dimension : AgoraVideoDimension480x480) frameRate:_options.frameRate ? AgoraVideoFrameRateFps24 : (AgoraVideoFrameRate)_options.frameRate bitrate:_options.bitrate ? _options.bitrate :AgoraVideoBitrateStandard  orientationMode:_options.orientationMode ? (AgoraVideoOutputOrientationMode)_options.orientationMode :AgoraVideoOutputOrientationModeAdaptative];
        
        [_agoraKit setVideoEncoderConfiguration:configuration];
        

        [[HDClient sharedClient].chatManager addDelegate:self delegateQueue:_callQueue];
    }
    return _agoraKit;
}
#pragma mark - 设置相关
- (void)setEnableVirtualBackground:(BOOL)enable{
    
    AgoraVirtualBackgroundSource *backgroundSource = [[AgoraVirtualBackgroundSource alloc] init];
    backgroundSource.backgroundSourceType = AgoraVirtualBackgroundColor;
    [self.agoraKit enableVirtualBackground:enable backData:backgroundSource];
}
- (void)setupLocalVideoView:(UIView *)localView{
    
    //这个地方添加判断是 为了防止调用setupLocalVideo 多次导致本地view 卡死
    if (_isSetupLocalVideo) {
        return;
    }
    _isSetupLocalVideo = YES;
    NSLog(@"======setupLocalVideoView");
    AgoraRtcVideoCanvas * canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = [[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue];
    canvas.view = localView;
    canvas.renderMode = AgoraVideoRenderModeHidden ;
    [self.agoraKit setupLocalVideo:canvas];
    [self.agoraKit startPreview];
    
}
- (void)setupRemoteVideoView:(UIView *)remoteView withRemoteUid:(NSInteger)uid{
    NSLog(@"======setupRemoteVideoView");
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
/**
 * 发起视频邀请，发起后，客服会收到申请，客服同意后，会自动给访客拨过来。
 */
- (HDMessage *)creteVideoInviteMessageWithImId:(NSString *)aImId
                                       content:(NSString *)aContent {
    
    self.conversationId= aImId;
    EMTextMessageBody *txtBody = [[EMTextMessageBody alloc] initWithText:aContent];
    HDMessage *hdMessage = [[HDMessage alloc] initWithConversationID:aImId
                                                                from:[HDClient sharedClient].currentUsername
                                                                  to:aImId
                                                                body:txtBody];
    NSDictionary *dic = @{
                          @"type":@"agorartcmedia/video",
                          @"msgtype":@{
                                  @"liveStreamInvitation":@{
                                          @"resource": @"mobile",
                                          @"isNewInvitation":@(YES)
                                          }
                                  }
                          };
    hdMessage.ext = dic;
    return hdMessage;
}
- (void)leaveChannel{
    _isSetupLocalVideo = NO;
    [self.agoraKit leaveChannel:nil];
    [HDCallManager shareInstance].isVecVideo =NO;
    [_members removeAllObjects];
}
- (void)joinChannel{
    [self hd_joinChannelByToken:[HDAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDAgoraCallManager shareInstance].keyCenter.agoraChannel info:nil uid:[[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        NSLog(@"joinSuccess joinChannelByToken channel=%@  uid=%lu",channel,(unsigned long)uid);
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
        
        NSLog(@"===%@",aError);
        
    }];
    
    [self leaveChannel];
    
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self destroy];
}
- (void)closeVecCall{
    
    [self leaveChannel];
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self destroy];
    
    [[HDClient sharedClient].callManager hd_hangUpVECSessionId:@"123" WithVisitorId:@"456" Completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        
        NSLog(@"=====%@",responseObject);
        
    }];
    
}
- (void)endVecCall{
    [self leaveChannel];
    //发送透传消息cmd
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
    
    NSDictionary *dic1 = @{@"targetSystem":@"kefurtc"};
    [message addAttributeDictionary:dic1];
    
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
        
        NSLog(@"===%@",aError);
        
    }];

}
- (void)refusedVecCall{
    

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
    NSDictionary *dic1 = @{@"targetSystem":@"kefurtc"};
    [message addAttributeDictionary:dic1];
    [[HDClient sharedClient].chatManager sendMessage:message progress:nil completion:^(HDMessage *aMessage, HDError *aError) {
        
        NSLog(@"===%@",aError);
        
    }];
    [self leaveChannel];
    
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self destroy];
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
        
        NSLog(@"===%@",aError);
        
    }];
    [self leaveChannel];
    
    //该方法为同步调用，需要等待 AgoraRtcEngineKit 实例资源释放后才能执行其他操作，所以我们建议在子线程中调用该方法，避免主线程阻塞。此外，我们不建议 在 SDK 的回调中调用 destroy，否则由于 SDK 要等待回调返回才能回收相关的对象资源，会造成死锁。
    [self destroy];
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
    [self destroy];
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
        self.agoraKitScreenShare = nil;
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
    [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 acceptCallWithNickname=%@",[HDAgoraCallManager shareInstance].keyCenter.agoraChannel];
    [self hd_joinChannelByToken:[HDAgoraCallManager shareInstance].keyCenter.agoraToken channelId:[HDAgoraCallManager shareInstance].keyCenter.agoraChannel info:nil uid:[[HDAgoraCallManager shareInstance].keyCenter.agoraUid integerValue] joinSuccess:^(NSString * _Nullable channel, NSUInteger uid, NSInteger elapsed) {
        _onCalling = YES;
        [HDLog logI:@"================vec1.2=====收到坐席回呼cmd消息 joinSuccess channel "];
        self.Completion(nil, nil);
        
    }];

}
- (void)hd_saveShareDeskData:(HDKeyCenter *)keyCenter{
    
    if (keyCenter) {
        
        [self saveAppKeyCenter:[HDAgoraCallManager shareInstance].keyCenter];
    }
    
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
    
    NSLog(@"join Member  uid---- %lu ",(unsigned long)uid);
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

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed
{
    NSLog(@"remoteVideoStateChangedOfUid %@ %@ %@", @(uid), @(state), @(reason));
}
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed{
    
    NSLog(@"remoteVideoStateChangedOfUid");
    
}



/// Reports an error during SDK runtime.
/// @param engine - RTC engine instance
/// @param errorCode - see complete list on this page
///         https://docs.agora.io/en/Video/API%20Reference/oc/Constants/AgoraErrorCode.html
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    HDError *dhError = [[HDError alloc] initWithDescription:@"Occur error " code:(HDErrorCode)errorCode];
    !self.Completion?:self.Completion(nil,dhError);

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
    
    [HDLog logI:@"================vec1.2=====didOfflineOfUid _thirdAgentUid= %lu",(unsigned long)uid];
    //如果房间里边人 都么有了 就发送通知 关闭。如果有人 就不关闭
//  [self agentHangUpCall:[HDAgoraCallManager shareInstance].keyCenter.callid];
   
    //通知代理
    if([self.roomDelegate respondsToSelector:@selector(onMemberExit:)]){
        [self.roomDelegate onMemberExit:mem];
    }
  
    
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine virtualBackgroundSourceEnabled:(BOOL)enabled reason:(AgoraVirtualBackgroundSourceStateReason)reason{
    
    NSLog(@"virtualBackgroundSourceEnabled = %d  &#xe650; = reason=%luu",enabled,(unsigned long)reason);
    
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

    self.userDefaults =[[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
   
    
    [self.userDefaults setObject:keyCenter.agoraAppid forKey:kSaveAgoraAppID];
    
    [self.userDefaults setObject:keyCenter.agoraToken forKey:kSaveAgoraToken];
    
    [self.userDefaults setObject:keyCenter.agoraChannel forKey:kSaveAgoraChannel];
    
    [self.userDefaults setObject:[NSString stringWithFormat:@"%@",keyCenter.callid] forKey:kSaveAgoraCallId];
    
    [self.userDefaults setObject:[NSString stringWithFormat:@"%@",keyCenter.agoraUid] forKey:kSaveAgoraShareUID];
    
//
   
}

- (HDKeyCenter *)getAppKeyCenter{
    HDKeyCenter * keycenter= [[HDKeyCenter  alloc] init];
//    keycenter.agoraAppid =  [HDSSKeychain passwordForService:kForService account:kSaveAgoraAppID];
//    keycenter.agoraToken =  [HDSSKeychain passwordForService:kForService account:kSaveAgoraToken];
//    keycenter.agoraChannel =  [HDSSKeychain passwordForService:kForService account:kSaveAgoraChannel];
//    keycenter.shareUid =  [HDSSKeychain passwordForService:kForService account:kSaveAgoraShareUID];
//    keycenter.callid =  [HDSSKeychain passwordForService:kForService account:kSaveAgoraCallId];
    
    keycenter.agoraAppid = [[HDAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraAppID];
    keycenter.agoraAppid = [[HDAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraAppID];
    keycenter.agoraAppid = [[HDAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraAppID];
    keycenter.agoraAppid = [[HDAgoraCallManager shareInstance].userDefaults valueForKey:kSaveAgoraAppID];
    
    
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

- (void)initSettingWithCompletion:(void(^)(id  responseObject, HDError *error))aCompletion {
    kWeakSelf
    [[HDClient sharedClient].callManager hd_getInitVECSettingWithCompletion:^(id  responseObject, HDError *error) {
    
        if (!error && [responseObject isKindOfClass:[NSDictionary class]] ) {
            
            NSDictionary * dic= responseObject;
            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
           
                NSDictionary * tmp = [dic objectForKey:@"entity"];
                
                NSString *configJson = [tmp objectForKey:@"configJson"];
                NSDictionary *jsonDic = [weakSelf dictWithString:configJson];
                
                
                
            //接口请求成功
        //        UI更新代码
                HDVideoLayoutModel * model = [weakSelf setModel:jsonDic];
                
                [HDAgoraCallManager shareInstance].layoutModel = model;
                
               
            }
        }
        if (aCompletion) {
            aCompletion(responseObject,nil);
        }
    }];
}
- (NSDictionary *)dictWithString:(NSString *)string {
    if (string && 0 != string.length) {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"==%@",error);
            return nil;
        }
        return jsonDict;
    }
    
    return nil;
}
- (HDVideoLayoutModel *)setModel:(NSDictionary *)dic{
    
    HDVideoLayoutModel * model = [[HDVideoLayoutModel alloc] init];
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
//isCameraTorchSupported    检查设备是否支持打开闪光灯
-(BOOL)isCameraTorchSupported{
    
    
    return [self.agoraKit isCameraTorchSupported];
    
}
//isCameraFocusPositionInPreviewSupported    检测设备是否支持手动对焦功能
-(BOOL)isCameraFocusPositionInPreviewSupported{
    return [self.agoraKit isCameraFocusPositionInPreviewSupported];
}
//isCameraExposurePositionSupported    检测设备是否支持手动曝光功能
-(BOOL)isCameraExposurePositionSupported{
    return [self.agoraKit isCameraExposurePositionSupported];
}

//setCameraFocusPositionInPreview    设置手动对焦位置，并触发对焦
- (BOOL)setCameraFocusPositionInPreview:(CGPoint)position{
    
    return [self.agoraKit setCameraFocusPositionInPreview:position];
    
}
//setCameraExposurePosition    设置手动曝光位置
- (BOOL)setCameraExposurePosition:(CGPoint)positionInView{
    return [self.agoraKit setCameraExposurePosition:positionInView];
}
//setCameraTorchOn    设置是否打开闪光灯
- (BOOL)setCameraTorchOn:(BOOL)isOn{
    return [self.agoraKit setCameraTorchOn:isOn];
}


@end
