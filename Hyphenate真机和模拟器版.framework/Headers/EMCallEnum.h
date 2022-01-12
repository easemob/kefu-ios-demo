/*!
 *  \~chinese
 *  @header     EMCallEnum.h
 *  @abstract   枚举类型声明
 *  @author     Hyphenate
 *  @version    3.00
 *
 *  \~english
 *  @header     EMCallEnum.h
 *  @abstract   Enum
 *  @author     Hyphenate
 *  @version    3.00
 */

#ifndef EMCallEnum_h
#define EMCallEnum_h

/*!
 *  \~chinese
 *  会话状态
 *
 *  \~english
 *  Call session status
 */
typedef enum {
    EMCallSessionStatusDisconnected = 0,    /*! \~chinese 通话没开始 \~english Call disconnected */
    EMCallSessionStatusConnecting = 2,      /*! \~chinese 通话正在连接 \~english Waiting for answering */
    EMCallSessionStatusConnected,           /*! \~chinese 通话已经准备好，等待接听 \~english Connection is established */
    EMCallSessionStatusAccepted,            /*! \~chinese 通话双方同意协商 \~english Call accepted */
} EMCallSessionStatus;

typedef EMCallSessionStatus EMCallStatus;

/*!
 *  \~chinese
 *  通话类型
 *
 *  \~english
 *  Call type
 */
typedef enum {
    EMCallTypeVoice = 0,    /*! \~chinese 实时语音 \~english Voice call */
    EMCallTypeVideo,        /*! \~chinese 实时视频 \~english Video call */
} EMCallType;

/*!
 *  \~chinese
 *  通话结束原因
 *
 *  \~english
 *  Reasons of the ending call
 */
typedef enum {
    EMCallEndReasonHangup   = 0,    /*! \~chinese 对方挂断 \~english Another peer hang up */
    EMCallEndReasonNoResponse,      /*! \~chinese 对方没有响应 \~english No response */
    EMCallEndReasonDecline,         /*! \~chinese 对方拒接 \~english Another peer declined the call */
    EMCallEndReasonBusy,            /*! \~chinese 对方占线 \~english User is busy */
    EMCallEndReasonFailed,          /*! \~chinese 失败 \~english Establish the call failed */
    EMCallEndReasonUnsupported,     /*! \~chinese 功能不支持 \~english Unsupported */
    EMCallEndReasonRemoteOffline,   /*! \~chinese 对方不在线 \~english Remote offline */
    EMCallEndReasonLoginOtherDevice, 
    EMCallEndReasonDestroy,
    EMCallEndReasonBeenkicked,
    EMCallEndReasonNotEnable = 101,
    EMCallEndReasonServiceArrearages,
    EMCallEndReasonServiceForbidden
    
} EMCallEndReason;

typedef enum : NSUInteger {
    EMConferenceAttributeAdd = 0,
    EMConferenceAttributeUpdate,
    EMConferenceAttributeDelete
} EMConferenceAttributeAction;

/*!
 *  \~chinese
 *  通话连接方式
 *
 *  \~english
 *  Connection type of the call
 */
typedef enum {
    EMCallConnectTypeNone = 0,  /*! \~chinese 无连接 \~english No connection */
    EMCallConnectTypeDirect,    /*! \~chinese 直连 \~english Direct connect between devices */
    EMCallConnectTypeRelay,     /*! \~chinese 转媒体服务器连接 \~english Relay connection over server */
} EMCallConnectType;

/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Call status
 */
typedef enum {
    EMCallStreamStatusVoicePause = 0,  /*! \~chinese 中断语音 \~english Pause voice streaming */
    EMCallStreamStatusVoiceResume,     /*! \~chinese 继续语音 \~english Resume voice streaming */
    EMCallStreamStatusVideoPause,      /*! \~chinese 中断视频 \~english Pause video streaming */
    EMCallStreamStatusVideoResume,     /*! \~chinese 继续视频 \~english Resume video streaming */
} EMCallStreamingStatus;

/*!
 *  \~chinese
 *  通话网络状态
 *
 *  \~english
 *  Network status
 */
typedef enum {
    EMCallNetworkStatusNormal = 0,  /*! \~chinese 正常 \~english Normal */
    EMCallNetworkStatusUnstable,    /*! \~chinese 不稳定 \~english Unstable connection */
    EMCallNetworkStatusNoData,      /*! \~chinese 没有数据 \~english No data */
} EMCallNetworkStatus;

/*!
 *  \~chinese
 *  视频分辨率
 *
 *  \~english
 *  Video resolution
 */
typedef enum {
    EMCallVideoResolutionDefault = 0,  /*! \~chinese 自适应分辨率 \~english Adaptive resolution */
    EMCallVideoResolution352_288,       /*! \~chinese 352 * 288 \~english 352 * 288 */
    EMCallVideoResolution640_480,       /*! \~chinese 640 * 480 \~english 640 * 480 */
    EMCallVideoResolution1280_720,      /*! \~chinese 1280 * 720 \~english 1280 * 720 */
    EMCallVideoResolution_Custom,      /*! \~chinese 自定义分辨率\~english custom resolution */
    EMCallVideoResolutionAdaptive = EMCallVideoResolutionDefault,
} EMCallVideoResolution;

/*!
 *  \~chinese
 *  视频格式
 *
 *  \~english
 *  Video format
 */
typedef enum {
    EMCallVideoFormatNV12 = 0x3231564e,       /*! \~chinese nv12 \~english nv12 */
    EMCallVideoFormatBGRA = 0x41524742,       /*! \~chinese bgra \~english bgra */
    EMCallVideoFormatARGB = 0x42475241,       /*! \~chinese argb \~english argb */
} EMCallVideoFormat;


#pragma mark - EM_DEPRECATED_IOS
/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Stream control
 */
typedef enum {
    EMCallStreamControlTypeVoicePause __deprecated_msg("Use EMCallStreamStatusVoicePause") = 0,   /*! \~chinese 中断语音 \~english Pause Voice */
    EMCallStreamControlTypeVoiceResume __deprecated_msg("Use EMCallStreamStatusVoiceResume"),     /*! \~chinese 继续语音 \~english Resume Voice */
    EMCallStreamControlTypeVideoPause __deprecated_msg("Use EMCallStreamStatusVideoPause"),       /*! \~chinese 中断视频 \~english Pause Video */
    EMCallStreamControlTypeVideoResume __deprecated_msg("Use EMCallStreamStatusVideoResume"),     /*! \~chinese 继续视频 \~english Resume Video */
} EMCallStreamControlType __deprecated_msg("Use EMCallStreamingStatus");


#endif /* EMCallEnum_h */
