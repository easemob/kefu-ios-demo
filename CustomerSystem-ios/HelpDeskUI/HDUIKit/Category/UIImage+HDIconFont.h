//
//  UIImage+HDIconFont.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
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

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HDIconFont)
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
