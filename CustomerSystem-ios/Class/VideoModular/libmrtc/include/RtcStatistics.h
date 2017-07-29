//
//  RtcStatistics.h
//  mrtc
//
//  Created by simon on 16/6/22.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RtcStatistics : NSObject
@property (copy) NSString *  connectionType;
@property (assign) NSInteger connectionRtt;
@property (assign) NSInteger localCaptureWidth;
@property (assign) NSInteger localCaptureHeight;
@property (assign) NSInteger localCaptureFps;
@property (assign) NSInteger localEncodedWidth;
@property (assign) NSInteger localEncodedHeight;
@property (assign) NSInteger localEncodedFps;
@property (assign) NSInteger localVideoActualBps;
@property (assign) NSInteger localVideoTargetBps;
@property (assign) NSInteger localVideoPackets;
@property (assign) NSInteger localVideoPacketsLost;
@property (assign) NSInteger localVideoPacketsLostRate;
@property (assign) NSInteger localVideoRtt;
@property (assign) NSInteger localVideoBytes;
@property (assign) NSInteger localAudioPackets;
@property (assign) NSInteger localAudioPacketsLost;
@property (assign) NSInteger localAudioPacketsLostRate;
@property (assign) NSInteger localAudioBps;
@property (assign) NSInteger localAudioRtt;
@property (assign) NSInteger localAudioBytes;
@property (assign) NSInteger remoteWidth;
@property (assign) NSInteger remoteHeight;
@property (assign) NSInteger remoteFps;
@property (assign) NSInteger remoteVideoPackets;
@property (assign) NSInteger remoteVideoPacketsLost;
@property (assign) NSInteger remoteVideoPacketsLostRate;
@property (assign) NSInteger remoteVideoBps;
@property (assign) NSInteger remoteVideoBytes;
@property (assign) NSInteger remoteAudioPackets;
@property (assign) NSInteger remoteAudioPacketsLost;
@property (assign) NSInteger remoteAudioPacketsLostRate;
@property (assign) NSInteger remoteAudioBps;
@property (assign) NSInteger remoteAudioBytes;

@property (copy) NSString * fullStatsString;

@end
