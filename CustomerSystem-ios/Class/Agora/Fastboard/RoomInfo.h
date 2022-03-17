//
//  RoomInfo.h
//  OCExample
//
//  Created by xuyunshi on 2022/1/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * RoomInfoKey NS_STRING_ENUM;

extern RoomInfoKey const RoomInfoAPPID;
extern RoomInfoKey const RoomInfoRoomID;
extern RoomInfoKey const RoomInfoRoomToken;

@interface RoomInfo : NSObject
+ (NSString *)getValueFrom: (RoomInfoKey)key;
@end

