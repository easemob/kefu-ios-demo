//
//  HMessage+Content.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/6/14.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMessage.h"
#import "ControlMessage.h"
#import "RobotMenuInfo.h"
#import "TransferIndication.h"
#import "AgentInfo.h"
#import "OrderInfo.h"
#import "VisitorTrack.h"


@interface HMessage (Content)
- (void)addContent:(HContent *)content;
- (void)addCompositeContent:(HCompositeContent *)content;

-(ControlMessage *) getEvalRequest;
-(ControlMessage *) getEvalResponse;
-(RobotMenuInfo *) getRobotMenu;
-(TransferIndication *) getTransferIndication;
-(OrderInfo *) getOrderInfo;
-(AgentInfo *) getAgentInfo;
-(VisitorTrack *) getVisitorTrack;
@end
