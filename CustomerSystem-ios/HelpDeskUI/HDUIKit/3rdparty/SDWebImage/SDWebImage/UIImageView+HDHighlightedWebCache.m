/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HDHighlightedWebCache.h"
#import "UIView+HDWebCacheOperation.h"

#define HDUIImageViewHDHighlightedWebCacheOperationKey @"hdhighlightedImage"

@implementation UIImageView (HDHighlightedWebCache)

- (void)hdSD_setHighlightedImageWithURL:(NSURL *)url {
    [self hdSD_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)hdSD_setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options {
    [self hdSD_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)hdSD_setHighlightedImageWithURL:(NSURL *)url completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)hdSD_setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)hdSD_setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<HDSDWebImageOperation> operation = [HDSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image && (options & HDSDWebImageAvoidAutoSetImage) && completedBlock)
                                         {
                                             completedBlock(image, error, cacheType, url);
                                             return;
                                         }
                                         else if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self hdSD_setImageLoadOperation:operation forKey:HDUIImageViewHDHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HDSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HDSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hdSD_cancelCurrentHighlightedImageLoad {
    [self hdSD_cancelImageLoadOperationWithKey:HDUIImageViewHDHighlightedWebCacheOperationKey];
}

@end


@implementation UIImageView (HDHighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url {
    [self hdSD_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options {
    [self hdSD_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setHighlightedImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setHighlightedImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setHighlightedImageWithURL:url options:0 progress:progressBlock completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentHighlightedImageLoad {
    [self hdSD_cancelCurrentHighlightedImageLoad];
}

@end
