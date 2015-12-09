//
//  EMChatSatisfactionBubbleView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatTextBubbleView.h"

extern NSString *const kRouterEventSatisfactionBubbleTapEventName;

@interface EMChatSatisfactionBubbleView : EMChatTextBubbleView

@property (nonatomic, strong) UIButton *satisfactionBtn;

+ (BOOL)isSatisfactionMessage:(EMMessage*)message;

@end
