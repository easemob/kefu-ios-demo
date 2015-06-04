//
//  EMCDDeviceManager+Remind.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/14/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "EMCDDeviceManager.h"
#import <AudioToolbox/AudioToolbox.h>
@interface EMCDDeviceManager (Remind)
// 播放接收到新消息时的声音
- (SystemSoundID)playNewMessageSound;

// 震动
- (void)playVibration;
@end
