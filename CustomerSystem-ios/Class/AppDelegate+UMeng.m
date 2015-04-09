//
//  AppDelegate+UMeng.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 1/6/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "AppDelegate+UMeng.h"
#import "MobClick.h"

@implementation AppDelegate (UMeng)

-(void)setupUMeng{
    //友盟
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([bundleID isEqualToString:@"com.easemob.enterprise.demo.ui"]) {
        [MobClick startWithAppkey:@"5389bb7f56240ba94208ac97"
                     reportPolicy:BATCH
                        channelId:Nil];
#if DEBUG
        [MobClick setLogEnabled:YES];
#else
        [MobClick setLogEnabled:NO];
#endif
    }
}

@end
