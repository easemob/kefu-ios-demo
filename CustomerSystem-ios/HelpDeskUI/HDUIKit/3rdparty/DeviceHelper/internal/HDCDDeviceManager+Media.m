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

#import "HDCDDeviceManager+Media.h"
#import "HDAudioPlayerUtil.h"
#import "HDAudioRecorderUtil.h"
#import "HDVoiceConverter.h"
#import "HDDemoErrorCode.h"
#import "HDLocalDefine.h"

typedef NS_ENUM(NSInteger, HDAudioSession){
    HD_DEFAULT = 0,
    HD_AUDIOPLAYER,
    HD_AUDIORECORDER
};

@implementation HDCDDeviceManager (Media)
#pragma mark - AudioPlayer

+ (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

// Play the audio
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon{
    BOOL isNeedSetActive = YES;
    // Cancel if it is currently playing
    if([HDAudioPlayerUtil isPlaying]){
        [HDAudioPlayerUtil stopCurrentPlaying];
        isNeedSetActive = NO;
    }
    
    if (isNeedSetActive) {
        [self setupAudioSessionCategory:HD_AUDIOPLAYER
                               isActive:YES];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
     //判断文件格式是否为AMR, 如果是需要转换为wav
    //[备注:收到的]
    if ([HDVoiceConverter isAMRFile:aFilePath]) {
        if (![fileManager fileExistsAtPath:wavFilePath]) {
            BOOL covertRet = [self convertAMR:aFilePath toWAV:wavFilePath];
            if (!covertRet) {
                if (completon) {
                    completon([NSError errorWithDomain:NSEaseLocalizedString(@"error.initRecorderFail", @"File format conversion failed")
                                                  code:HDErrorFileTypeConvertionFailure
                                              userInfo:nil]);
                }
                return ;
            }
        }
    } else {
        wavFilePath = aFilePath;
    }

    [HDAudioPlayerUtil asyncPlayingWithPath:wavFilePath
                                 completion:^(NSError *error)
     {
         [self setupAudioSessionCategory:HD_DEFAULT
                                isActive:NO];
         if (completon) {
             completon(error);
         }
     }];
}

- (void)stopPlaying{
    [HDAudioPlayerUtil stopCurrentPlaying];
    [self setupAudioSessionCategory:HD_DEFAULT
                           isActive:NO];
}

- (void)stopPlayingWithChangeCategory:(BOOL)isChange{
    [HDAudioPlayerUtil stopCurrentPlaying];
    if (isChange) {
        [self setupAudioSessionCategory:HD_DEFAULT
                               isActive:NO];
    }
}

- (BOOL)isPlaying{
    return [HDAudioPlayerUtil isPlaying];
}

#pragma mark - Recorder

+(NSTimeInterval)recordMinDuration{
    return 1.0;
}

// Start recording
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                             completion:(void(^)(NSError *error))completion{
    NSError *error = nil;
    
    if ([self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.recordStoping", @"Record voice is not over yet")
                                        code:HDErrorAudioRecordStoping
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    
    if (!fileName || [fileName length] == 0) {
        error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.notFound", @"File path not exist")
                                    code:-1
                                userInfo:nil];
        completion(error);
        return ;
    }
    
    BOOL isNeedSetActive = YES;
    if ([self isRecording]) {
        [HDAudioRecorderUtil cancelCurrentRecording];
        isNeedSetActive = NO;
    }
    
    [self setupAudioSessionCategory:HD_AUDIORECORDER
                           isActive:YES];
    
    _recorderStartDate = [NSDate date];

    NSString *recordPath = [NSString stringWithFormat:@"%@/%@", [HDCDDeviceManager dataPath], fileName];
    [HDAudioRecorderUtil asyncStartRecordingWithPreparePath:recordPath
                                                 completion:completion];
}

// Stop recording
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion{
    if(![self isRecording]){
        if (completion) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotStartedRecording" object:nil];
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _recorderEndDate = [NSDate date];
    
    if([_recorderEndDate timeIntervalSinceDate:_recorderStartDate] < [HDCDDeviceManager recordMinDuration]){
        if (completion) {
            // 时间过短
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TheRecordingTimeIsTooShort" object:nil];
        }
        
        // If the recording time is too shorty，in purpose delay one second
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([HDCDDeviceManager recordMinDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HDAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
                [weakSelf setupAudioSessionCategory:HD_DEFAULT isActive:NO];
            }];
        });
        return ;
    }
    
    [HDAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
        if (completion) {
            if (recordPath) {
                // Convert wav to amr
                NSString *amrFilePath = [[recordPath stringByDeletingPathExtension]
                                         stringByAppendingPathExtension:@"amr"];
                BOOL convertResult = [self convertWAV:recordPath toAMR:amrFilePath];
                NSError *error = nil;
                if (convertResult) {
                    // Remove the wav
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:recordPath error:nil];
                }
                else {
                    error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.initRecorderFail", @"File format conversion failed")
                                                code:HDErrorFileTypeConvertionFailure
                                            userInfo:nil];
                }
                completion(amrFilePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],error);
            }
            [weakSelf setupAudioSessionCategory:HD_DEFAULT isActive:NO];
        }
    }];
}

// Cancel recording
-(void)cancelCurrentRecording{
    [HDAudioRecorderUtil cancelCurrentRecording];
}

-(BOOL)isRecording{
    return [HDAudioRecorderUtil isRecording];
}

#pragma mark - Private
-(NSError *)setupAudioSessionCategory:(HDAudioSession)session
                             isActive:(BOOL)isActive{
    BOOL isNeedActive = NO;
    if (isActive != _currActive) {
        isNeedActive = YES;
        _currActive = isActive;
    }
    NSError *error = nil;
    NSString *audioSessionCategory = nil;
    switch (session) {
        case HD_AUDIOPLAYER:
            audioSessionCategory = AVAudioSessionCategoryPlayback;
            break;
        case HD_AUDIORECORDER:
            audioSessionCategory = AVAudioSessionCategoryRecord;
            break;
        default:
            audioSessionCategory = AVAudioSessionCategoryAmbient;
            break;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    if (![_currCategory isEqualToString:audioSessionCategory]) {
        [audioSession setCategory:audioSessionCategory error:nil];
    }
    if (isNeedActive) {
        BOOL success = [audioSession setActive:isActive
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
        if(!success || error){
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer")
                                        code:-1
                                    userInfo:nil];
            return error;
        }
    }
    _currCategory = audioSessionCategory;
    
    return error;
}

#pragma mark - Convert

- (BOOL)convertAMR:(NSString *)amrFilePath
             toWAV:(NSString *)wavFilePath
{
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
    if (isFileExists) {
        [HDVoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}

- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [HDVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (!isFileExists) {
            
        } else {
            ret = YES;
        }
    }
    
    return ret;
}

@end
