//
//  NSObject+SCAdd.m
//  CustomerSystem-ios
//
//  Created by ease on 16/11/28.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "NSObject+SCAdd.h"

@implementation NSObject (SCAdd)
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
