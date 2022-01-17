//
//  SampleHandler.m
//  Demo
//
//  Created by houli on 2022/1/13.
//


#import "SampleHandler.h"
#import "HDAgoraUploader.h"
#import <CoreMedia/CoreMedia.h>
@interface SampleHandler()

@property (nonatomic) CMSampleBufferRef bufferCopy;
@property (nonatomic, assign)  NSUInteger lastSendTs;
@property (nonatomic, strong)  NSTimer *timer;


@end

@implementation SampleHandler


// 监听开始 实行 数据同步 Socket实现数据同步：
- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    
    self.lastSendTs = [self getNowTime];
    if([[setupInfo allKeys] containsObject:@"channelName"]){

        NSString *channelName = (NSString *)[setupInfo valueForKey:@"channelName"];
        [[HDAgoraUploader sharedAgoraEngine] startBroadcast:channelName];

    }else{

        [[HDAgoraUploader sharedAgoraEngine] startBroadcast:@"huanxin"];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

        NSUInteger  elapse =  [weakSelf getNowTime] - weakSelf.lastSendTs;

        NSLog(@"elapse===%lu",(unsigned long)elapse);

        if(elapse > 300) {
            if (weakSelf.bufferCopy){
                [weakSelf processSampleBuffer:weakSelf.bufferCopy withType:RPSampleBufferTypeVideo];
            }
        }
    }];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
    });
}
#pragma mark --- 获取当前时间戳--13位
- (NSUInteger )getNowTime{
    
    //获取当前时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    
    return [timeSp integerValue];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[HDAgoraUploader sharedAgoraEngine] stopBroadcast];
    
}
//监听数据流
- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    __weak typeof(self) weakSelf = self;

            switch (sampleBufferType) {
            case RPSampleBufferTypeVideo:
                weakSelf.bufferCopy = sampleBuffer;
                weakSelf.lastSendTs = [weakSelf getNowTime];
                [[HDAgoraUploader sharedAgoraEngine] sendVideoBuffer:sampleBuffer];
                NSLog(@"RPSampleBufferTypeVideo App~~~~");
                break;
            case RPSampleBufferTypeAudioApp:
                [[HDAgoraUploader sharedAgoraEngine] sendAudioAppBuffer:sampleBuffer];
                NSLog(@"RPSampleBufferTypeAudio App+++");
                break;
            case RPSampleBufferTypeAudioMic:
                [[HDAgoraUploader sharedAgoraEngine] sendAudioMicBuffer:sampleBuffer];
                break;
            }

}
//数据流推送
- (void)sendData:(CMSampleBufferRef)sampleBuffer{
    
    
}
//文字推送
-(void)sendStringData:(NSString*)string{
    
   
}

// 录屏直播 主App和宿主App数据共享，通信功能实现 如果我们要将开始、暂停、结束这些事件以消息的形式发送到宿主App中，需要使用CFNotificationCenterGetDarwinNotifyCenter。
- (void)sendNotificationForMessageWithIdentifier:(nullable NSString *)identifier userInfo:(NSDictionary *)info {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFDictionaryRef userInfo = (__bridge CFDictionaryRef)info;
    BOOL const deliverImmediately = YES;
    CFStringRef identifierRef = (__bridge CFStringRef)identifier;
    CFNotificationCenterPostNotification(center, identifierRef, NULL, userInfo, deliverImmediately);
}


@end
