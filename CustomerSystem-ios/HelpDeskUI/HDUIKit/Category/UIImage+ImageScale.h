//
//  UIImage+ImageScale.h
//  WSUserSDK_Example
//
//  Created by houli on 2018/7/30.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageScale)
-(UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)scaleToWidth:(CGFloat)width;

/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param compressQuality 压缩系数 0-1
 *  默认参考大小30kb,一般用该方法可达到要求，压缩系数可根据压缩后的清晰度权衡，项目里我用的0.2�
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality;


/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;
/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;
/** 压缩图片 最大字节大小为maxLength */
- (NSData *)compressWithMaxLength:(NSInteger)maxLength;


@end
