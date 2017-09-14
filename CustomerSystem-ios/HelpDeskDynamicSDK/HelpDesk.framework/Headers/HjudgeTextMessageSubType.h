//
//  HjudgeTextMessageSubType.h
//  helpdesk_sdk
//
//  Created by afanda on 1/18/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>


__attribute__((deprecated("已过期, 请使用HMessageHelper ")))
@interface HjudgeTextMessageSubType : NSObject

+ (BOOL)isTrackMessage:(HMessage *)message;     //轨迹消息
+ (BOOL)isOrderMessage:(HMessage *)message;     //订单消息
+ (BOOL)isMenuMessage:(HMessage *)message;      //菜单消息
+ (BOOL)isTransferMessage:(HMessage *)message;  //转接客服消息
+ (BOOL)isEvaluateMessage:(HMessage *)message;  //满意度评价消息
+ (BOOL)isFormMessage:(HMessage *)message; //机器人表单消息

@end
