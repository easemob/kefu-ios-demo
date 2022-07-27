//
//  HDAgoraCallOptions.h
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDAgoraCallEnum.h"
//typedef NS_ENUM(NSUInteger, HDAgoraVideoDimensionType) {
//    HDAgoraVideoDimension160x120,
//    HDAgoraVideoDimension320x240,
//    HDAgoraVideoDimension640x360,
//    HDAgoraVideoDimension640x480,
//    HDAgoraVideoDimension960x720
//
//};
//typedef NS_ENUM(NSUInteger, HDAgoraVideoFrameRateFpsType) {
//    HDAgoraVideoFrameRateFps1,
//    HDAgoraVideoFrameRateFps7,
//    HDAgoraVideoFrameRateFps10,
//    HDAgoraVideoFrameRateFps15,
//    HDAgoraVideoFrameRateFps24,
//    HDAgoraVideoFrameRateFps30
//};
//
//typedef NS_ENUM(NSUInteger, HDAgoraVideoBitrateType) {
//    HDAgoraVideoBitrateStandard,
//    HDAgoraVideoBitrateCompatible,
//    HDAgoraVideoBitrateDefaultMin
//};
//typedef NS_ENUM(NSUInteger, HDAgoraVideoOutputOrientationModeType) {
//    HDAgoraVideoOutputOrientationMode,
//    HDAgoraVideoOutputOrientationModeAdaptative,
//    HDAgoraVideoOutputOrientationModeFixedLandscape,
//    HDAgoraVideoOutputOrientationModeFixedPortrait
//};

@interface HDAgoraCallOptions : NSObject

/**
   屏幕分享使用的uid  如果不设置 默认是 501-1000的随机数
 */
@property (nonatomic, assign) NSUInteger shareUid;
/**
 是否关闭摄像头
 */
@property (nonatomic, assign) BOOL videoOff;

/**
 是否静音
 */
@property (nonatomic, assign) BOOL mute;

/**
  本地视频
 */
@property (nonatomic, strong) UIView * localView;
/**
 远程视频
 */
@property (nonatomic, strong) UIView * remoteView;

/**
  设置视频尺寸 
 */
@property (nonatomic, assign) CGSize dimension;
/**
 设置帧速率
 */
@property (nonatomic, assign) HDAgoraVideoFrameRate frameRate;

/**
 视频比特率。
 */
@property (assign, nonatomic) NSInteger bitrate;

/**
 */
@property (assign, nonatomic) HDAgoraVideoOutputOrientationMode orientationMode;


/**
 默认使用后置摄像头
 */
@property (nonatomic, assign) BOOL useBackCamera;
/**
 设置视频宽
 */
@property (nonatomic, assign) int videoWidth;
/**
 设置视频高
 */
@property (nonatomic, assign) int videoHeight;

/*!
 *  \~chinese
 *  配置项扩展
 *
 *  \~english
 *  Options extension
 *
 */
@property (nonatomic, strong) NSDictionary *extension;
@end


