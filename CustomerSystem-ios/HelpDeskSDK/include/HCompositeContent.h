//
//  HCompositeContent.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCompositeContent : NSObject

@property (nonatomic)NSMutableArray* contents;

-(instancetype) initWithContents:(NSMutableDictionary *)obj;


-(BOOL)isNull;
-(NSMutableArray *)getContents;


-(NSString *)getParentName;
@end
