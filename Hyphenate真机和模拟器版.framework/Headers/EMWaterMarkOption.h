//
//  EMWaterMarkOption.h
//  RtcSDK
//
//  Created by lixiaoming on 2020/1/13.
//  Copyright © 2020 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, EMWaterMarkStart) {
    LEFTTOP = 0,
    RIGHTTOP,
    LEFTBOTTOM,
    RIGHTBOTTOM,
};
@interface EMWaterMarkOption : NSObject
/*!
*  \~chinese
*  是否启用水印设置，默认为YES
*  \~english
*  Whether using watermark, default is YES
*/
@property (nonatomic) bool enable;
/*!
*  \~chinese
*  水印图片的url，可以是本地文件和远程文件url
*  \~english
*  The url of watermark picture,it can be local file or remote file url
*/
@property (nonatomic) NSURL* url;
/*!
*  \~chinese
*  水印图片距离margin起点的横轴距离
*  \~english
*  The margin X to start position of watermark
*/
@property (nonatomic) int marginX;
/*!
*  \~chinese
*  水印图片距离margin起点的纵轴距离
*  \~english
*  The margin Y to start position of watermark
*/
@property (nonatomic) int marginY;
/*!
*  \~chinese
*  水印图片的margin起点的位置，枚举值，取值包括 LEFTTOP｜RIGHTTOP｜LEFTBOTTOM|RIGHTBOTTOM
*  \~english
*  The margin position of watermark picture. Enum value.LEFTTOP｜RIGHTTOP｜LEFTBOTTOM|RIGHTBOTTOM
*/
@property (nonatomic) EMWaterMarkStart startPoint;

@end

NS_ASSUME_NONNULL_END
