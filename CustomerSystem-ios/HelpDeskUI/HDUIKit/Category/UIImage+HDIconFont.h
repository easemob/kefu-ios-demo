//
//  UIImage+HDIconFont.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAppSkin.h"
#define kfontName           @"iconfont"
#define kXiaolian           @"\U0000e650"  //&#xee650
#define khuchu              @"\U0000ecb3"  //&#xecb3
#define kXiangshang1        @"\U0000e76d"  //&#xe76d
#define kguaduan1           @"\U0000e605"  //&#xe61b
#define kquanbu             @"\U0000e64f"  //&#xe64f
#define kmaikefeng1         @"\U0000e6ef"  //&#xe6ef
#define kqiehuanshexiangtou @"\U0000e67d"  //&#xe67d
#define kshexiangtou1       @"\U0000e76c"  //&#xe76c
#define kbaiban             @"\U0000e6a5"  //&#xe6a5
#define kguanbishexiangtou1 @"\U0000e640"  //&#xe640
#define kjinmai2            @"\U0000e6eb"  //&#xe6eb
#define kpingmugongxiang2   @"\U0000e6ff"  //&#xe6ff
#define kmaikefeng5         @"\U0000ecb1"  //&#xecb1
#define kjinmai             @"\U0000e6a7"  //&#xe6a7
#define klogout             @"\U0000e64b"  //&#xe64b
#define kshangchuanyunpan   @"\U0000e6b3"  //&#xe6b3
#define ksuofang            @"\U0000e60c"  //&#xe60c
#define kshipin             @"\U0000e637"  //&#xe637
#define kyinpin             @"\U0000e68b"  //&#xe68b
#define kwendangzhongxin    @"\U0000e61a"  //&#xe61a
#define kwenjianshangchuan1 @"\U0000e60d"  //&#xe60d
#define ktupian             @"\U0000e860"  //&#xe860
#define kfanhui             @"\U0000e610"  //&#xe610
#define kwenjianshangchuan  @"\U0000e742"  //&#xe742
#define kquanbu             @"\U0000e64f"  //&#xe64f
#define kdianhuatianchong   @"\U0000e678"  //&#xe678
#define kminimize           @"\U0000e65a"  //&#xe65a
#define kzoom               @"\U0000e685"  //&#xe685




NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HDIconFont)
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color;
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color withbackgroundColor:(UIColor *)backgroundColor;
@end

NS_ASSUME_NONNULL_END
