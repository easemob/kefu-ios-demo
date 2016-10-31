//
//  NSDictionary+SafeValue.h
//  EMCSApp
//
//  Created by dhc on 15/4/10.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeValue)

- (NSString *)safeStringValueForKey:(NSString *)key;

- (NSInteger)safeIntegerValueForKey:(NSString *)key;

@end
