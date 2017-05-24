//
//  HChatClient+call.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import "HChatClient.h"

@interface HChatClient (call)
/*!
 *  \~chinese
 *  实时通讯模块
 *
 *  \~english
 *  call module
 */
@property (nonatomic, strong, readonly) HCall *call;

@end
