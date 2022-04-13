//
//  HDSDWebImageManager.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/2/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDSDWebImageManager : NSObject
+ (instancetype)shareInstance;

#pragma mark - Cache clean Ops

/**
 * Synchronously Clear all memory cached images
 */
- (void)clearMemory;
/**
 *  Get the default cache path for a certain key
 *
 *  @param key the key (can be obtained from url using cacheKeyForURL)
 *
 *  @return the default cache path
 */
- (NSString *)defaultCachePathForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
