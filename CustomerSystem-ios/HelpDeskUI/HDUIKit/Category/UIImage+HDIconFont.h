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
#define kguaduan1           @"\U0000e605"  //&#xe61b
#define kmaikefeng1         @"\U0000e6ef"  //&#xe6ef
#define kqiehuanshexiangtou @"\U0000e67d"  //&#xe67d
#define kshexiangtou1       @"\U0000e76c"  //&#xe76c
#define kbaiban             @"\U0000e6a5"  //&#xe6a5
#define kguanbishexiangtou1 @"\U0000e640"  //&#xe640
#define kpingmugongxiang2   @"\U0000e6ff"  //&#xe6ff
#define kmaikefeng5         @"\U0000ecb1"  //&#xecb1
#define kjinmai             @"\U0000e6a7"  //&#xe6a7
#define klogout             @"\U0000e64b"  //&#xe64b
#define ksuofang            @"\U0000e60c"  //&#xe60c
#define kfanhui             @"\U0000e610"  //&#xe610
#define kwenjianshangchuan  @"\U0000e742"  //&#xe742
#define kdianhuatianchong   @"\U0000e600"  //&#xe678
#define kzoom               @"\U0000e741"  //&#xe685
#define kfeihuazhonghua     @"\U0000e7c6"  //&#xe7c6
#define khuazhonghua1       @"\U0000e61c"  //&#xe61c
#define kguanbi             @"\U0000eaf2"  //&#xeaf2


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HDIconFont)
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color;
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color withbackgroundColor:(UIColor *)backgroundColor;
+ (UIImage*)imageWithIcon1:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color withbackgroundColor:(UIColor *)backgroundColor;
@end

NS_ASSUME_NONNULL_END
