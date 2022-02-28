//
//  HDSDWebImageManager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/2/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDSDWebImageManager.h"
#import <SDWebImage/SDWebImage.h>
static HDSDWebImageManager  * instance= nil;
@implementation HDSDWebImageManager
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HDSDWebImageManager alloc] init];
    });
    
    return instance;
}


#pragma mark - Cache clean Ops

/**
 * Synchronously Clear all memory cached images
 */
- (void)clearMemory{

    [[SDImageCache sharedImageCache] clearMemory]; // clear memory
    
}
/**
 *  Get the default cache path for a certain key
 *
 *  @param key the key (can be obtained from url using cacheKeyForURL)
 *
 *  @return the default cache path
 */
- (NSString *)defaultCachePathForKey:(NSString *)key{
    
    return [[SDImageCache  sharedImageCache] cachePathForKey:key];
    
}
@end
