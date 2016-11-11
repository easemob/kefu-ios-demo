//
//  SCNetworkManager.h
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/10.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNetworkManager : NSObject
- (void)downloadFileWithUrl:(NSString *)url completionHander:(void (^)(BOOL success,NSURL *filePath,NSError *error))completion;
+ (instancetype)sharedInstance;

@end
