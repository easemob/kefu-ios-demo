/*
 * This file is part of the HDSDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "HDSDWebImageDownloader.h"
#import "HDSDWebImageOperation.h"

extern NSString *const HDSDWebImageDownloadStartNotification;
extern NSString *const HDSDWebImageDownloadReceiveResponseNotification;
extern NSString *const HDSDWebImageDownloadStopNotification;
extern NSString *const HDSDWebImageDownloadFinishNotification;

@interface HDSDWebImageDownloaderOperation : NSOperation <HDSDWebImageOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 * The request used by the operation's task.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/**
 * The operation's task
 */
@property (strong, nonatomic, readonly) NSURLSessionTask *dataTask;


@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 *  Was used to determine whether the URL connection should consult the credential storage for authenticating the connection.
 *  @deprecated Not used for a couple of versions
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage __deprecated_msg("Property deprecated. Does nothing. Kept only for backwards compatibility");

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The HDSDWebImageDownloaderOptions for the receiver.
 */
@property (assign, nonatomic, readonly) HDSDWebImageDownloaderOptions options;

/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.
 */
@property (strong, nonatomic) NSURLResponse *response;

/**
 *  Initializes a `HDSDWebImageDownloaderOperation` object
 *
 *  @see HDSDWebImageDownloaderOperation
 *
 *  @param request        the URL request
 *  @param session        the URL session in which this operation will run
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives. 
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done. 
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance
 */
- (id)initWithRequest:(NSURLRequest *)request
            inSession:(NSURLSession *)session
              options:(HDSDWebImageDownloaderOptions)options
             progress:(HDSDWebImageDownloaderProgressBlock)progressBlock
            completed:(HDSDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(HDSDWebImageNoParamsBlock)cancelBlock;

/**
 *  Initializes a `HDSDWebImageDownloaderOperation` object
 *
 *  @see HDSDWebImageDownloaderOperation
 *
 *  @param request        the URL request
 *  @param options        downloader options
 *  @param progressBlock  the block executed when a new chunk of data arrives.
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done.
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *  @param cancelBlock    the block executed if the download (operation) is cancelled
 *
 *  @return the initialized instance. The operation will run in a separate session created for this operation
 */
- (id)initWithRequest:(NSURLRequest *)request
              options:(HDSDWebImageDownloaderOptions)options
             progress:(HDSDWebImageDownloaderProgressBlock)progressBlock
            completed:(HDSDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(HDSDWebImageNoParamsBlock)cancelBlock
__deprecated_msg("Method deprecated. Use `initWithRequest:inSession:options:progress:completed:cancelled`");

@end
