//
//  WhiteRoomConfig.m
//  WhiteSDK
//
//  Created by yleaf on 2019/3/30.
//

#import "WhiteRoomConfig.h"
#import "WhiteConsts.h"


@interface WhiteRoomConfig ()

@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *roomToken;
@property (nonatomic, copy, readwrite) NSString *uid;

@end

@implementation WhiteRoomConfig


- (instancetype)init
{
    NSAssert(false, @"please never use this method.");
    return [self initWithUUID:nil roomToken:nil uid:@"" userPayload:nil];
}

- (instancetype)initWithUUID:(NSString *)uuid roomToken:(NSString *)roomToken uid:(NSString *)uid
{
    return [self initWithUUID:uuid roomToken:roomToken uid:uid userPayload:nil];
}

- (instancetype)initWithUUID:(NSString *)uuid roomToken:(NSString *)roomToken uid:(NSString *)uid userPayload:(id _Nullable)userPayload
{
    if (self = [super init]) {
        _uuid = uuid;
        _roomToken = roomToken;
        _userPayload = userPayload;
        _timeout = @45;
        _isWritable = true;
        _uid = uid;
        _disableNewPencil = true;
        _enableWritableAssert = false;
        _drawOnlyApplePencil = false;
        if (_userPayload) {
            NSDictionary *dict = @{@"key": _userPayload};
            if (![NSJSONSerialization isValidJSONObject:dict]) {
                
            }
        }
    }
    return self;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    dic[@"timeout"] = @([self.timeout floatValue] * WhiteConstTimeUnitRatio);
    return true;
}

- (void)setDisableOperations:(BOOL)disableOperations
{
    _disableOperations = disableOperations;
    _disableDeviceInputs = disableOperations;
    _disableCameraTransform = disableOperations;
}

#if __has_include("WhiteRoomConfig+FPA.h")
- (void)setNativeWebSocket:(BOOL)nativeWebSocket {
    if (@available(iOS 13.0, *)) {
        _nativeWebSocket = nativeWebSocket;
    } else {
        _nativeWebSocket = NO;
    }
}
#endif

@end
