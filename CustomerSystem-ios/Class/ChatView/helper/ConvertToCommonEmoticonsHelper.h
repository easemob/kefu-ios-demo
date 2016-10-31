//
//  ConvertToCommonEmoticonsHelper.h
//  EMCSApp
//
//  Created by EaseMob on 15/4/16.
//  Copyright (c) 2015年 easemob. All rights reserved.

#import <Foundation/Foundation.h>

@interface ConvertToCommonEmoticonsHelper : NSObject
+ (NSArray*)emotionsArray;
+ (NSDictionary *)emotionsDictionary;
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;
@end
