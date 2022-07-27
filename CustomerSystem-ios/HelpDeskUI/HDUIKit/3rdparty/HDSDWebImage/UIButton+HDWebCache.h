//
//  UIButton+HDWebCache.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/2/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HDWebCache)
/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see hdSD_setImageWithURL:placeholderImage:options:
 */
- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
@end

NS_ASSUME_NONNULL_END
