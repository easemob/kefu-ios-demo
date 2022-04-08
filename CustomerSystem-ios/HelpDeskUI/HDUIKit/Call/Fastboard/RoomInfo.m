//
//  RoomInfo.m
//  OCExample
//
//  Created by xuyunshi on 2022/1/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "RoomInfo.h"

RoomInfoKey const RoomInfoAPPID = @"APPID";
RoomInfoKey const RoomInfoRoomID = @"ROOMUUID";
RoomInfoKey const RoomInfoRoomToken = @"ROOMTOKEN";

@implementation RoomInfo

+ (NSString *)getValueFrom:(RoomInfoKey)key {
    NSDictionary* bundleDictionary = @{
        @"APPID":@"283/VGiScM9Wiw2HJg",
        @"ROOMUUID":@"b8a446f06a0411ec8c31196f2bc4a1de",
        @"ROOMTOKEN":@"WHITEcGFydG5lcl9pZD15TFExM0tTeUx5VzBTR3NkJnNpZz1mZTU3ZTVkNWRlM2Y0NDNlZjNjZjA2MjlhYzExZGY0ZTJlZjhhMzUzOmFrPXlMUTEzS1N5THlXMFNHc2QmY3JlYXRlX3RpbWU9MTY0MDkzMjkwNTQ1NCZleHBpcmVfdGltZT0xNjcyNDY4OTA1NDU0Jm5vbmNlPTE2NDA5MzI5MDU0NTQwMCZyb2xlPXJvb20mcm9vbUlkPWI4YTQ0NmYwNmEwNDExZWM4YzMxMTk2ZjJiYzRhMWRlJnRlYW1JZD05SUQyMFBRaUVldTNPNy1mQmNBek9n"
        
    };
    return bundleDictionary[key];
}

@end
