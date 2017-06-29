//
//  HRobotMenuInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HContent.h"

@interface HRobotMenuInfo : HContent
@property (nonatomic) NSString* title;
@property (nonatomic) NSMutableArray* items;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end

@interface RobotMenuItem : NSObject 
@property (nonatomic) NSString * identity;
@property (nonatomic) NSString * name;

-(instancetype) initWithObject:(NSMutableDictionary *)obj;
@end
