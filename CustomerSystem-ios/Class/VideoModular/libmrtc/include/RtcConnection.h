
#import <AVFoundation/AVCaptureSession.h>
#import "EMCallLocalView.h"
#import "EMCallRemoteView.h"
#import "RtcStatistics.h"

@class RtcConnection;
@protocol RtcConnectionDelegate <NSObject>

//- (void)rtcConnection:(RtcConnection *)conn
//   didGetLocalSdp:(RTCSessionDescription *) sdp;
//
//- (void)rtcConnection:(RtcConnection *)conn
//       didGetLocalCandidate:(RTCICECandidate *) candidate;

- (void)rtcConnection:(RtcConnection *)conn
       didGetLocalSdp:(NSString *) sdp;

- (void)rtcConnection:(RtcConnection *)conn
    didGetLocalCandidate:(NSString *) candidate;

@optional
- (void)rtcConnection:(RtcConnection *)conn
    didLocalCandidateComplete:(NSString *)reason;

- (void)rtcConnection:(RtcConnection *)conn
             didError:(NSError *)error;

- (void)rtcConnection:(RtcConnection *)conn
      didGetStats:(RtcStatistics *)stats;

- (void)rtcConnection:(RtcConnection *)conn
      didSetup:(NSString *)reason;

- (void)rtcConnection:(RtcConnection *)conn
      didClose:(NSString *)reason;

- (void)rtcConnection:(RtcConnection *)conn
             didReconnect:(NSString *)reason;

- (void)rtcConnection:(RtcConnection *)conn
         didDisconnect:(NSString *)reason;

@end


extern NSString * const kRtcKV_CaptureVideo_Boolean ;
extern NSString * const kRtcKV_RecvVideo_Boolean ;
extern NSString * const kRtcKV_CaptureAudio_Boolean ;
extern NSString * const kRtcKV_RecvAudio_Boolean ;
extern NSString * const kRtcKV_RelayOnly_Boolean ;

extern NSString * const kRtcvKV_VideoFps_Long ;
extern NSString * const kRtcvKV_VideoWidth_Long ;
extern NSString * const kRtcvKV_VideoHeight_Long ;

//extern NSString * const kRtcKV_HostCandidate_Boolean ;
//extern NSString * const kRtcKV_SrflxCandidate_Boolean ;
//extern NSString * const kRtcKV_PrflxCandidate_Boolean ;
//extern NSString * const kRtcKV_RelayCandidate_Boolean ;

extern NSString * const kRtcKV_VideoResolutionLevel_Long ;
extern NSString * const kRtcKV_MaxVideoKbps_Long ;
//extern NSString * const kRtcKV_RelayVideoKbps_Long ;
extern NSString * const kRtcKV_MaxAudioKbps_Long ;
//extern NSString * const kRtcKV_RelayAudioKbps_Long ;
extern NSString * const kRtcKV_PreferVCodec_String ;
extern NSString * const kRtcKV_PreferACodec_String ;
extern NSString * const kRtcKV_IceServers_Array;
extern NSString * const kRtcKV_DisablePranswer_Boolean;

extern NSString * const kRtcConstStringVP8 ;
extern NSString * const kRtcConstStringVP9 ;
extern NSString * const kRtcConstStringH264 ;
extern NSString * const kRtcConstStringOPUS ;
extern NSString * const kRtcConstStringG722 ;

@interface RtcConnection : NSObject {
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSString * connId;
@property(nonatomic, weak) id<RtcConnectionDelegate> delegate;
@property(nonatomic, strong) EMCallLocalView * localVideoView;
@property(nonatomic, strong) EMCallRemoteView * remoteVideoView;

+ (void)initGlobal;
+ (void)deinitGlobal;
+ (void)setDefaultCameraPosition:(AVCaptureDevicePosition) position;

+ (void)enableFixedVideoResolution:(BOOL)enabled;
+ (void)setMaxVideoFrameRate:(int)fps;
+ (void)setMinVideoKbps:(int)kbps;


//- (id)init;
- (instancetype)initWithDelegate:(id<RtcConnectionDelegate>)delegate name: (NSString *) name;
- (void) setConfigureJson: (NSString *) json;
- (void) setConfigure:(NSDictionary *) dict;
- (void) createOffer;
- (void) createAnswer;
- (void) hangup;


//- (void) setRemoteSdp: (RTCSessionDescription *)sdp;
//- (void) setRemoteCandidate: (RTCICECandidate *)candidate;
- (NSString *) setRemoteJson: (id)json ;
- (void) setMuteEnabled: (BOOL)enabled;
- (void) setStatsEnable: (BOOL)enabled;
- (void) switchCamera;
- (void) clearIceServers;
- (void) addIceServerUri: (NSURL*)URI
                username:(NSString*)username
                password:(NSString*)password;
- (void) startCapture;
- (void) stopCapture;
- (NSString *) getReportString;

- (void) switchTorchOn:(BOOL)on;
- (void) zoomWithFactor:(CGFloat)factor;
- (void) interestAt:(CGPoint)pointOfInterest focus:(BOOL)focus exposure:(BOOL)exposure fromRemote:(BOOL)fromRemote;

@end

