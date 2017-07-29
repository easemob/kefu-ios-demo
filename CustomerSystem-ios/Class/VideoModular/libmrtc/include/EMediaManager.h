

#import "EMediaEntities.h"

@class EMediaManager;



@interface EMediaManager : NSObject

+ (instancetype)shared;

-(void) setLogToFileEnabled:(BOOL)enabled path:(NSString *)path;

- (void) setLoggerDelegate:(id<EMediaLoggerDelegate>) aDelegate;


/**
 创建一个视频通话的session

 @param aTicket 会话标识
 @param extension 扩展
 @param aDelegate delegate
 @param aQueue 运行的线程
 @return 返回视频通话的session
 */
- (EMediaSession *) newSessionWithTicket:(NSString*) aTicket
                               extension:(NSString *) extension
                                delegate:(id<EMediaSessionDelegate>)aDelegate
                           delegateQueue:(dispatch_queue_t)aQueue;

/**
 设置本地预览窗口

 @param view 预览窗口
 */
- (void) setLocalPreviewView:(EMCallLocalView*)view;

//加入一个会话
- (void) join:(EMediaSession *) session publishConfig: (EMediaPublishConfiguration *)config onDone:(EMediaIdBlockType)block;


/**
 离开一个会话
 */
- (void) exit:(EMediaSession *) session onDone:(EMediaIdBlockType)block;

/**
 发布流
 */
- (void) publish:(EMediaSession *) session publishConfig:(EMediaPublishConfiguration *)config onDone:(EMediaIdBlockType)block;

/**
 停止发布流
 */
- (void) unpublish:(EMediaSession *) session onDone:(EMediaIdBlockType)block;


/**
 订阅视频
 */
- (void) subscribe:(EMediaSession *) session streamId:(NSString *) streamId view: (EMCallRemoteView *) view onDone:(EMediaIdBlockType)block;

/**
 取消订阅
 */
- (void) unsubscribe:(EMediaSession *) session streamId:(NSString *) streamId onDone: (EMediaIdBlockType) block;

/**
 切换前后摄像头
 */
- (void) switchCamera;

/**
 是否静音
 */
- (void) setMuteEnabled: (BOOL)enabled;

/**
 是否关闭摄像头
 */
- (void) setVideoEnabled: (BOOL)enabled;


- (void) switchTorchOn:(BOOL)on;

- (void) remoteCamera:(EMediaSession *) session
             streamId:(NSString*)streamId
                focus:(BOOL)focus
             exposure:(BOOL)exposure
              atPoint:(CGPoint) point
               onDone:(EMediaIdBlockType)block;

- (void) remoteCamera:(EMediaSession *) session
             streamId:(NSString*)streamId
             zoomWith:(CGFloat) zoomFactor
               onDone:(EMediaIdBlockType)block;

@end


