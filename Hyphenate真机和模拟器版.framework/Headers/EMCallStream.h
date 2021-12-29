/*!
 *  \~chinese
 *  @header EMCallStream.h
 *  @abstract 数据流
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallStream.h
 *  @abstract Stream
 *  @author Hyphenate
 *  @version 3.00
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMCallEnum.h"
#import "EMCommonDefs.h"

/*!
 *  \~chinese
 *  数据流类型
 *
 *  \~english
 *  Stream type
 */
typedef enum {
    EMStreamTypeNormal = 0,    /*! \~chinese 默认，视频或者语音 \~english Default, video or audio */
    EMStreamTypeDesktop,        /*! \~chinese 分享桌面 \~english Share desktop */
} EMStreamType;

/*!
 *  \~chinese
 *  数据流
 *
 *  \~english
 *  Stream
 */
@interface EMCallStream : NSObject

/*!
 *  \~chinese
 *  数据流标识符
 *
 *  \~english
 *  Unique stream id
 */
@property (nonatomic, strong, readonly) NSString *streamId;

/*!
 *  \~chinese
 *  数据流名称
 *
 *  \~english
 *  Stream name
 */
@property (nonatomic, strong, readonly) NSString *streamName;

/*!
 *  \~chinese
 *  上传者的成员名称
 *
 *  \~english
 *  Member name of the publisher
 */
@property (nonatomic, strong, readonly) NSString *memberName;

/*!
 *  \~chinese
 *  上传者环信ID
 *
 *  \~english
 *  Hyphenate ID of the publisher
 */
@property (nonatomic, strong, readonly) NSString *userName;

/*!
 *  \~chinese
 *  音频是否可用
 *
 *  \~english
 *  Whether the audio is available
 */
@property (nonatomic, readonly) BOOL enableVoice;

/*!
 *  \~chinese
 *  视频是否可用
 *
 *  \~english
 *  Whether the video is available
 */
@property (nonatomic, readonly) BOOL enableVideo;

/*!
 *  \~chinese
 *  扩展信息
 *
 *  \~english
 *  Extended Information
 */
@property (nonatomic, strong, readonly) NSString *ext;

/*!
 *  \~chinese
 *  数据流类型
 *
 *  \~english
 *  Stream type
 */
@property (nonatomic) EMStreamType type;

@end


/*!
 *  \~chinese
 *  上传数据流时的属性对象
 *
 *  \~english
 *  The config object when the stream is published
 */
@class EMCallLocalVideoView;
@interface EMStreamParam : NSObject

/*!
 *  \~chinese
 *  数据流名称
 *
 *  \~english
 *  Stream name
 */
@property (nonatomic, copy) NSString *streamName;

/*!
 *  \~chinese
 *  数据流类型
 *
 *  \~english
 *  Stream type
 */
@property (nonatomic) EMStreamType type;

/*!
 *  \~chinese
 *  视频是否可用，默认NO
 *
 *  \~english
 *  Whether the video is available, the default NO
 */
@property (nonatomic) BOOL enableVideo;

/*!
 *  \~chinese
 *  是否静音，默认NO
 *
 *  \~english
 *  Whether the mute, the default NO
 */
@property (nonatomic) BOOL isMute;

/*!
 *  \~chinese
 *  扩展信息
 *
 *  \~english
 *  Extended Information
 */
@property (nonatomic, copy) NSString *ext;

/*!
 *  \~chinese
 *  是否自定义视频数据，默认NO
 *
 *  \~english
 *  Whether to customize the video data, the default NO
 */
@property (nonatomic) BOOL enableCustomizeVideoData;
/*!
 *  \~chinese
 *  是否自定义音频数据，默认NO
 *
 *  \~english
 *  Whether to customize the audio data, the default NO
 */
@property (nonatomic) BOOL enableCustomizeAudioData;

/*!
*  \~chinese
*  自定义音频数据的采样率
*
*  \~english
*  The samplerate of the custom audio data
*/
@property (nonatomic) int customAudioSamples;

/*!
*  \~chinese
*  自定义音频数据的通道数，当前只支持单通道,必须为1
*
*  \~english
*  The channels of the custom audio data
*/
@property (nonatomic) int customAudioChannels;

/*!
 *  \~chinese
 *  是否使用后置摄像头，默认NO
 *
 *  \~english
 *  Whether to use the back camera, the default NO
 *
 */
@property (nonatomic, assign) BOOL isBackCamera;

/*!
 *  \~chinese
 *  最大视频码率
 *  范围 50 < videoKbps < 5000, 默认0, 0为自适应
 *  建议设置为0
 *
 *  \~english
 *  Video kbps
 *  range: 50 < videoKbps < 5000. Default value is 0, which is adaptive bitrate streaming.
 *  recommend use default value
 */
@property (nonatomic, assign) int maxVideoKbps;

/*!
 *  \~chinese
 *  最小视频码率, 默认0
 *
 *  \~english
 *  Min video kbps. Default value is 0
 *
 */
@property (nonatomic, assign) int minVideoKbps;

/*!
 *  \~chinese
 *  最大音频码率
 *  范围 6 < AudioKbps < 510, 默认32
 *  建议设置为32
 *
 *  \~english
 *  Audio kbps
 *  range: 6 < AudioKbps < 510. Default value is 32
 *  recommend use default value
 */
@property (nonatomic, assign) int maxAudioKbps;

/*!
 *  \~chinese
 *  视频分辨率
 *  默认自适应
 *
 *  \~english
 *  Video resolution
 *  default adaptive
 */
@property (nonatomic, assign) EMCallVideoResolution videoResolution;

/*!
 *  \~chinese
 *  显示本地视频的页面
 *
 *  \~english
 *  The view of displays the local video
 */
@property (nonatomic, strong) EMCallLocalVideoView *localView;

/*!
 *  \~chinese
 *  分享桌面时要显示的页面
 *
 *  \~english
 *  The view to display when sharing the desktop
 */
@property (nonatomic, strong) UIView *desktopView;

/*!
 *  \~chinese
 *  自定义分辨率的视频宽
 *
 *  \~english
 *  The videoWith, valid if videoResolution == EMCallVideoResolution_Custom
 */
@property (nonatomic) int videoWidth;

/*!
 *  \~chinese
 *  自定义分辨率的视频
 *
 *  \~english
 *  The videoWith, valid if videoResolution == EMCallVideoResolution_Custom
 */
@property (nonatomic) int videoHeight;

/*!
 *  \~chinese
 *  初始化方法
 *
 *  @param aStreamName    数据流名称
 *
 *  @result 数据流实例
 *
 *  \~english
 *  Initialization method
 *
 *  @param aStreamName    Stream name
 *
 *  @result Stream instance
 */
- (instancetype)initWithStreamName:(NSString *)aStreamName;

#pragma mark - EM_DEPRECATED_IOS 3.5.2

/*!
 *  \~chinese
 *  是否固定视频分辨率，默认为NO
 *
 *  \~english
 *  Enable fixed video resolution, default NO
 *
 */
@property (nonatomic, assign) BOOL isFixedVideoResolution EM_DEPRECATED_IOS(3_4_3, 3_5_2, "Delete");

@end
