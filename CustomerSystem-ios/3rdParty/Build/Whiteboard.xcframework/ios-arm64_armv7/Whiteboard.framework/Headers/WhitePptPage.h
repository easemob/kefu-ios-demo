//
//  WhitePptPage.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import <UIKit/UIkit.h>
#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 用于在初始化场景时配置场景的图片。 */
@interface WhitePptPage : WhiteObject

/** 设置场景的图片信息并初始化一个 `WhitePptPage` 对象。
 @param src 图片的 URL 地址。
 @param size 图片尺寸。

 @return 初始化的 `WhitePptPage` 对象。
 */
- (instancetype)initWithSrc:(NSString *)src size:(CGSize)size;

/** 设置场景的预览图片信息并初始化一个 `WhitePptPage` 对象。
 @param src 图片的 URL 地址。
 @param url 预览图片的 URL 地址。
 @param size 图片尺寸。

 @return 初始化的 `WhitePptPage` 对象。
 */
- (instancetype)initWithSrc:(NSString *)src preview:(NSString *)url size:(CGSize)size;

/**
 图片的 URL 地址。
 */
@property (nonatomic, copy) NSString *src;
/**
 图片的 URL 宽度。单位为像素。
 */
@property (nonatomic, assign) CGFloat width;
/**
 图片的 URL 高度。单位为像素。
 */
@property (nonatomic, assign) CGFloat height;

/**
 预览图片的 URL 地址。
 */
@property (nonatomic, copy, readonly) NSString *previewURL;

@end

NS_ASSUME_NONNULL_END
