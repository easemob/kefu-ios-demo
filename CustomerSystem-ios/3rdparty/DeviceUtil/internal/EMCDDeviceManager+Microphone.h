//
//  EMCDDeviceManager+Microphone.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/14/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "EMCDDeviceManager.h"

@interface EMCDDeviceManager (Microphone)
// 判断麦克风是否可用
- (BOOL)emCheckMicrophoneAvailability;

// 获取录制音频时的音量(0~1)
- (double)emPeekRecorderVoiceMeter;
@end
