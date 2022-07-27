//
//  ConvertToCommonEmoticonsHelper.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 14-6-30.
//  Copyright (c) 2014年 dujiepeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertToCommonEmoticonsHelper : NSObject
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;
@end
