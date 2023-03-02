//
//  HDAgoraCallOptions.h
//  HelpDeskLite
//
//  Created by houli on 2022/1/6.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDVECAgoraCallOptions : NSObject

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
 视频比特率。
 */
@property (assign, nonatomic) NSInteger bitrate;

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


