//
//  HDWhiteRoomManager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDWhiteRoomManager.h"

@interface HDWhiteRoomManager () <FastRoomDelegate,WhiteRoomCallbackDelegate>
{
    FastRoom* _fastRoom;
}
@end
static HDWhiteRoomManager *shareWhiteboard = nil;
@implementation HDWhiteRoomManager
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWhiteboard = [[HDWhiteRoomManager alloc] init];
       
    });
    return shareWhiteboard;
}

- (void)hd_OnJoinRoomWithFastView:(UIView *)view{
    //初始化
    [self setupFastboardWithCustom:nil withFastView:view];
}

// MARK: - Private
- (void)setupFastboardWithCustom: (id<FastRoomOverlay>)custom withFastView:(UIView *)view{
//    常见屏幕比例 其实只有三种 4:3 16:9 16:10 在加上一个特殊的 5:4
    Fastboard.globalFastboardRatio =5.0/4.0 ;
    FastRoomConfiguration* config = [[FastRoomConfiguration alloc] initWithAppIdentifier:[RoomInfo getValueFrom:RoomInfoAPPID]
                                                                                roomUUID:[RoomInfo getValueFrom:RoomInfoRoomID]
                                                                               roomToken:[RoomInfo getValueFrom:RoomInfoRoomToken]
                                                                                  region:FastRegionCN
                                                                                 userUID:@"some-unique-logout"];
    config.customOverlay = custom;
    _fastRoom = [Fastboard createFastRoomWithFastRoomConfig:config];
    FastRoomView *fastRoomView = _fastRoom.view;
    fastRoomView.backgroundColor = [UIColor whiteColor];
    _fastRoom.delegate = self;
    [_fastRoom joinRoom];
    [view addSubview:fastRoomView];
    view.autoresizesSubviews = TRUE;
    [fastRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
    [fastRoomView layoutIfNeeded];
    fastRoomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _fastRoom.roomDelegate = self;
    
    [FastRoomThemeManager.shared apply:FastRoomDefaultTheme.defaultAutoTheme];
}
//推出房间
- (void)hd_OnLogout {

    NSLog(@"=====点击了退出房间");
    if ([HDWhiteRoomManager shareInstance].roomState == YES) {
        NSLog(@"=====已经在房间==需要退出房间======");
        [[HDWhiteRoomManager shareInstance].fastRoom disconnectRoom];
        [HDWhiteRoomManager shareInstance].roomState = NO;
    }
   
    
}
- (FastRoom *)fastRoom{
    
    return _fastRoom;
}
// MARK: - Fastboard Delegate
- (void)fastboard:(Fastboard * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    NSLog(@"error %@", error);
    [HDWhiteRoomManager shareInstance].roomState = NO;
}

- (void)fastboardPhaseDidUpdate:(Fastboard * _Nonnull)fastboard phase:(enum FastRoomPhase)phase {
    NSLog(@"phase, %d", (int)phase);
}

- (void)fastboardUserKickedOut:(Fastboard * _Nonnull)fastboard reason:(NSString * _Nonnull)reason {
    NSLog(@"kicked out");
}

- (void)fastboardDidJoinRoomSuccess:(FastRoom * _Nonnull)fastboard room:(WhiteRoom * _Nonnull)room {
  
    NSLog(@"fastboardDidJoinRoomSuccess = %@ == %@",fastboard.room.uuid,fastboard.room.roomMembers);
    
  
    [HDWhiteRoomManager shareInstance].roomState = YES;
    
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomSuccess)]){
        [self.whiteDelegate onFastboardDidJoinRoomSuccess];
    }
    
}
- (void)fastboardDidOccurError:(FastRoom * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    NSLog(@"fastboardDidOccurError");
    [HDWhiteRoomManager shareInstance].roomState = NO;
}
// MARK: - WhiteRoomCallbackDelegate
-(void)fireRoomStateChanged:(WhiteRoomState *)modifyState{

    NSLog(@"fireRoomStateChanged = %@",modifyState);
}


@end
