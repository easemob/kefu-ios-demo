/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "HDSDWebImageCompat.h"
#import "HDSDWebImageOperation.h"

typedef NS_OPTIONS(NSUInteger, HDSDWebImageDownloaderOptions) {
    HDSDWebImageDownloaderLowPriority = 1 << 0,
    HDSDWebImageDownloaderProgressiveDownload = 1 << 1,

    /**
     * By default, request prevent the use of NSURLCache. With this flag, NSURLCache
     * is used with default policies.
     */
    HDSDWebImageDownloaderUseNSURLCache = 1 << 2,

    /**
     * Call completion block with nil image/imageData if the image was read from NSURLCache
     * (to be combined with `HDSDWebImageDownloaderUseNSURLCache`).
     */

    HDSDWebImageDownloaderIgnoreCachedResponse = 1 << 3,
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */

    HDSDWebImageDownloaderContinueInBackground = 1 << 4,

    /**
     * Handles cookies stored in NSHTTPCookieStore by setting 
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    HDSDWebImageDownloaderHandleCookies = 1 << 5,

    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    HDSDWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,

    /**
     * Put the image in the high priority queue.
     */
    HDSDWebImageDownloaderHighPriority = 1 << 7,
};

typedef NS_ENUM(NSInteger, HDSDWebImageDownloaderExecutionOrder) {
    /**
     * Default value. All download operations will execute in queue style (first-in-first-out).
     */
    HDSDWebImageDownloaderFIFOExecutionOrder,

    /**
     * All download operations will execute in stack style (last-in-first-out).
     */
    HDSDWebImageDownloaderLIFOExecutionOrder
};

extern NSString *const HDSDWebImageDownloadStartNotification;
extern NSString *const HDSDWebImageDownloadStopNotification;

typedef void(^HDSDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^HDSDWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

typedef NSDictionary *(^HDSDWebImageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

/**
 * Asynchronous downloader dedicated and optimized for image loading.
 */
@interface HDSDWebImageDownloader : NSObject

/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 */
@property (assign, nonatomic) BOOL shouldDecompressImages;

@property (assign, nonatomic) NSInteger maxConcurrentDownloads;

/**
 * Shows the current amount of downloads that still need to be downloaded
 */
@property (readonly, nonatomic) NSUInteger currentDownloadCount;


/**
 *  The timeout value (in seconds) for the download operation. Default: 15.0.
 */
@property (assign, nonatomic) NSTimeInterval downloadTimeout;


/**
 * Changes download operations execution order. Default value is `HDSDWebImageDownloaderFIFOExecutionOrder`.
 */
@property (assign, nonatomic) HDSDWebImageDownloaderExecutionOrder executionOrder;

/**
 *  Singleton method, returns the shared instance
 *
 *  @return global shared instance of downloader class
 */
+ (HDSDWebImageDownloader *)sharedDownloader;

/**
 *  Set the default URL credential to be set for request operations.
 */
@property (strong, nonatomic) NSURLCredential *urlCredential;

/**
 * Set username
 */
@property (strong, nonatomic) NSString *username;

/**
 * Set password
 */
@property (strong, nonatomic) NSString *password;

/**
 * Set filter to pick headers for downloading image HTTP request.
 *
 * This block will be invoked for each downloading image request, returned
 * NSDictionary will be used as headers in corresponding HTTP request.
 */
@property (nonatomic, copy) HDSDWebImageDownloaderHeadersFilterBlock headersFilter;

/**
 * Set a value for a HTTP header to be appended to each download HTTP request.
 *
 * @param value The value for the header field. Use `nil` value to remove the header.
 * @param field The name of the header field to set.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 * Returns the value of the specified HTTP header field.
 *
 * @return The value associated with the header field field, or `nil` if there is no corresponding header field.
 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/**
 * Sets a subclass of `HDSDWebImageDownloaderOperation` as the default
 * `NSOperation` to be used each time HDSDWebImage constructs a request
 * operation to download an image.
 *
 * @param operationClass The subclass of `HDSDWebImageDownloaderOperation` to set 
 *        as default. Passing `nil` will revert to `HDSDWebImageDownloaderOperation`.
 */
- (void)setOperationClass:(Class)operationClass;

/**
 * Creates a HDSDWebImageDownloader async downloader instance with a given URL
 *
 * The delegate will be informed when the image is finish downloaded or an error has happen.
 *
 * @see HDSDWebImageDownloaderDelegate
 *
 * @param url            The URL to the image to download
 * @param options        The options to be used for this download
 * @param progressBlock  A block called repeatedly while the image is downloading
 * @param completedBlock A block called once the download is completed.
 *                       If the download succeeded, the image parameter is set, in case of error,
 *                       error parameter is set with the error. The last parameter is always YES
 *                       if HDSDWebImageDownloaderProgressiveDownload isn't use. With the
 *                       HDSDWebImageDownloaderProgressiveDownload option, this block is called
 *                       repeatedly with the partial image object and the finished argument set to NO
 *                       before to be called a last time with the full image and finished argument
 *                       set to YES. In case of error, the finished argument is always YES.
 *
 * @return A cancellable HDSDWebImageOperation
 */
- (id <HDSDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(HDSDWebImageDownloaderOptions)options
                                        progress:(HDSDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(HDSDWebImageDownloaderCompletedBlock)completedBlock;

/**
 * Sets the download queue suspension state
 */
- (void)setSuspended:(BOOL)suspended;

/**
 * Cancels all download operations in the queue
 */
- (void)cancelAllDownloads;

@end
