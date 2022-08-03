//
//  WhiteBoardView+Private.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import "WhiteBoardView.h"

@class WhiteRoomCallbacks, WhitePlayerEvent, WhiteCommonCallbacks, WhiteSdkConfiguration;

@interface WhiteBoardView ()

@property (nonatomic, strong, nullable) WhiteRoomCallbacks *roomCallbacks;
@property (nonatomic, strong, nullable) WhitePlayerEvent *playerEvent;
@property (nonatomic, strong, nullable) WhiteCommonCallbacks *commonCallbacks;

- (void)setupWebSDKWithConfig:(WhiteSdkConfiguration *_Nonnull)config completion:(void (^_Nullable) (id _Nullable value))completionHandler;

// 从 Crash 的状态中恢复回来。一般是内存原因导致的 WebKit 被 kill
// 这个方法会重置callInfoList, 并且将指定记录过的 js call 重新回放一遍
- (void)reloadFromCrash:(void (^__nullable)(void))completionHandler;

@end
