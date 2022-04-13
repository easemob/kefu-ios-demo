//
//  HDWhiteRoomManager.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fastboard/Fastboard-Swift.h>
#import <Whiteboard/Whiteboard.h>
#import "HDWhiteBoardDelegete.h"
#import "RoomInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDWhiteRoomManager : NSObject
//加入房间的状态 yes 加入成功 no 加入失败
@property (nonatomic, assign) BOOL  roomState;
@property (nonatomic, strong) FastRoom *fastRoom;
@property (nonatomic, weak) id <HDWhiteBoardDelegete> whiteDelegate;
+ (instancetype _Nullable )shareInstance;
// 创建房间 view 房间展示在哪个view上
- (void)hd_OnJoinRoomWithFastView:(UIView *)view;
//推出房间
- (void)hd_OnLogout;

@end

NS_ASSUME_NONNULL_END
