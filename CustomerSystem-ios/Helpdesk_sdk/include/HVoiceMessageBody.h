//
//  HVoiceMessageBody.h
//  helpdesk_sdk
//
//  Created by __阿彤木_ on 1/3/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import "HFileMessageBody.h"
/*!
 *  \~chinese
 *  语音消息体
 *
 *  \~english
 *  Voice message body
 */
@interface HVoiceMessageBody : HFileMessageBody
/*!
 *  \~chinese
 *  语音时长, 秒为单位
 *
 *  \~english
 *  Voice duration, in seconds
 */
@property (nonatomic) int duration;

@property(nonatomic,strong) EMVoiceMessageBody *voiceMessageBody;

@end
