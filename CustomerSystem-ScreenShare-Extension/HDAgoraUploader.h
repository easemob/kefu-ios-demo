//
//  HDAgoraUploader.h
//  Demo
//
//  Created by houli on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
@interface HDAgoraUploader : NSObject

+ (instancetype _Nullable )sharedAgoraEngine;
/// 开始录屏
- (void)startBroadcast;
- (void)sendVideoBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
- (void)sendAudioAppBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
- (void)sendAudioMicBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;

/// 停止录屏
- (void)stopBroadcast;

@end

