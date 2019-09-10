/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+HDWebCache.h"
#import "objc/runtime.h"
#import "UIView+HDWebCacheOperation.h"

static char imageURLStorageKey;

@implementation UIButton (HDWebCache)

- (NSURL *)hdSD_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)hdSD_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)hdSD_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self hdSD_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HDSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HDSDImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak __typeof(self)wself = self;
    id <HDSDWebImageOperation> operation = [HDSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image && (options & HDSDWebImageAvoidAutoSetImage) && completedBlock)
            {
                completedBlock(image, error, cacheType, url);
                return;
            }
            else if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self hdSD_setImageLoadOperation:operation forState:state];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)hdSD_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_cancelBackgroundImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak __typeof(self)wself = self;
        id <HDSDWebImageOperation> operation = [HDSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image && (options & HDSDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self hdSD_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HDSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HDSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hdSD_setImageLoadOperation:(id<HDSDWebImageOperation>)operation forState:(UIControlState)state {
    [self hdSD_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)hdSD_cancelImageLoadForState:(UIControlState)state {
    [self hdSD_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)hdSD_setBackgroundImageLoadOperation:(id<HDSDWebImageOperation>)operation forState:(UIControlState)state {
    [self hdSD_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)hdSD_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self hdSD_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end


@implementation UIButton (HDWebCacheDeprecated)

- (NSURL *)currentImageURL {
    return [self hdSD_currentImageURL];
}

- (NSURL *)imageURLForState:(UIControlState)state {
    return [self hdSD_imageURLForState:state];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentImageLoad {
    // in a backwards compatible manner, cancel for current state
    [self hdSD_cancelImageLoadForState:self.state];
}

- (void)cancelBackgroundImageLoadForState:(UIControlState)state {
    [self hdSD_cancelBackgroundImageLoadForState:state];
}

@end
