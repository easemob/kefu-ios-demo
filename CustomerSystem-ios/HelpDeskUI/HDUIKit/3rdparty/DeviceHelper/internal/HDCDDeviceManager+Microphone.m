/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "HDCDDeviceManager+Microphone.h"
#import "HDAudioRecorderUtil.h"

@implementation HDCDDeviceManager (Microphone)

// Check the availability for microphone
- (BOOL)hdCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    
    return ret;
}

// Get the audio volumn (0~1)
- (double)hdPeekRecorderVoiceMeter{
    double ret = 0.0;
    if ([HDAudioRecorderUtil recorder].isRecording) {
        [[HDAudioRecorderUtil recorder] updateMeters];
        //Average volumn  [recorder averagePowerForChannel:0];
        //Maximum volumn  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [[HDAudioRecorderUtil recorder] peakPowerForChannel:0]));
        ret = lowPassResults;
    }
    
    return ret;
}
@end
