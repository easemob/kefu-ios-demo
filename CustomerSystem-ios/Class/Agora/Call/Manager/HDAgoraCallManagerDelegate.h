//
//  HDAgoraCallManagerDelegate.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/4.
//  Copyright © 2022 easemob. All rights reserved.
//
#import "HDAgoraCallMember.h"
@protocol HDAgoraCallManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  成员进入会话
 *  @param member  成员
 *
 *  \~english
 *  Member enters session
 *
 */
- (void)onMemberJoin:(HDAgoraCallMember *)member;

/*!
 *  \~chinese
 *  成员离开会话
 *  @param member  成员
 *
 *  \~english
 *  Member exit session
 *
 */
- (void)onMemberExit:(HDAgoraCallMember *)member;

/*!
 *  \~chinese
 *  会话结束
 *  @param desc 描述
 *
 *  \~english
 *  End of the session
 *
 */
- (void)onCallEndReason:(NSString *)desc;

@end
