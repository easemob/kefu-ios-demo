//
//  HTransferIndication.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HCompositeContent.h"
#import "HContent.h"
#import "HAgentInfo.h"

@interface Event: HContent
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* obj;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end

@interface HTransferIndication : HCompositeContent
@property (nonatomic) HAgentInfo * agentInfo;
@property (nonatomic) Event *event;
-(instancetype) initWithContents:(NSMutableDictionary *)obj;
@end


