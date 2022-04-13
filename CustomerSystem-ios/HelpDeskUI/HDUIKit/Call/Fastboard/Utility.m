//
//  Utility.m
//  OCExample
//
//  Created by xuyunshi on 2022/1/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>
#import "HDAppSkin.h"
#import "UIImage+HDIconFont.h"
Theme const ThemeAuto = @"auto";
Theme const ThemeDark = @"dark";
Theme const ThemeLight = @"light";

@implementation Utility

+ (UIButton *)buttonWith: (NSString *)title index: (int)index {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [Utility randomColor];
//    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = index + 1001;
//    UITraitCollection* trait = UIApplication.sharedApplication.windows.firstObject.traitCollection;
//    BOOL hasCompact = trait.verticalSizeClass == UIUserInterfaceSizeClassCompact || trait.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
//    if (hasCompact) {
//        btn.contentEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
//    } else {
//        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    }
    [Utility setButtonImage:btn withIndex:index];
    return btn;
}
+ (void)setButtonImage:(UIButton *)btn withIndex:(NSInteger)index{
    UIImage * img;
    switch (index) {
        case 0:
          img = [UIImage imageWithIcon:ksuofang inFont:kfontName size:20 color:[[HDAppSkin mainSkin] contentColorGray1] ];
           
            break;
        case 1:
            img = [UIImage imageWithIcon:kwenjianshangchuan inFont:kfontName size:23 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case 2:
            img = [UIImage imageWithIcon:klogout inFont:kfontName size:20 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        default:
            break;
    }
    [btn setImage:img forState:UIControlStateNormal];
    
}
+ (UIColor *)randomColor {
    NSArray* colors = @[UIColor.systemRedColor,
                        UIColor.blackColor,
                        UIColor.systemOrangeColor,
                        UIColor.systemBlueColor,
                        UIColor.systemGreenColor,
                        UIColor.systemPinkColor,
                        UIColor.systemYellowColor,
                        UIColor.systemGrayColor,
                        UIColor.systemPurpleColor,
                        UIColor.systemTealColor];
    int i = random() % 10;
    return colors[i];
}

@end
