//
//  EMRTCStatsReport.h
//  RtcSDK
//
//  Created by XieYajie on 2018/10/24.
//  Copyright © 2018 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMRTCStatsReport : NSObject

@property (nonatomic, copy) NSString *connectionType;

@property (nonatomic, assign) NSInteger connectionRtt;
@property (nonatomic, assign) NSInteger localCaptureWidth;
@property (nonatomic, assign) NSInteger localCaptureHeight;
@property (nonatomic, assign) NSInteger localCaptureFps;
@property (nonatomic, assign) NSInteger localEncodedWidth;
@property (nonatomic, assign) NSInteger localEncodedHeight;
@property (nonatomic, assign) NSInteger localEncodedFps;
@property (nonatomic, assign) NSInteger localVideoActualBps;
@property (nonatomic, assign) NSInteger localVideoTargetBps;
@property (nonatomic, assign) NSInteger localVideoPackets;
@property (nonatomic, assign) NSInteger localVideoPacketsLost;
@property (nonatomic, assign) NSInteger localVideoPacketsLostRate;
@property (nonatomic, assign) NSInteger localVideoRtt;
@property (nonatomic, assign) NSInteger localVideoBytes;
@property (nonatomic, assign) NSInteger localAudioPackets;
@property (nonatomic, assign) NSInteger localAudioPacketsLost;
@property (nonatomic, assign) NSInteger localAudioPacketsLostRate;
@property (nonatomic, assign) NSInteger localAudioBps;
@property (nonatomic, assign) NSInteger localAudioRtt;
@property (nonatomic, assign) NSInteger localAudioBytes;
@property (nonatomic, assign) NSInteger remoteWidth;
@property (nonatomic, assign) NSInteger remoteHeight;
@property (nonatomic, assign) NSInteger remoteFps;
@property (nonatomic, assign) NSInteger remoteVideoPackets;
@property (nonatomic, assign) NSInteger remoteVideoPacketsLost;
@property (nonatomic, assign) NSInteger remoteVideoPacketsLostRate;
@property (nonatomic, assign) NSInteger remoteVideoBps;
@property (nonatomic, assign) NSInteger remoteVideoBytes;
@property (nonatomic, assign) NSInteger remoteAudioPackets;
@property (nonatomic, assign) NSInteger remoteAudioPacketsLost;
@property (nonatomic, assign) NSInteger remoteAudioPacketsLostRate;
@property (nonatomic, assign) NSInteger remoteAudioBps;
@property (nonatomic, assign) NSInteger remoteAudioBytes;

@property (nonatomic, strong) NSString *audioSendCodec;
@property (nonatomic, strong) NSString *audioRecvCodec;
@property (nonatomic, strong) NSString *videoSendCodec;
@property (nonatomic, strong) NSString *videoRecvCodec;


/** String that represents the accumulated stats reports passed into this
 *  class.
 */
@property(nonatomic, copy) NSString *fullStatsString;

@end

NS_ASSUME_NONNULL_END
