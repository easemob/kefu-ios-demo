//
//  HCallEnum.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#ifndef HCallEnum_h
#define HCallEnum_h


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



typedef enum{
    HMediaNoticeNone = 0,
    HMediaNoticeStats = 100,
    HMediaNoticeDisconn = 120,
    HMediaNoticeReconn = 121,
    HMediaNoticePoorQuality = 122,
    HMediaNoticePublishSetup = 123,
    HMediaNoticeSubscriptionSetup = 124,
    HMediaNoticeTakePicture = 125,
    HMediaNoticeCustomMsg = 126,
    HMediaNoticeOpenCameraFail = 201,
    HMediaNoticeOpenMicFail = 202,
}HMediaNoticeCode;



#endif /* HCallEnum_h */
