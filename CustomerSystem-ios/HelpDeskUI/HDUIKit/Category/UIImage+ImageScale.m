//
//  UIImage+ImageScale.m
//  WSUserSDK_Example
//
//  Created by houli on 2018/7/30.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "UIImage+ImageScale.h"

@implementation UIImage (ImageScale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
    //为保证图片清晰度 使用以下方法创建 切记
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark -按照你想要的比例去缩放图片
- (UIImage *)scaleToWidth:(CGFloat)width{
    
    // 如果传入的宽度比当前宽度还要大,就直接返回
    
    if (width > self.size.width) {
        return  self;
    }
    
    // 计算缩放之后的高度
    CGFloat height = (width / self.size.width) * self.size.height;
    
    // 初始化要画的大小
    CGRect  rect = CGRectMake(0, 0, width, height);
    
    // 1. 开启图形上下文
    //    UIGraphicsBeginImageContext(rect.size);
    //为保证图片清晰度 使用以下方法创建 切记
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    [self drawInRect:rect];
    
    // 3. 取到图
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    // 5. 返回
    return image;
}

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality{
    
    return  [self resetSizeOfImageData:source_image referenceSize:30 compressQuality:compressQuality];
}
/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param referenceSize   上传的参考大小**KB
 *  @param compressQuality 压缩系数 0-1
 *  @return                imageData
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image referenceSize:(NSInteger)maxSize compressQuality:(CGFloat)compressQuality
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    NSInteger tempHeight = newSize.height / 1024;
    NSInteger tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
//    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    NSLog(@"log--当前图片-->%lu",(unsigned long)sizeOriginKB);
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,compressQuality);
        NSUInteger sizeOrigin1 = [finallImageData length];
        NSUInteger sizeOriginKB1 = sizeOrigin1 / 1024;
        NSLog(@"log--大于设置最大kb-->%lu",(unsigned long)sizeOriginKB1);
        return finallImageData;
    }
    return imageData;
}
#pragma mark - 压缩图片至指定尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size
{
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    CGSize size = self.size;
    
    if(size.width <= toPX && size.height <= toPX)
    {
        return self;
    }
    
    CGFloat scale = size.width / size.height;
    
    if(size.width > size.height)
    {
        size.width = toPX;
        size.height = size.width / scale;
    }
    else
    {
        size.height = toPX;
        size.width = size.height * scale;
    }
    
    return [self rescaleImageToSize:size];
}

- (NSData *)compressWithMaxLength:(NSInteger)maxLength
{
    CGFloat compress = 0.9f;
    NSData *data = UIImageJPEGRepresentation(self, compress);
    
    while (data.length > maxLength && compress > 0.01)
    {
        compress -= 0.02f;
        
        data = UIImageJPEGRepresentation(self, compress);
    }
    
    return data;
}
@end
