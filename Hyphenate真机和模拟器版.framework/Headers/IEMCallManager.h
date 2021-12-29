/*!
 *  \~chinese
 *  @header IEMCallManager.h
 *  @abstract 此协议定义了实时音频/视频通话相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMCallManager.h
 *  @abstract This protocol defined the operations of real time voice/video call
 *  @author Hyphenate
 *  @version 3.00
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "EMCallOptions.h"
#import "EMCallManagerDelegate.h"
#import "EMCallBuilderDelegate.h"
#import "EMWaterMarkOption.h"

@class EMError;
@class EMCallStream;

/*!
 *  \~chinese 
 *  实时音频/视频通话相关操作
 *
 *  \~english
 *  The operations of real time voice/video call
 */
@protocol IEMCallManager <NSObject>

@optional

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<EMCallManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMCallManagerDelegate>)aDelegate;

/*!
 *  \~chinese
 *  添加回调代理，该代理只能设置一个
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)setBuilderDelegate:(id<EMCallBuilderDelegate>)aDelegate;

#pragma mark - Options

/*!
 *  \~chinese
 *  设置设置项
 *
 *  @param aOptions  设置项
 *
 *  \~english
 *  Set setting options
 *
 *  @param aOptions  Setting options
 */
- (void)setCallOptions:(EMCallOptions *)aOptions;

/*!
 *  \~chinese
 *  获取设置项
 *
 *  @result 设置项
 *
 *  \~english
 *  Get setting options
 *
 *  @result Setting options
 */
- (EMCallOptions *)getCallOptions;

#pragma mark - Make and Answer and End

/*!
 *  \~chinese
 *  发起实时会话
 *
 *  @param aType            通话类型
 *  @param aRemoteName      被呼叫的用户（不能与自己通话）
 *  @param aExt             通话扩展信息，会传给被呼叫方
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a call
 *
 *  @param aType            Call type
 *  @param aRemoteName      The callee
 *  @param aExt             Call extention, to the callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startCall:(EMCallType)aType
       remoteName:(NSString *)aRemoteName
              ext:(NSString *)aExt
       completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发起实时会话
 *
 *  @param aType            通话类型
 *  @param aRemoteName      被呼叫的用户（不能与自己通话）
 *  @param isRecord             是否开启服务端录制
 *  @param isMerge              录制时是否合并数据流
 *  @param aExt             通话扩展信息，会传给被呼叫方
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a call
 *
 *  @param aType            Call type
 *  @param aRemoteName      The callee
 *  @param isRecord             Whether to record using a server
 *  @param isMerge              Whether to merge data streams while recording
 *  @param aExt             Call extention, to the callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startCall:(EMCallType)aType
       remoteName:(NSString *)aRemoteName
           record:(BOOL)isRecord
      mergeStream:(BOOL)isMerge
              ext:(NSString *)aExt
       completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  接收方同意通话请求
 *
 *  @param  aCallId     通话ID
 *
 *  @result 错误信息
 *
 *  \~english
 *  Receiver answer the call
 *
 *  @param  aCallId     Call Id
 *  @param  aRemoteName Remote name
 *
 *  @result Error
 */
- (EMError *)answerIncomingCall:(NSString *)aCallId;

/*!
 *  \~chinese
 *  结束通话
 *
 *  @param aCallId     通话的ID
 *  @param aReason     结束原因
 *
 *  @result 错误
 *
 *  \~english
 *  End the call
 *
 *  @param aCallId     Call ID
 *  @param aReason     End reason
 *
 *  @result Error
 */
- (EMError *)endCall:(NSString *)aCallId
              reason:(EMCallEndReason)aReason;

/*!
 *  \~chinese
 *  强制结束所有通话
 *  使用场景：做了某些错误操作造成Call UI已经消失但是没有释放掉EMCallManager中维护的EMCallSession,造成再次调用方法[IEMCallManager startCall:remoteName:ext:completion:]返回错误EMErrorCallBusy，如果这时无法调用方法[IEMCallManager endCall:reason:]，可以调用该方法
 *
 *  \~english
 *  Forcibly end all calls
 *  Usage Scenario: An error occurred that caused the Call UI to disappear but did not release the EMCallSession maintained in the EMCallManager, causing the call to the method [IEMCallManager startCall:remoteName:ext:completion:] to return the error EMErrorCallBusy. If this time can not call the method [IEMCallManager endCall:reason:], you can call this method
 */
- (void)forceEndAllCall;

#pragma mark - Input Video Data

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aSampleBuffer      视频采样缓冲区
 *  @param aRotation          旋转方向
 *  @param aCallId            1v1会话实例ID，即[EMCallSession callId]
 *  @param aCompletionBlock   完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aSampleBuffer      Video sample buffer
 *  @param aRotation          UIDeviceOrientation
 *  @param aCallId            [EMCallSession callId]
 *  @param aCompletionBlock   The callback block of completion
 */
- (void)inputVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                      rotation:(UIDeviceOrientation)aRotation
                        callId:(NSString *)aCallId
                    completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aPixelBuffer      视频像素缓冲区
 *  @param aCallId           1v1会话实例ID，即[EMCallSession callId]
 *  @param aTime             视频原始数据时间戳，CMTime time = CMSampleBufferGetPresentationTimeStamp((CMSampleBufferRef)sampleBuffer);
 *  @param aRotation         旋转方向
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aPixelBuffer      Video pixel buffer
 *  @param aTime             CMTime time = CMSampleBufferGetPresentationTimeStamp((CMSampleBufferRef)sampleBuffer);
 *  @param aRotation         UIDeviceOrientation
 *  @param aCallId           [EMCallSession callId]
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoPixelBuffer:(CVPixelBufferRef)aPixelBuffer
             sampleBufferTime:(CMTime)aTime
                     rotation:(UIDeviceOrientation)aRotation
                       callId:(NSString *)aCallId
                   completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - 截图

//截取本地视频图片
- (void)takeLocalVideoPictureWithCallId:(NSString *)aCallId
                             saveToPath:(NSString *)aSavePath
                             completion:(void (^)(NSString *aFilePath, NSError *aError))aCompletion;
//截取对方视频图片
- (void)takeRemoteVideoPictureWithCallId:(NSString *)aCallId
                              saveToPath:(NSString *)aSavePath
                            completion:(void (^)(NSString *aFilePath, NSError *aError))aCompletion;

#pragma mark -  自定义音频数据

/*!
*  \~chinese
*  自定义外部音频数据，PCM格式,一个音频采样16bit，每次最大100ms数据
*
*  @param data              外部音频数据
*
*  @return int 返回值，0为写入成功，其他失败，-1为enable未启动，-2为channels错误，必须为1，-3为缓冲已满
*
*  \~english
*  Customize external audio data,PCM format,each audio sample contail 16 bits，the maxinum data durateion is 100ms
*
*  @param data      Custom audio data,format with PCM
*
*  @return int Return 0 when input data is successed.If enabled is false ,return -1.If channels is not equal to 1,return -2.If buffer is full,return -3.
*/
- (int) inputCustomAudioData:(NSData*)data;
#pragma mark - Watermark
/*!
*  \~chinese
*  开启水印功能
*
*  @param option 水印配置项，包括图片URL，marginX,marginY以及起始点
*
*  \~english
*  Enable water mark feature
*
*  @param origin the option of watermark picture,include url,margingX,marginY,margin point
 */
- (void)addVideoWatermark:(EMWaterMarkOption*)option;
/*!
*  \~chinese
*  取消水印功能
*
*  \~english
*  Disable water mark feature
*
 */
- (void)clearVideoWatermark;
#pragma mark - EM_DEPRECATED_IOS 3.5.2

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aSampleBuffer     视频采样缓冲区
 *  @param aCallId           1v1会话实例ID，即[EMCallSession callId]
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aSampleBuffer     Video sample buffer
 *  @param aCallId           [EMCallSession callId]
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                        callId:(NSString *)aCallId
                        format:(EMCallVideoFormat)aFormat
                      rotation:(int)aRotation
                    completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete, Use -inputVideoSampleBuffer:rotation:callId:completion:");

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aPixelBuffer      视频像素缓冲区
 *  @param aCallId           1v1会话实例ID，即[EMCallSession callId]
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aPixelBuffer      Video pixel buffer
 *  @param aCallId           [EMCallSession callId]
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoPixelBuffer:(CVPixelBufferRef)aPixelBuffer
                       callId:(NSString *)aCallId
                       format:(EMCallVideoFormat)aFormat
                     rotation:(int)aRotation
                   completion:(void (^)(EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete, Use -inputVideoPixelBuffer:sampleBufferTime:rotation:callId:completion:");

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aData             视频数据
 *  @param aCallId           1v1会话实例ID，即[EMCallSession callId]
 *  @param aWidth            宽度
 *  @param aHeight           高度
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aData             Video data
 *  @param aCallId           [EMCallSession callId]
 *  @param aWidth            Width
 *  @param aHeight           Height
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoData:(NSData *)aData
                callId:(NSString *)aCallId
         widthInPixels:(size_t)aWidth
        heightInPixels:(size_t)aHeight
                format:(EMCallVideoFormat)aFormat
              rotation:(int)aRotation
            completion:(void (^)(EMError *aError))aCompletionBlock  EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete");


#pragma mark - EM_DEPRECATED_IOS 3.2.1

/*!
 *  \~chinese
 *  发起语音会话
 *
 *  @param aUsername        被呼叫的用户（不能与自己通话）
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a voice call
 *
 *  @param aUsername        The callee
 *  @param aCompletionBlock The callback of completion
 *
 */
- (void)startVoiceCall:(NSString *)aUsername
            completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_2_0, "Use -[IEMCallManager startCall:remoteName:ext:completion:]");

/*!
 *  \~chinese
 *  发起视频会话
 *
 *  @param aUsername        被呼叫的用户（不能与自己通话）
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Start a video call
 *
 *  @param aUsername        The callee
 *  @param aSuccessBlock    The callback block of completion
 *
 */
- (void)startVideoCall:(NSString *)aUsername
            completion:(void (^)(EMCallSession *aCallSession, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_2_0, "Use -[IEMCallManager startCall:remoteName:ext:completion:]");

@end
