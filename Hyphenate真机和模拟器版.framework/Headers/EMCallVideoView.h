//
//  EMCallVideoView.h
//  RtcSDK
//
//  Created by XieYajie on 2018/10/29.
//  Copyright © 2018 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
typedef enum {
    EMCallViewScaleModeAspectFit = 0,   /*! \~chinese 按比例缩放 \~english Aspect fit */
    EMCallViewScaleModeAspectFill = 1,  /*! \~chinese 全屏 \~english Aspect fill */
} EMCallViewScaleMode;


@interface EMCallLocalVideoView : UIView

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
@property (nonatomic, assign) EMCallViewScaleMode scaleMode;

@end


@interface EMCallRemoteVideoView : UIView

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
@property (nonatomic, assign) EMCallViewScaleMode scaleMode;

@end


@interface EMCallLocalView : EMCallLocalVideoView
@end


@interface EMCallRemoteView : EMCallRemoteVideoView
@end

NS_ASSUME_NONNULL_END
