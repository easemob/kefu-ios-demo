//
//  HCallManagerDelegate.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCallEntities.h"

/*!
 *  \~chinese
 *  实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of real time voice/video
 */
@protocol HCallManagerDelegate <NSObject>
@optional
/**
 接收到视频请求
 */
- (void)onCallReceivedNickName:(NSString *)nickName;

/**
 成员进入会话

 @param member member
 */
- (void)onMemberJoin:(HCallMember *)member;


/**
 成员离开会话

 @param member member
 */
- (void)onMemberExit:(HCallMember *)member;

/**
 视频流加入

 @param stream stream
 */
- (void)onStreamAdd:(HCallStream *)stream;

/**
 视频流被移除

 @param stream stream
 */
- (void)onStreamRemove:(HCallStream *)stream;

/**
 会话结束

 @param reason 原因
 @param desc 描述
 */
- (void)onCallEndReason:(int)reason desc:(NSString *)desc;

/**
 视频流更新

 @param stream stream
 */
- (void)onStreamUpdate:(HCallStream *)stream;
    
- (void)onNotice:(HMediaNoticeCode)code arg1:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(id)arg3;

@end
