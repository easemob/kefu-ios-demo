//
//  HDAgoraUploader.m
//  Demo
//
//  Created by houli on 2022/1/14.
//

#import "HDAgoraUploader.h"
#import <HelpDesk/HelpDesk.h>
#import "AgoraAudioProcessing.h"
#import "AgoraAudioTube.h"
#import <ReplayKit/ReplayKit.h>
static NSInteger audioSampleRate = 48000;
static HDAgoraUploader *manager = nil;

@interface HDAgoraUploader()

@end
@implementation HDAgoraUploader
+ (instancetype)sharedAgoraEngine
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        manager = [[HDAgoraUploader alloc]init];
        
    });
    return manager;
}

- (void)startBroadcast{
        
    //先注册audio
//    [AgoraAudioProcessing registerAudioPreprocessing:[[HDClient sharedClient].agoraCallManager getBroadcastRtcEngine]];
    //在开启
//    [[HDClient sharedClient].agoraCallManager startBroadcast];
    
}
- (void)sendVideoBuffer:(CMSampleBufferRef _Nullable )sampleBuffer{
    
//    [[HDClient sharedClient].agoraCallManager sendVideoBuffer:sampleBuffer];
}
- (void)sendAudioAppBuffer:(CMSampleBufferRef)sampleBuffer{
    
//    [AgoraAudioTube agoraKit: [[HDClient sharedClient].agoraCallManager getBroadcastRtcEngine] pushAudioCMSampleBuffer:sampleBuffer resampleRate:audioSampleRate type:AudioTypeApp];
}

- (void)sendAudioMicBuffer:(CMSampleBufferRef)sampleBuffer{
    
//    [AgoraAudioTube agoraKit: [[HDClient sharedClient].agoraCallManager getBroadcastRtcEngine] pushAudioCMSampleBuffer:sampleBuffer resampleRate:audioSampleRate type:AudioTypeMic];
}

- (void)stopBroadcast{
    
//    [[HDClient sharedClient].agoraCallManager stopBroadcast];
    
}
@end
