//
//  HControlMessage.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HCompositeContent.h"
#import "HContent.h"

FOUNDATION_EXPORT NSString * const TYPE_EVAL_REQUEST;
FOUNDATION_EXPORT NSString * const TYPE_EVAL_RESPONSE;
FOUNDATION_EXPORT NSString * const TYPE_TRANSFER_TO_AGENT;


@interface ControlType : HContent

@property (nonatomic) NSString * ctrlType;

-(instancetype) initWithValue:(NSString *)value;

@end

@interface ControlArguments : HContent
@property (nonatomic) NSString* identity;
@property (nonatomic) NSString* sessionId;
@property (nonatomic) NSString* label;
@property (nonatomic) NSString* detail;
@property (nonatomic) NSString* summary;
@property (nonatomic) NSString* inviteId;
@end

@interface HControlMessage : HCompositeContent

@property (nonatomic) ControlType *type;
@property (nonatomic) ControlArguments *arguments;

@end

