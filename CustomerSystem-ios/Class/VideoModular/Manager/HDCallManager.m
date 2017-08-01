//
//  HDCallManager.m
//  HRTCDemo
//
//  Created by afanda on 7/26/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDCallManager.h"
#import "HDMemberObject.h"
#import <AVFoundation/AVFoundation.h>
@interface HDCallManager ()

@end

@implementation HDCallManager
{
    NSMutableDictionary *_memberObjDic;
    BOOL _inSession; //是否在会话中
    BOOL _acceptTicket; //是否正在处理ticket
    NSMutableArray <HDMemberObject *> *_cacheMembers;  //未接受的时候存储
}
static HDCallManager *_manager = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HDCallManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memberObjDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _cacheMembers = [NSMutableArray arrayWithCapacity:0];
        _inSession = NO;
        _acceptTicket = NO;
    }
    return self;
}

- (void)exitSession {
    [_currentCallVC dismissViewControllerAnimated:YES completion:nil];
    _currentCallVC = nil;
    _currentSession = nil;
    _inSession = NO;
    _acceptTicket = NO;
    [_memberObjDic removeAllObjects];
    [_cacheMembers removeAllObjects];
}

- (void)acceptVideoRequest {
    _inSession = YES;
}

- (void)receiveVideoRequestExtension:(NSDictionary *)extension {
    NSString *  ticket = [extension objectForKey:@"ticket"];
    NSString *name = [extension objectForKey:@"nickname"];
    [self receiveAticket:ticket name:name];
}

- (void)receiveAticket:(NSString *)ticket name:(NSString *)name {
    if (_inSession == YES) { //正在视频...
        return;
    }
    _acceptTicket = YES;
    EMediaSession *session =  [[EMediaManager shared]
                               newSessionWithTicket:ticket
                               extension:[self getExt]
                               delegate:self
                               delegateQueue:dispatch_get_main_queue()];
    
    HDCallViewController *callVC = [[HDCallViewController alloc] initWithSession:session];
    callVC.nickname = name;
    callVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.currentCallVC = callVC;
    self.currentSession = session;
    if (session) {
        [[EMediaManager shared] join:session publishConfig:nil onDone:^(id obj, EMediaError *error) {
            if (error == nil) {
                [self.rootViewController presentViewController:self.currentCallVC animated:NO completion:nil];
            } else {
                _inSession = NO;
                _acceptTicket = NO;
                NSLog(@"error###description:%@",error.errorDescription);
            }
        }];
    }
}

#pragma mark - EMediaSessionDelegate
/**
 成员进来
 */
- (void)onEMediaSession:(EMediaSession *) session joinMember:(EMediaMember *) member {
    NSLog(@"成员进来:%@",member.memberName);
    HDMemberObject *item = [self getMemberObjWithMemberName:member.memberName];
    NSDictionary *ext = [self dictWithString:member.extension];
    item.agentName = [ext objectForKey:@"nickname"];
    [_memberObjDic setObject:item forKey:member.memberName];
}

/**
 成员离开会话
 */
- (void)onEMediaSession:(EMediaSession *) session exitMember:(EMediaMember *) member {
    HDMemberObject *item = [_memberObjDic objectForKey:member.memberName];
    [item.remoteVideoItem.backView removeFromSuperview];
    [_memberObjDic removeObjectForKey:member.memberName];
    [self reLayoutVideos];
}

/**
 有新视频流
 */
- (void)onEMediaSession:(EMediaSession *) session addStream:(EMediaStream *) stream {
    HDMemberObject *item = [self getMemberObjWithMemberName:stream.memberName];
    if (item == nil) {
        NSLog(@"成员多于3个将被抛弃");
        return;
    }
    if (stream.streamType == EMSTREAM_TYPE_NORMAL) {
        item.normalStream = stream;
    } else {
        item.deskTopStream = stream;
    }
    [_memberObjDic setObject:item forKey:stream.memberName];
    if (_inSession) {
        [self subscribeStreamWithMemberObj:item];
    } else {
        [_cacheMembers addObject:item];
    }
    
}

/**
 视频流被移除[仅指其他人]
 */
- (void)onEMediaSession:(EMediaSession *) session removeStream:(EMediaStream *) stream{
    HDMemberObject *item = [_memberObjDic objectForKey:stream.memberName];
    if (stream.streamType == EMSTREAM_TYPE_NORMAL) {
        item.remoteVideoItem.normalView.hidden = YES;
        item.remoteVideoItem.deskTopView.hidden = YES;
    } else {
        item.remoteVideoItem.deskTopView.hidden = YES;
        item.remoteVideoItem.normalView.hidden =NO;
        item.deskTopStream = nil;
    }
}

/**
 视频流刷新
 */
- (void)onEMediaSession:(EMediaSession *) session updateStream:(EMediaStream *) stream{
    
}


/**
 自己的视频被动关闭
 1、网络原因
 2、其他平台登录
 3、被踢
 */
- (void)onEMediaSession:(EMediaSession *) session passiveCloseReason:(EMediaErrorCode) reason desc:(NSString*)desc {
    NSString *tip = @"";
    switch (reason) {
        case EMEDIA_ERROR_REASON_DISMISS:
        {
            tip = @"对方挂断了视频通话";
            break;
        }
        default:
            tip = @"视频通话已经结束";
            break;
    }
    [_currentCallVC showHint:tip];
    [self exitSession];
}


/**
 发送网络状态等的。通知
 */
- (void)onEMediaSession:(EMediaSession *) session notice:(EMediaNoticeCode) code
                   arg1:(NSString *)arg1
                   arg2:(NSString*)arg2
                   arg3:(id)arg3 {
    NSLog(@"notice,session:%@,code:%d,arg1:%@,arg2:%@",session,code,arg1,arg2);
    
}

#pragma mark - 用户交互

- (void)publish:(EMediaSession *)session publishConfig:(EMediaPublishConfiguration *)config onDone:(EMediaIdBlockType)block {
    [[EMediaManager shared] publish:session publishConfig:config onDone:block];
    for (HDMemberObject *item in _cacheMembers) {
        [self subscribeStreamWithMemberObj:item];
    }
    [_cacheMembers removeAllObjects];
}

- (void)exit:(EMediaSession *)session onDone:(EMediaIdBlockType)block {
    [[EMediaManager shared] exit:session onDone:block];
    [self exitSession];
}


- (void)setSpeakEnable:(BOOL)enable {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if (enable) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
    [audioSession setActive:YES error:nil];
}

#pragma 不需要主动操作
- (void)subscribeStreamWithMemberObj:(HDMemberObject *)member {
    dispatch_async(dispatch_get_main_queue(), ^{
        EMCallRemoteView *topView;
        NSString * streamId = nil;
        if (member.deskTopStream!=nil) { //一个member有两个流
            topView = member.remoteVideoItem.deskTopView;
        }
        if (member.deskTopStream == nil && member.normalStream != nil) {
            member.remoteVideoItem.deskTopView.hidden = YES;
            topView = member.remoteVideoItem.normalView;
        }
        
        if (member.deskTopStream != nil) {
            streamId = member.deskTopStream.streamId;
        } else {
            streamId = member.normalStream.streamId;
        }
        [[EMediaManager shared] subscribe:_currentSession streamId:streamId view:topView onDone:^(id obj, EMediaError *error) {
            if (error == nil) {
                NSLog(@"订阅成功");
                topView.hidden = NO;
                if (member.deskTopStream != nil) {
                    member.remoteVideoItem.normalView.hidden = YES;
                }
                [member.remoteVideoItem.backView bringSubviewToFront:member.remoteVideoItem.backView.nameLabel];
                [_currentCallVC addStreamWithHDMemberObj:member];
            } else {
                NSLog(@"订阅失败 error:%@",error.errorDescription);
            }
        }];
    });
    
}



#pragma mark - initData

- (HDMemberObject *)getMemberObjWithMemberName:(NSString *)memberName {
    HDMemberObject *item = [_memberObjDic objectForKey:memberName];
    if (item == nil) {
        if (_memberObjDic.count >= 3) {
            return nil;
        }
        item = [self newMemberObjWithMemberName:memberName];
    }
    return item;
}


- (HDMemberObject *)newMemberObjWithMemberName:(NSString *)memberName {
    NSInteger memberCount = _memberObjDic.count;
    CGFloat x=(memberCount+1)%2 * KWH;;
    CGFloat y=(memberCount+1)/2 * KWH;
    CGRect frame = CGRectMake(x, y, KWH, KWH);
    HDMemberObject *item = [[HDMemberObject alloc] initWithMemberName:memberName frame:frame target:self];
    [item setTapBlock:^(HVideoItem *videoItem) {
        videoItem.scaleMode = EMCallViewScaleModeAspectFit;
        [self bringBtnToFrontWithMemberObj:videoItem];
    }];
    return item;
}


- (void)bringBtnToFrontWithMemberObj:(HVideoItem *)item {
    [_currentCallVC showOneVideoBackView:item.backView];
}

- (void)restoreBtnClicked {
    [self reLayoutVideos];
}

- (void)reLayoutVideos {
    NSArray *arr = [_memberObjDic allValues];
    if (arr.count == 0) {
        return;
    }
    [_currentCallVC layoutVideosWithMembers:arr];
}

#pragma mark - private

- (NSString *)getExt {
    NSDictionary *ext = @{
                          @"identity": @"visitor",
                          @"nickname": [SCLoginManager shareLoginManager].nickname
                          };
    
    return [self dictionaryToJson:ext];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictWithString:(NSString *)string
{
    if (string && 0 != string.length)
    {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error)
        {
            NSLog(@"json解析失败：%@", error);
            return nil;
        }
        return jsonDict;
    }
    
    return nil;
}


@end
