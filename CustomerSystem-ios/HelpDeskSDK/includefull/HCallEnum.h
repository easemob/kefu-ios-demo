//
//  HCallEnum.h
//  helpdesk_sdk
//
//  Created by __阿彤木_ on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#ifndef HCallEnum_h
#define HCallEnum_h

/*!
 *  \~chinese
 *  会话状态
 *
 *  \~english
 *  Call session status
 */
typedef enum{
    HCallSessionStatusDisconnected = 0,    /*! \~chinese 通话没开始 \~english Disconnected */
    HCallSessionStatusConnecting,          /*! \~chinese 通话正在连接 \~english It's ready, wait to answer */
    HCallSessionStatusConnected,           /*! \~chinese 通话已经准备好，等待接听 \~english Connection is established */
    HCallSessionStatusAccepted,            /*! \~chinese 通话双方同意协商 \~english Accepted */
}HCallSessionStatus;

typedef HCallSessionStatus HCallStatus;

/*!
 *  \~chinese
 *  通话类型
 *
 *  \~english
 *  Call type
 */
typedef enum{
    HCallTypeVoice = 0,    /*! \~chinese 实时语音 \~english Voice call */
    HCallTypeVideo,        /*! \~chinese 实时视频 \~english Video call */
}HCallType;

/*!
 *  \~chinese
 *  通话结束原因
 *
 *  \~english
 *  Call end reason
 */
typedef enum{
    HCallEndReasonHangup   = 0,    /*! \~chinese 对方挂断 \~english Another peer hang up */
    HCallEndReasonNoResponse,      /*! \~chinese 对方没有响应 \~english No response */
    HCallEndReasonDecline,         /*! \~chinese 对方拒接 \~english Another peer declined the call */
    HCallEndReasonBusy,            /*! \~chinese 对方占线 \~english User is busy */
    HCallEndReasonFailed,          /*! \~chinese 失败 \~english Establish the call failed */
    HCallEndReasonUnsupported,     /*! \~chinese 功能不支持 \~english Unsupported */
    HCallEndReasonRemoteOffline,   /*! \~chinese 对方不在线 \~english Remote offline */
}HCallEndReason;

/*!
 *  \~chinese
 *  通话连接方式
 *
 *  \~english
 *  Connection type of the call
 */
typedef enum{
    HCallConnectTypeNone = 0,  /*! \~chinese 无连接 \~english None */
    HCallConnectTypeDirect,    /*! \~chinese 直连 \~english  Direct connect */
    HCallConnectTypeRelay,     /*! \~chinese 转媒体服务器连接 \~english Relay connect */
}HCallConnectType;


/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Call status
 */
typedef enum{
    HCallStreamStatusVoicePause = 0,  /*! \~chinese 中断语音 \~english Pause voice streaming */
    HCallStreamStatusVoiceResume,     /*! \~chinese 继续语音 \~english Resume voice streaming */
    HCallStreamStatusVideoPause,      /*! \~chinese 中断视频 \~english Pause video streaming */
    HCallStreamStatusVideoResume,     /*! \~chinese 继续视频 \~english Resume video streaming */
}HCallStreamingStatus;

/*!
 *  \~chinese
 *  通话网络状态
 *
 *  \~english
 *  Network status
 */
typedef enum{
    HCallNetworkStatusNormal = 0,  /*! \~chinese 正常 \~english Normal */
    HCallNetworkStatusUnstable,    /*! \~chinese 不稳定 \~english Unstable */
    HCallNetworkStatusNoData,      /*! \~chinese 没有数据 \~english No data */
}HCallNetworkStatus;

#ifndef H_SCALEASPECT_DEFINE
#define H_SCALEASPECT_DEFINE
/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
typedef enum{
    HCallViewScaleModeAspectFit = 0,   /*! \~chinese 按比例缩放 \~english Aspect fit */
    HCallViewScaleModeAspectFill = 1,  /*! \~chinese 全屏 \~english Aspect fill */
}HCallViewScaleMode;
#endif

/*!
 *  \~chinese
 *  视频分辨率
 *
 *  \~english
 *  Video resolution
 */
typedef enum{
    HCallVideoResolutionAdaptive = 0,   /*! \~chinese 自适应分辨率 \~english Adaptive resolution */
    HCallVideoResolution352_288,       /*! \~chinese 352 * 288 \~english 352 * 288 */
    HCallVideoResolution640_480,       /*! \~chinese 640 * 480 \~english 640 * 480 */
    HCallVideoResolution1280_720,      /*! \~chinese 1280 * 720 \~english 1280 * 720 */
}HCallVideoResolution;

#endif /* HCallEnum_h */
