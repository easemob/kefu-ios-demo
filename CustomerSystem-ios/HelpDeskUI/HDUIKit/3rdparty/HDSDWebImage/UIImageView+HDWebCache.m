//
//  UIImageView+HDWebCache.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/2/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "UIImageView+HDWebCache.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (HDWebCache)

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}
@end
