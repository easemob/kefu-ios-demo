//
//  WPFileManager.h
//  WeiXinMovie
//
//  Created by qpwang on 6/13/15.
//  Copyright (c) 2015 qpwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef __WPFileManager_H__
#define __WPFileManager_H__

typedef NS_ENUM(NSUInteger, HDCallFileManagerType) {
    HDCallFileManagerTypeCache = 1,
    HDCallFileManagerTypeOffline,
    HDCallFileManagerTypeLibrary,
    HDCallFileManagerTypeTmp,
    HDCallFileManagerTypeWSSport    //清空缓存不会清空改类型
};

@interface HDCallFileManager : NSObject

@property (nonatomic, copy, readonly) NSString *baseFilePath;

///--------------------------------------------
/// @name Share Instance Method
///--------------------------------------------
+ (HDCallFileManager *)shareCacheFileInstance;
+ (HDCallFileManager *)shareTmpFileInstance;
+ (HDCallFileManager *)shareOfflineFileInstance;
+ (HDCallFileManager *)shareLibraryFileInstance;
+ (HDCallFileManager *)shareWSSportFileInstance;
///--------------------------------------------
/// @name Initial Method
///--------------------------------------------

- (id)initWithType:(HDCallFileManagerType)type;

///---------------------------------------------
/// @name Create Parent Directories Method
///---------------------------------------------
- (BOOL)createParentDirectoriesAtPath:(NSString *)path;
- (BOOL)parentDirectoriesExistAtPath:(NSString *)path;

///---------------------------------------------
/// @name Delete Files Method
///---------------------------------------------
- (BOOL)deleteFileAtPath:(NSString *)path;

///---------------------------------------------
/// @name Pares Parent Directory Of The Path Mehtod
///---------------------------------------------
- (NSString *)parseParentDirectoryAtPath:(NSString *)path;

///---------------------------------------------
/// @name Fetch Files Name
///---------------------------------------------
- (NSArray *)fileNamesInParentDirectory:(NSString *)path;

///---------------------------------------------
/// @name Sync Write File Method
///---------------------------------------------

- (BOOL)writeString:(NSString *)string atPath:(NSString *)path;
- (BOOL)writeString:(NSString *)string atPath:(NSString *)path expire:(NSTimeInterval)expire;

- (BOOL)writeData:(NSData *)data atPath:(NSString *)path;
- (BOOL)writeData:(NSData *)data atPath:(NSString *)path expire:(NSTimeInterval)expire;

- (BOOL)writeDictionary:(NSDictionary *)dictionary atPath:(NSString *)path;
- (BOOL)writeDictionary:(NSDictionary *)dictionary atPath:(NSString *)path expire:(NSTimeInterval)expire;

- (BOOL)writeArray:(NSArray *)array atPath:(NSString *)path;
- (BOOL)writeArray:(NSArray *)array atPath:(NSString *)path expire:(NSTimeInterval)expire;

- (BOOL)writeContent:(NSObject *)content atPath:(NSString *)path;
- (BOOL)writeContent:(NSObject *)content atPath:(NSString *)path expire:(NSTimeInterval)expire;

///---------------------------------------------
/// @name Sync Read File Method
///---------------------------------------------
- (NSString *)readStringAtPath:(NSString *)path;

- (NSDictionary *)readDictionaryAtPath:(NSString *)path;

- (NSData *)readDataAtPath:(NSString *)path;

- (NSArray *)readArrayAtPath:(NSString *)path;

- (NSObject *)readContentAtPath:(NSString *)path;

///---------------------------------------------
/// @name File Expire Method
///---------------------------------------------
- (void)setExpireTimeInterval:(NSTimeInterval)expireTimeInterval forFilePath:(NSString *)filePath;

- (BOOL)cleanExpireFile;

///-----------------------------------------------
/// @name Vaild File
///-----------------------------------------------
- (BOOL)fileExpiredAtFilePath:(NSString *)filePath;

- (BOOL)fileExistsAtFilePath:(NSString *)filePath;

- (BOOL)fileVaildAtFilePath:(NSString *)filePath;

@end

#endif
