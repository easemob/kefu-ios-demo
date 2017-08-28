

/*!
 *  \~chinese
 *  @header EMCallLocalView.h
 *  @abstract 视频通话本地图像显示页面
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallLocalView.h
 *  @abstract Video call local view
 *  @author Hyphenate
 *  @version 3.00
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef EM_SCALEASPECT_DEFINE
#define EM_SCALEASPECT_DEFINE
typedef enum{
    EMCallViewScaleModeAspectFit = 0,
    EMCallViewScaleModeAspectFill = 1
}EMCallViewScaleMode;
#endif

@interface EMCallLocalView : UIView

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
@property (atomic, assign) EMCallViewScaleMode scaleMode;
@property (atomic, assign) BOOL previewDirectly;
@property (atomic, assign) BOOL autoGesture;

@end

