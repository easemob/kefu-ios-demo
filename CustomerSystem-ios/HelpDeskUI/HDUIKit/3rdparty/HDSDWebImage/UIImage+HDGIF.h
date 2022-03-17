//
//  UIImage+HDGIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HDGIF)

+ (UIImage *)hdSD_animatedGIFNamed:(NSString *)name;

+ (UIImage *)hdSD_animatedGIFWithData:(NSData *)data;

- (UIImage *)hdSD_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
