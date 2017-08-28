//
//  HCallEnum.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#ifndef HCallEnum_h
#define HCallEnum_h

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


#endif /* HCallEnum_h */
