//
//  SCFileManager.h
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/17.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SCSandBoxPath) {
    SCSandBoxPathDocuments = 0,
    SCSandBoxPathLibrary,
    SCSandBoxPathTemp,
};

@interface SCFileManager : NSObject

+ (instancetype)shareFileManager;

/**
    创建文件夹
 */
+ (BOOL)createDirectoryAtSandBoxPath:(SCSandBoxPath)sandbox directory:(NSString *)directory;









@end







