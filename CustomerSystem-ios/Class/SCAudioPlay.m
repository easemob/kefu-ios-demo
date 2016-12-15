//
//  SCAudioPlay.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/10.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCAudioPlay.h"

@interface SCAudioPlay ()<AVAudioPlayerDelegate>

@end

@implementation SCAudioPlay
+ (instancetype)sharedInstance {
    static SCAudioPlay *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SCAudioPlay alloc] init];
    });
    return player;
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}


-(void)playSoundWithData:(NSData *)soundData{
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];
    _player.delegate = self;
    _player.volume = 1.0f;
    if (_player == nil){
        NSLog(@"init  error: %@", [playerError description]);
    }
    [_player prepareToPlay];
    BOOL isStart = [_player play];
    if (isStart) {
        if (_delegate && [_delegate respondsToSelector:@selector(AVAudioPlayerBeiginPlay)]) {
            [_delegate AVAudioPlayerBeiginPlay];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVAudioPlayerDidFinishPlay)]) {
        [self.delegate AVAudioPlayerDidFinishPlay];
    }
}


- (void)playSongWithUrl:(NSString *)songUrl {
    
}

- (void)stopSound {
    if (_player && _player.isPlaying) {
        [_player stop];
    }
}






-(void)setupPlaySound{
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
#pragma mark 挂起
- (void)applicationWillResignActive:(UIApplication *)application{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AVAudioPlayerDidFinishPlay)]) {
        [self.delegate AVAudioPlayerDidFinishPlay];
    }
}

- (void)dealloc {
    _player = nil;
}
@end
