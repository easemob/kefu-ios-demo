//
//  HCallManager.h
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 3/20/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"

@interface HCallManager : NSObject

@property (strong, nonatomic)HomeViewController  *mainViewController;

+ (instancetype)sharedInstance;

- (void)answerCall:(NSString *)aCallId;
- (void)answerCall:(NSString *)aCallId enableVideo:(BOOL)aEnableVideo;

- (void)hangupCallWithReason:(HCallEndReason)aReason;

@end
