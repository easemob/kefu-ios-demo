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
#import "HDStorageItem.h"
NS_ASSUME_NONNULL_BEGIN
typedef NSString * HDRoomInfoKey NS_STRING_ENUM;

extern HDRoomInfoKey const HDRoomInfoAPPID;
extern HDRoomInfoKey const HDRoomInfoRoomID;
extern HDRoomInfoKey const HDRoomInfoRoomToken;
@interface HDWhiteRoomManager : NSObject
//加入房间的状态 yes 加入成功 no 加入失败
@property (nonatomic, assign) BOOL  roomState;
@property (nonatomic, strong) FastRoom *fastRoom;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, weak) id <HDWhiteBoardDelegete> whiteDelegate;
+ (instancetype _Nullable )shareInstance;
- (void)hd_setValueFrom:(NSDictionary *)roomKeyDic;
// 创建房间 view 房间展示在哪个view上
- (void)hd_OnJoinRoomWithFastView:(UIView *)view;
- (void)hd_joinRoom;
- (void)hd_joinVECRoom;
- (void)reloadFastboardOverlayWithView:(UIView *)view;

//推出房间
- (void)hd_OnLogout;
// 插入
- (void)insertItem:(HDStorageItem *)item;

- (void)whiteBoardUploadFileWithFilePath:(nonnull NSString *)filePath fileData:(nonnull NSData *)fileData fileName:(nonnull NSString *)fileName fileType:(HDFastBoardFileType)type mimeType:(NSString *)mimeType completion:(nonnull void (^)(id _Nonnull responseObject, HDError * _Nonnull error))completion;



@end

NS_ASSUME_NONNULL_END
