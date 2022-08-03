//
//  WhiteRoom+Private.h
//  WhiteSDK
//
//  Created by yleaf on 2019/7/23.
//

#import "WhiteRoom.h"
#import "ApplePencilDrawHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteRoom ()

@property (nonatomic, strong, readwrite) ApplePencilDrawHandler *applePencilDrawHandler;
@property (nonatomic, strong, readwrite) NSNumber *observerId;
@property (nonatomic, assign, readwrite, getter=isWritable) BOOL writable;
@property (nonatomic, assign) BOOL shouldCheckingRepeatSetWritable;
@property (nonatomic, assign) BOOL isUpdatingWritable;
@property (nonatomic, assign) uint8_t reloadFromMemoryIssueTimes;
// JS 暂时无法发送日志，先将日志保存到这里。等 JS 恢复之后再将日志发送。
@property (nonatomic, copy) NSMutableArray<NSString *>* unsentNativeLogs;

- (instancetype)initWithUuid:(NSString *)uuid bridge:(WhiteBoardView *)bridge;
- (void)updatePhase:(WhiteRoomPhase)phase;
- (void)updateRoomState:(WhiteRoomState *)state;
- (void)prepareForApplePencilDrawOnly:(BOOL)drawOnly;

@end

NS_ASSUME_NONNULL_END
