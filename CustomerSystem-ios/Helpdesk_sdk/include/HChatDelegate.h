//
//  ChatDelegate.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HChatDelegate<NSObject>
- (void)didReceiveMessages:(NSArray *)aMessages;

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages;

@end
