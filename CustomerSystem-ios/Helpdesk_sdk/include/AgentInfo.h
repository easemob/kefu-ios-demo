//
//  AgentInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HContent.h"

@interface AgentInfo : HContent
@property (nonatomic) NSString* nickName;
@property (nonatomic) NSString* avatar;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end
