/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * Created by james <https://github.com/mystcolor> on 9/28/11.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "HDSDWebImageCompat.h"

@interface UIImage (HDForceDecode)

+ (UIImage *)hdDecodedImageWithImage:(UIImage *)image;

@end
