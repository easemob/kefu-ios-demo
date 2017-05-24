//
//  HDContent.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString * const TAG_ROOT;
FOUNDATION_EXPORT NSString * const TAG_WEICHAT;
FOUNDATION_EXPORT NSString * const TAG_MSGTYPE;


@interface HContent : NSObject
-(instancetype) initWithValue:(NSString *)value;
-(NSMutableDictionary *)content;
-(NSString *)value;
-(NSString *)getName;
-(NSString *)getParentName;
@end
