/*!
 *  \~chinese
 *  @header EMCallOptions.h
 *  @abstract EMCallManager配置类
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallOptions.h
 *  @abstract EMCallManager setting options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallEnum.h"
#import "EMCommonDefs.h"

@interface EMCallOptions : NSObject

/*!
 *  \~chinese
 *  发送ping包的时间间隔，单位秒，默认30s，最小10s
 *
 *  \~english
 *  Send ping packet interval, unit second, the default 30s, the minimum 10s
 *
 */
@property (nonatomic) int pingInterval;

/*!
 *  \~chinese
 *  被叫方不在线时，是否推送来电通知
 *  如果设置为NO，不推送通知，返回EMErrorCallRemoteOffline
 *  默认NO
 *
 *  \~english
 *  When remote is not online, whether to send offline push
 *  default NO
 */
@property (nonatomic, assign) BOOL isSendPushIfOffline;

/*!
 *  \~chinese
 *  当isSendPushIfOffline=YES时起作用,离线推送显示的内容
 *  默认 “You have incoming call...”
 *
 *  \~english
 *  Only effective when isSendPushIfOffline is YES.
 *  default “You have incoming call...”
 */
@property (nonatomic, strong) NSString *offlineMessageText;

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
 *  最大视频码率
 *  范围 50 < videoKbps < 5000, 默认0, 0为自适应
 *  建议设置为0
 *
 *  \~english
 *  Video kbps
 *  range: 50 < videoKbps < 5000. Default value is 0, which is adaptive bitrate streaming.
 *  recommend use default value
 */
@property (nonatomic, assign) long maxVideoKbps;

/*!
 *  \~chinese
 *  最小视频码率
 *
 *  \~english
 *  Min video kbps
 *
 */
@property (nonatomic, assign) int minVideoKbps;

/*!
 *  \~chinese
 *  最大视频帧率
 *
 *  \~english
 *  Max video frame rate
 *
 */
@property (nonatomic, assign) int maxVideoFrameRate;

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
@property (nonatomic, assign) long maxAudioKbps;

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
 *  是否监听通话质量
 *
 *  \~english
 *  Whether to monitor call quality
 */
@property (nonatomic) BOOL enableReportQuality;

/*!
*  \~chinese
*  是否自定义音频数据，默认NO
*
*  \~english
*  Whether to customize the audio data, the default NO
*/
@property (nonatomic) BOOL enableCustomAudioData;

/*!
*  \~chinese
*  自定义音频数据的采样率，默认48000
*
*  \~english
*  The samples of custom audio data
*/
@property (nonatomic) int audioCustomSamples;

/*!
*  \~chinese
*  自定义音频数据的通道数，当前只支持单通道，必须为1
*
*  \~english
*  The channels of custom audio data
*/
@property (nonatomic) int audioCustomChannels;

/*!
*  \~chinese
* 视频传输场景，是否清晰度优先
*
*  \~english
*  Weather the image clear is first
*/
@property (nonatomic) BOOL isClarityFirst;

#pragma mark - EM_DEPRECATED_IOS 3.5.2

/*!
 *  \~chinese
 *  是否固定视频分辨率，默认为NO
 *
 *  \~english
 *  Enable fixed video resolution, default NO
 *
 */
@property (nonatomic, assign) BOOL isFixedVideoResolution EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Delete");

#pragma mark - EM_DEPRECATED_IOS 3.2.2

/*
*  \~chinese
*  视频码率
*  范围 50 < videoKbps < 5000, 默认0, 0为自适应
*  建议设置为0
*
*  \~english
*  Video kbps
*  range: 50 < videoKbps < 5000. Default value is 0, which is adaptive bitrate streaming.
*  recommend use default value
*/
@property (nonatomic, assign) long videoKbps EM_DEPRECATED_IOS(3_2_2, 3_5_2, "Use -[EMCallOptions maxVideoKbps]");

@end
