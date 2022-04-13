//
//  HDAgoraUploader.h
//  Demo
//
//  Created by houli on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
@interface HDAgoraUploader : NSObject
//单利引擎
+ (instancetype _Nullable )sharedAgoraEngine;
/// 开始录屏
- (void)startBroadcast;
/// 发送视频流
/// @param sampleBuffer CMSampleBufferRef
- (void)sendVideoBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
/// 发送音频流
/// @param sampleBuffer CMSampleBufferRef
- (void)sendAudioAppBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
/// 发送麦克风流
/// @param sampleBuffer CMSampleBufferRef
- (void)sendAudioMicBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
/// 停止录屏
- (void)stopBroadcast;

@end

