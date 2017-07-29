//
//  MockData.m
//  CustomerSystem-ios
//
//  Created by afanda on 7/28/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "MockData.h"

@implementation MockData
+(NSString *)getTestTicket{
    NSMutableDictionary * testTicketDict = [NSMutableDictionary dictionary];
    [testTicketDict setObject: @"wss://turn2.easemob.com/ws" forKey:@"url"];
    
    [testTicketDict setObject: @"tkt01" forKey:@"tktId"];
    [testTicketDict setObject: @"CONFR" forKey:@"type"];
    [testTicketDict setObject: @"fanxiaoning" forKey:@"memName"];
    [testTicketDict setObject: @"MS1000C11" forKey:@"confrId"];
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject: testTicketDict options:0 error:&error];
    NSString * json = [[NSString alloc] initWithData: jsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (EMediaPublishConfiguration *)getConfig {
    EMediaPublishConfiguration *config = [EMediaPublishConfiguration new];
    config.videoOff = YES;
    config.mute = YES;
    config.extension = @"";
    return config;
}

@end
