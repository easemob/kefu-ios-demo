//
//  NSObject+Add.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/10.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "NSObject+Add.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (Add)

- (BOOL)_canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

@end
