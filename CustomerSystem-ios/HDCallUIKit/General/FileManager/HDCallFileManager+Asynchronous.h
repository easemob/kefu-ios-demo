//
//  WPFileManager+Asynchronous.h
//  WeiXinMovie
//
//  Created by qpwang on 6/13/15.
//  Copyright (c) 2015 qpwang. All rights reserved.
//

#ifndef __WPFileManager_Asyn_H__
#define __WPFileManager_Asyn_H__

#import "HDCallFileManager.h"

typedef void(^complete)(BOOL success);

@interface HDCallFileManager (Asynchronous)

///---------------------------------------------
/// @name Async Write File Method
///---------------------------------------------
- (void) asyncWriteData:(NSData *)data atPath:(NSString *)path complete:(complete)complete;

- (void) asyncWriteDictionary:(NSDictionary *)dictionary atPath:(NSString *)path complete:(complete)complete;

- (void) asyncWriteString:(NSString *)string atPath:(NSString *)path complete:(complete)complete;

- (void) asyncWriteArray:(NSArray *)array atPath:(NSString *)path complete:(complete)complete;

- (void) asyncWriteContent:(NSObject *)content atPath:(NSString *)path complete:(complete)complete;

- (void) asyncWriteData:(NSData *)data atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete;

- (void) asyncWriteDictionary:(NSDictionary *)dictionary atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete;

- (void) asyncWriteString:(NSString *)string atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete;

- (void) asyncWriteArray:(NSArray *)array atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete;

- (void) asyncWriteContent:(NSObject *)content atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete;



///---------------------------------------------
/// @name Async Read File Method
///---------------------------------------------
- (void) asyncReadStringAtPath:(NSString *)path complete:(void(^)(NSString *resultString))complete;

- (void) asyncReadDataAtPath:(NSString *)path complete:(void(^)(NSData *resultData))complete;

- (void) asyncReadDictionaryAtPath:(NSString *)path complete:(void(^)(NSDictionary *resultDictionary))complete;

- (void) asyncReadArrayAtPath:(NSString *)path complete:(void(^)(NSArray *resultArray))complete;

- (void) asyncReadContentAtPath:(NSString *)path complete:(void (^)(NSObject *content))complete;

///---------------------------------------------
/// @name Async Delete File Method
///---------------------------------------------
- (void) asyncDeleteFileAtPath:(NSString *)path complete:(complete)complete;

- (void) asyncCleanExpireFile:(complete)complete;

@end

#endif
