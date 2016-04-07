//
//  EMChatTransferBubbleView.h
//  CustomerSystem-ios
//
//  Created by easemob on 16/3/29.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMChatTextBubbleView.h"

/** @brief 转人工客服功能s */

extern NSString *const kRouterEventTransferBubbleTapEventName;

@interface EMChatTransferBubbleView : EMChatTextBubbleView

+ (BOOL)isTransferMessage:(EMMessage*)message;

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object;

@end
