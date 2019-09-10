//
// Created by Fabrice Aneche on 06/01/14.
// Copyright (c) 2014 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HDImageContentType)

/**
 *  Compute the content type for an image data
 *
 *  @param data the input data
 *
 *  @return the content type as string (i.e. image/jpeg, image/gif)
 */
+ (NSString *)hdSD_contentTypeForImageData:(NSData *)data;

@end


@interface NSData (HDImageContentTypeDeprecated)

+ (NSString *)contentTypeForImageData:(NSData *)data __deprecated_msg("Use `hdSD_contentTypeForImageData:`");

@end
