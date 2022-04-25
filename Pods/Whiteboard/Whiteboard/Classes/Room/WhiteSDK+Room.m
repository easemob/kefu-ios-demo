//
//  WhiteSDK+Room.m
//  WhiteSDK
//
//  Created by yleaf on 2019/12/10.
//

#import "WhiteSDK+Room.h"
#import "WhiteSDK+Private.h"
#import "WhiteBoardView+Private.h"
#import "WhiteConsts.h"
#import "WhiteRoom+Private.h"
#import "WhiteRoomCallbacks+Private.h"
#import "WhiteRoom.h"
#import "WhiteSocket.h"
#import "WhiteSocket+Private.h"
#if __has_include ("WhiteRoomConfig+FPA.h")
#import "WhiteFPA.h"
#import "WhiteRoomConfig+FPA.h"
#endif

#if DEBUG
#import "WritableDetectRoom.h"
#endif


@implementation WhiteSDK (Room)

#pragma mark - Room API

- (void)joinRoomWithConfig:(WhiteRoomConfig *)config callbacks:(nullable id<WhiteRoomCallbackDelegate>)callbacks completionHandler:(void (^) (BOOL success, WhiteRoom * _Nullable room, NSError * _Nullable error))completionHandler
{
    NSAssert([config.roomToken length] > 0 && [config.uuid length] > 0, NSLocalizedString(@"room uuid 和 token 不能为空", nil));
    
    //从 WhiteBoardView 父类中解耦
    if (!self.bridge.roomCallbacks) {
        WhiteRoomCallbacks *roomCallbacks = [[WhiteRoomCallbacks alloc] init];
        self.bridge.roomCallbacks = roomCallbacks;
        [self.bridge addJavascriptObject:roomCallbacks namespace:@"room"];
        
#if __has_include ("WhiteRoomConfig+FPA.h")
        if (@available(iOS 13.0, *)) {
            if (config.nativeWebSocket) {
                [WhiteFPA setupFpa:[WhiteFPA defaultFpaConfig] chain:[WhiteFPA defaultChain]];
                WhiteSocket *socket = [[WhiteSocket alloc] initWithBridge:self.bridge];
                [self.bridge addJavascriptObject:socket namespace:@"ws"];
            }
        }
#endif
    }

    
    if (callbacks) {
        self.bridge.roomCallbacks.delegate = callbacks;
    }
    __weak typeof(self.bridge)weakBridge = self.bridge;
    WhiteRoom *room = [[WhiteRoom alloc] initWithUuid:config.uuid bridge:weakBridge];
    self.bridge.roomCallbacks.room = room;
#if DEBUG
    if (config.enableWritableAssert) {
        [WritableDetectRoom startObserveRoom:room];
    }
    
    room.shouldCheckingRepeatSetWritable = config.enableWritableAssert;
#else
    room.shouldCheckingRepeatSetWritable = false;
#endif
    
    [self.bridge callHandler:@"sdk.joinRoom" arguments:@[config] completionHandler:^(id _Nullable value) {
       
        if (completionHandler) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *error = dict[@"__error"];
            if (error) {
                NSString *desc = error[@"message"] ? : @"";
                NSString *description = error[@"jsStack"] ? : @"";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: desc, NSDebugDescriptionErrorKey: description};
                completionHandler(NO, nil, [NSError errorWithDomain:WhiteConstErrorDomain code:-100 userInfo:userInfo]);
            } else {
                room.observerId = dict[@"observerId"];
                room.writable = [dict[@"isWritable"] boolValue];
                [room updateRoomState:[WhiteRoomState modelWithJSON:dict[@"state"]]];
                weakBridge.room = room;
                weakBridge.roomCallbacks.room = room;
                completionHandler(YES, room, nil);
            }
        }
        if (weakBridge.backgroundColor) {
            weakBridge.backgroundColor = weakBridge.backgroundColor;
        }
    }];
}

@end
