
#import <Foundation/Foundation.h>
#import "EMCallLocalView.h"
#import "EMCallRemoteView.h"
#import "EMediaDefines.h"


@class EMediaSession;

@interface EMediaError : NSObject

@property (nonatomic, readonly) EMediaErrorCode code;

@property (nonatomic, readonly) NSString *errorDescription;

@end

@interface EMediaMember : NSObject
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) NSString * extension;
@end


@interface EMediaStream : NSObject
@property (nonatomic, readonly) NSString * streamId;
@property (nonatomic, readonly) NSString * streamName;
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) EMediaStreamType  streamType;
@property (nonatomic, readonly) BOOL videoOff;
@property (nonatomic, readonly) BOOL audioOff;
@property (nonatomic, readonly) NSString * extension;
@end

typedef void (^EMediaIdBlockType)(id obj, EMediaError * error);

@interface EMediaPublishConfiguration : NSObject
@property (nonatomic, assign) BOOL videoOff;
@property (nonatomic, assign) BOOL mute;
@property (nonatomic, copy) NSString * extension;
@end


@protocol EMediaSessionDelegate <NSObject>
@optional

/**
 成员进来
 */
- (void)onEMediaSession:(EMediaSession *) session joinMember:(EMediaMember *) member;

/**
 成员离开会话
 */
- (void)onEMediaSession:(EMediaSession *) session exitMember:(EMediaMember *) member;

/**
 有新视频流
 */
- (void)onEMediaSession:(EMediaSession *) session addStream:(EMediaStream *) stream;

/**
 视频流被移除[仅指其他人]
 */
- (void)onEMediaSession:(EMediaSession *) session removeStream:(EMediaStream *) stream;

/**
 视频流刷新
 */
- (void)onEMediaSession:(EMediaSession *) session updateStream:(EMediaStream *) stream;


/**
 自己的视频被动关闭
 1、网络原因
 2、被踢
 */
- (void)onEMediaSession:(EMediaSession *) session passiveCloseReason:(int) reason desc:(NSString*)desc;


/**
 发送网络状态等的。通知
 */
- (void)onEMediaSession:(EMediaSession *) session notice:(EMediaNoticeCode) code
                   arg1:(NSString *)arg1
                   arg2:(NSString*)arg2
                   arg3:(id)arg3;

//- (void)onEMediaSession:(EMediaSession *) session error:(EMediaError *) error;

@end


@interface EMediaSession : NSObject

@property (readonly) NSString * instanceId;

@property (readonly) NSString * myName;

//@property (readonly) EMediaSessionConfiguration * config;

@property (readonly) NSString * extension;

@end


@protocol EMediaLoggerDelegate <NSObject>
@required
- (void)onLogMessage:(NSString *) msg;
@end
