//
//  EMAudioRecorderUtil.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/8/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface EMAudioRecorderUtil : NSObject

// 当前是否正在录音
+(BOOL)isRecording;

// 开始录音
+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion;
// 停止录音
+(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 取消录音
+(void)cancelCurrentRecording;

// current recorder
+(AVAudioRecorder *)recorder;
@end
