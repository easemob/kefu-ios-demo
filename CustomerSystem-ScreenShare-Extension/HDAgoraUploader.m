//
//  HDAgoraUploader.m
//  Demo
//
//  Created by houli on 2022/1/14.
//

#import "HDAgoraUploader.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "AgoraAudioProcessing.h"
#import "AgoraAudioTube.h"
#import <ReplayKit/ReplayKit.h>
#import "HDSSKeychain.h"
static HDAgoraUploader *manager = nil;
static NSInteger audioSampleRate = 48000;
static NSInteger audioChannels = 2;
@interface HDAgoraUploader(){
    
    
}
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;

@end
@implementation HDAgoraUploader
+ (instancetype)sharedAgoraEngine
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        manager = [[HDAgoraUploader alloc]init];
        [manager initAgoraRtcEngineKit];
      
          
    });
    return manager;
}
-  (void)initAgoraRtcEngineKit{
    
    //创建 AgoraRtcEngineKit 实例
//    NSString * appid = [HDSSKeychain passwordForService:kForService account:kSaveAgoraAppID];
    
    self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
    
    NSString * appid = [self.userDefaults valueForKey:kSaveAgoraAppID];
    
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId: appid delegate:nil];
    
    //设置频道场景
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    //设置角色
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    //启用视频模块
    [self.agoraKit enableVideo];
    //音频
    [self.agoraKit disableAudio];
    //视频自采集 (仅适用于 push 模式)
    [self.agoraKit setExternalVideoSource:YES useTexture:YES pushMode:YES];
    //初始化并返回一个新分配的具有指定视频分辨率的AgoraVideoEncoderConfiguration对象。
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:[self videoDimension]
                   frameRate:AgoraVideoFrameRateFps24 bitrate:AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    [self.agoraKit setVideoEncoderConfiguration:configuration];
    
    //设置音频编码配置
    [self.agoraKit setAudioProfile: AgoraAudioProfileMusicStandardStereo scenario:AgoraAudioScenarioDefault];
   
    
    //设置采集的音频格式
    [self.agoraKit setRecordingAudioFrameParametersWithSampleRate:audioSampleRate channel:audioChannels mode:AgoraAudioRawFrameOperationModeReadWrite samplesPerCall:1024];
    //多人通信场景的优化策略
    [ self.agoraKit setParameters:@"{\"che.audio.external_device\":true}"];
    [ self.agoraKit setParameters:@"{\"che.hardware_encoding\":1}"];
    [ self.agoraKit setParameters:@"{\"che.video.enc_auto_adjust\":0}"];
    //取消或恢复订阅所有远端用户的音频流。
    [self.agoraKit muteAllRemoteAudioStreams:YES];
    //取消或恢复订阅所有远端用户的视频流。
    [self.agoraKit muteAllRemoteVideoStreams:YES];
    
    //registerAudioPreprocessing
    [AgoraAudioProcessing registerAudioPreprocessing:self.agoraKit];
    
}

- (CGSize)videoDimension{
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGSize boundingSize = CGSizeMake(720, 1280);
    float mW = boundingSize.width / screenSize.width;
    float mH = boundingSize.height / screenSize.height;
    if( mH < mW ) {
        boundingSize.width = boundingSize.height / screenSize.height * screenSize.width;
    }else if( mW < mH ) {
        boundingSize.height = boundingSize.width / screenSize.width * screenSize.height;
    }
    return boundingSize;
}

/// 开始录屏
- (void)startBroadcast{
//    NSString * uid= [HDSSKeychain passwordForService:kForService account:kSaveAgoraShareUID];
//    NSString * token= [HDSSKeychain passwordForService:kForService account:kSaveAgoraToken];
//    NSString * channel= [HDSSKeychain passwordForService:kForService account:kSaveAgoraChannel];
    
    //使用app group
    NSString * uid= [self.userDefaults valueForKey:kSaveAgoraShareUID];
    NSString * token= [self.userDefaults valueForKey:kSaveAgoraToken];
    NSString * channel= [self.userDefaults valueForKey:kSaveAgoraChannel];
    
    [self.agoraKit joinChannelByToken:token channelId: channel info:nil uid:[uid integerValue] joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
       
        NSLog(@"===join success =uid=%lu  channel%@=" , (unsigned long)uid,channel);
        
    }];
    
}
#pragma mark - <AgoraRtcEngineDelegate>
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    NSLog(@"join Member  uid---- %lu ",(unsigned long)uid);
  
}


/// Reports an error during SDK runtime.
/// @param engine - RTC engine instance
/// @param errorCode - see complete list on this page
///         https://docs.agora.io/en/Video/API%20Reference/oc/Constants/AgoraErrorCode.html
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    
    NSLog(@"------%ld",(long)errorCode);

}
- (void)sendVideoBuffer:(CMSampleBufferRef)sampleBuffer{
    
    CVImageBufferRef videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (videoFrame == nil) {
            return;
        }
        int rotation = 0;
        if (@available(iOS 11.0, *)) {
            NSNumber * orientation = CMGetAttachment(sampleBuffer, (CFStringRef)RPVideoSampleOrientationKey, nil);
            CGImagePropertyOrientation ori = orientation.intValue;
            switch (ori) {
                case kCGImagePropertyOrientationUp:
                case kCGImagePropertyOrientationUpMirrored:
                    rotation = 0;
                    break;
                case kCGImagePropertyOrientationDown:
                case kCGImagePropertyOrientationDownMirrored:
                    rotation = 180;
                    break;
                case kCGImagePropertyOrientationLeft:
                case kCGImagePropertyOrientationLeftMirrored:
                    rotation = 90;
                    break;
                case kCGImagePropertyOrientationRight:
                case kCGImagePropertyOrientationRightMirrored:
                    rotation = 270;
                    break;
                default:
                    break;
            }
            CMTime time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            AgoraVideoFrame * frame = [AgoraVideoFrame new];
            frame.format = 12;
            frame.time = time;
            frame.textureBuf = videoFrame;
            frame.rotation =rotation;
            [self.agoraKit pushExternalVideoFrame:frame];
        }

}
- (void)sendAudioAppBuffer:(CMSampleBufferRef)sampleBuffer{
    
    [AgoraAudioTube agoraKit:self.agoraKit pushAudioCMSampleBuffer:sampleBuffer resampleRate:audioSampleRate type:AudioTypeApp];
}

- (void)sendAudioMicBuffer:(CMSampleBufferRef)sampleBuffer{
    
    [AgoraAudioTube agoraKit:self.agoraKit pushAudioCMSampleBuffer:sampleBuffer resampleRate:audioSampleRate type:AudioTypeMic];
}

- (void)stopBroadcast{
//    [self.agoraKit leaveChannel:nil];
//    [AgoraRtcEngineKit destroy];
}
@end
