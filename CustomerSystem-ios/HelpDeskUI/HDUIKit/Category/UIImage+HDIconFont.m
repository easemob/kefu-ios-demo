//
//  UIImage+HDIconFont.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "UIImage+HDIconFont.h"

@implementation UIImage (HDIconFont)
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color {
    CGSize imageSize = CGSizeMake(size, size);
    // opaque：NO 不透明
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = iconCode;
    if(color){
        label.textColor = color;
    }
    label.textAlignment = NSTextAlignmentCenter;
    // 渲染自身
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    
    return retImage;
}
+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color withbackgroundColor:(UIColor *)backgroundColor {
    CGSize imageSize = CGSizeMake(size, size);
    // opaque：NO 不透明
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size];
    label.text = iconCode;
    if(color){
        label.textColor = color;
    }
    label.backgroundColor  = backgroundColor;
    [label setNumberOfLines:0];
    label.layer.cornerRadius = size/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    // 渲染自身
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    
    return retImage;
}
+ (UIImage*)imageWithIcon1:(NSString*)iconCode inFont:(NSString*)fontName size:(NSUInteger)size color:(UIColor*)color withbackgroundColor:(UIColor *)backgroundColor {
    CGSize imageSize = CGSizeMake(size, size);
    // opaque：NO 不透明
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:fontName size:size/1.4];
    label.text = iconCode;
    if(color){
        label.textColor = color;
    }
    label.backgroundColor  = backgroundColor;
    [label setNumberOfLines:0];
    label.layer.cornerRadius = size/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    // 渲染自身
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    
    return retImage;
}
@end
