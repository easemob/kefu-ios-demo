/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HDWebCache.h"
#import "objc/runtime.h"
#import "UIView+HDWebCacheOperation.h"

static char hdImageURLKey;
static char HD_TAG_ACTIVITY_INDICATOR;
static char HD_TAG_ACTIVITY_STYLE;
static char HD_TAG_ACTIVITY_SHOW;

@implementation UIImageView (HDWebCache)

- (void)hdSD_setImageWithURL:(NSURL *)url {
    [self hdSD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)hdSD_setImageWithURL:(NSURL *)url completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)hdSD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &hdImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & HDSDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {

        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }

        __weak __typeof(self)wself = self;
        id <HDSDWebImageOperation> operation = [HDSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & HDSDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & HDSDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self hdSD_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HDSDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HDSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hdSD_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletionBlock)completedBlock {
    NSString *key = [[HDSDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[HDSDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self hdSD_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];    
}

- (NSURL *)hdSD_imageURL {
    return objc_getAssociatedObject(self, &hdImageURLKey);
}

- (void)hdSD_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self hdSD_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <HDSDWebImageOperation> operation = [HDSDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self hdSD_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)hdSD_cancelCurrentImageLoad {
    [self hdSD_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)hdSD_cancelCurrentAnimationImagesLoad {
    [self hdSD_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &HD_TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &HD_TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &HD_TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &HD_TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &HD_TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &HD_TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }

    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });

}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end


@implementation UIImageView (HDWebCacheDeprecated)

- (NSURL *)imageURL {
    return [self hdSD_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self hdSD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletedBlock)completedBlock {
    [self hdSD_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HDSDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)hdSD_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(HDSDWebImageOptions)options progress:(HDSDWebImageDownloaderProgressBlock)progressBlock completed:(HDSDWebImageCompletionBlock)completedBlock {
    [self hdSD_setImageWithPreviousCachedImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)cancelCurrentArrayLoad {
    [self hdSD_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad {
    [self hdSD_cancelCurrentImageLoad];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self hdSD_setAnimationImagesWithURLs:arrayOfURLs];
}

@end
