//
//  HDWhiteRoomManager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDWhiteRoomManager.h"
#import "MBProgressHUD+Add.h"
#import "HDWhiteConverterManager.h"
HDRoomInfoKey const HDRoomInfoAPPID = @"appIdentifier";
HDRoomInfoKey const HDRoomInfoRoomID = @"roomUUID";
HDRoomInfoKey const HDRoomInfoRoomToken = @"roomToken";
@interface HDWhiteRoomManager () <FastRoomDelegate,WhiteRoomCallbackDelegate>
{
    FastRoom* _fastRoom;
    NSDictionary * _roomKeyDic;
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
- (void)hd_setValueFrom:(NSDictionary *)roomKeyDic{
    

    _roomKeyDic = roomKeyDic;
    
    
      
}
- (NSString *)hd_getValueFrom:(HDRoomInfoKey)key{
    
    return  _roomKeyDic[key];
    
}
- (void)hd_OnJoinRoomWithFastView:(UIView *)view{
   
    [self setupFastboardWithCustom:nil withFastView:view];
   
}

- (void)hd_joinRoom{
    
    [[HDWhiteboardManager shareInstance] hd_joinWiteBoardRoom];
    
}


// MARK: - Private
- (void)setupFastboardWithCustom: (id<FastRoomOverlay>)custom withFastView:(UIView *)view{
//    常见屏幕比例 其实只有三种 4:3 16:9 16:10 在加上一个特殊的 5:4
    Fastboard.globalFastboardRatio =5.0/4.0 ;
    FastRoomConfiguration* config = [[FastRoomConfiguration alloc] initWithAppIdentifier:[self hd_getValueFrom:HDRoomInfoAPPID] roomUUID:[self hd_getValueFrom:HDRoomInfoRoomID] roomToken:[self hd_getValueFrom:HDRoomInfoRoomToken] region:FastRegionCN userUID:self.uid];
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

    if ([HDWhiteRoomManager shareInstance].roomState == YES) {
        NSLog(@"=====已经在房间==需要退出房间======");
        [[HDWhiteRoomManager shareInstance].fastRoom disconnectRoom];
        [HDWhiteRoomManager shareInstance].roomState = NO;
    }
   
    
}
- (void)whiteBoardUploadFileWithFilePath:(NSString *)filePath fileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(HDFastBoardFileType)type mimeType:(NSString *)mimeType completion:(void (^)(id _Nonnull, HDError * _Nonnull))completion{
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"uploading...", "Upload attachment") toView:_fastRoom.view];
    hud.layer.zPosition = 1.f;
    __weak MBProgressHUD *weakHud = hud;

   
    [[HDClient sharedClient].whiteboardManager whiteBoardUploadFileWithFilePath:filePath fileData:fileData fileName:fileName mimeType:mimeType progress:^(int64_t total, int64_t now) {
        
    
    } completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        [weakHud hideAnimated:YES];
        kWeakSelf
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
           
            NSDictionary *dic = responseObject;
            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                
                NSString * url = [dic valueForKey:@"entity"];
                if (url) {
                    
                    if (type == HDFastBoardFileTypevideo || type == HDFastBoardFileTypeimg) {
                        //不需要转换
                        HDStorageItem * item = [[HDStorageItem alloc] init];
                        item.fileType = type;
                        item.fileName = fileName;
                    
                        item.fileUrl = url;
                        [weakSelf insertItem:item];
                    }else{
                        //需要转换
                        // 调用文档转换
                        NSString * convertType;
                        if (type == HDFastBoardFileTypeppt) {
                            convertType =WhiteConvertTypeDynamic;
                        }else{
                            convertType =WhiteConvertTypeStatic;
                        }
                        [[HDWhiteboardManager shareInstance] hd_wordConverterPptPage:url type:convertType completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
                            if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
                            NSLog(@"=== %@",responseObject);
                            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                                NSDictionary *itemDic = [responseObject valueForKey:@"entity"] ;
                                //组装数据
                                HDStorageItem * item = [[HDStorageItem alloc] init];
                                item.taskUUID = [itemDic valueForKey:@"uuid"];
                                item.taskToken =[itemDic valueForKey:@"token"];
                                item.fileType = type;
                                item.fileName = fileName;
                                if ([[itemDic valueForKey:@"type"] isEqualToString:@"static"]) {
                                    item.taskType = WhiteConvertTypeStatic;
                                }else{
                                    item.taskType = WhiteConvertTypeDynamic;
                                    
                                }
                                //查询文档进度 开始调用轮询
                                
                                HDWhiteConverterManager  * conver = [[HDWhiteConverterManager alloc] init];
                                [conver insertPollingTaskWithTaskUUID:item.taskUUID token:item.taskToken region:item.region taskType:item.taskType progress:^(CGFloat progress, WhiteConversionInfoV5 * _Nullable info) {
                                                                    
                                                                
                                } result:^(BOOL success, WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error) {
                                    
                                    if (success) {
                                        [conver endPolling];
                                        
                                        [weakSelf __urlsignatureWithInsertItem:item withPage:info];
                                        
                                    }
                                    
                                                              
                                }];
                            
                              
                            }
                            
                            }
                        }];
                    }
                    
                }
            }
        }else{
            
           
            
        }
    
    }];

}

- (void)insertItem:(HDStorageItem *)item {
    
    if (item.fileType == HDFastBoardFileTypeimg) {
        [[NSURLSession.sharedSession downloadTaskWithURL:[NSURL URLWithString:item.fileUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) { return ; }
//            NSData* data = [[NSData alloc] initWithContentsOfURL:location];
//            UIImage* img = [UIImage imageWithData:data];
            // 远程图片的路径
            
            [self->_fastRoom insertImg:[NSURL URLWithString:item.fileUrl] imageSize:CGSizeMake(_fastRoom.view.bounds.size.width/2, _fastRoom.view.bounds.size.height/2)];
        }] resume];
    }
    
    if ((item.fileType == HDFastBoardFileTypevideo) || (item.fileType == HDFastBoardFileTypemusic)) {
        [self->_fastRoom insertMedia:[NSURL URLWithString:item.fileUrl] title:item.fileName completionHandler:nil];
        return;
    }
    
    
    
    
//    [WhiteConverterV5 checkProgressWithTaskUUID:item.taskUUID
//                                          token:item.taskToken
//                                         region:item.region
//                                       taskType:item.taskType result:^(WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error) {
//        if (error) { return; }
//        if (!info) { return; }
//
//        NSArray* pages = info.progress.convertedFileList;
//        if (!pages) { return; }
//
//        //如果需要转码 需要调用接口 把url 做一个签名
//        for (WhitePptPage * page in pages) {
//            NSMutableDictionary * mDic = [NSMutableDictionary new];
//            [mDic setValue:page.previewURL.length> 0 ? page.previewURL:@"" forKey:@"previewURL"];
//            [mDic setValue:page.src.length> 0 ? page.src:@"" forKey:@"src"];
//            [mDic setValue:page.src.length> 0 ? page.src:@"" forKey:@"src"];
//            [mDic setValue:[NSString stringWithFormat:@"%f",page.height] forKey:@"height"];
//            [mDic setValue:[NSString stringWithFormat:@"%f",page.height] forKey:@"width "];
//
//            [self __urlsignatureWithInsertItem:item withPage:mDic];
//
//        }
//
//
//    }];
}
- (void)__urlsignatureWithInsertItem:(HDStorageItem*)item withPage:(WhiteConversionInfoV5 *)info{
    NSArray* pages = info.progress.convertedFileList;
           if (!pages) { return; }

            switch (item.fileType) {
                case HDFastBoardFileTypeimg:
                    break;
                case HDFastBoardFileTypepdf:
                    [self->_fastRoom insertStaticDocument:pages
                                                     title:item.fileName completionHandler:nil];
                    break;
                case HDFastBoardFileTypevideo:
                    break;
                case HDFastBoardFileTypemusic:
                    break;
                case HDFastBoardFileTypeppt:
                    if (item.taskType == WhiteConvertTypeDynamic) {
                        [self->_fastRoom insertPptx:pages
                                               title:item.fileName completionHandler:nil];
                    } else {
                        [self->_fastRoom insertStaticDocument:pages
                                                         title:item.fileName completionHandler:nil];
                    }
                    break;
                case HDFastBoardFileTypeword:
                    [self->_fastRoom insertStaticDocument:pages
                                                     title:item.fileName completionHandler:nil];
                    break;
                case HDFastBoardFileTypeunknown:
                    break;
            }
    
        
        

    
    
}
- (FastRoom *)fastRoom{
    
    return _fastRoom;
}
// MARK: - Fastboard Delegate
- (void)fastboard:(Fastboard * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    NSLog(@"error %@", error);
    [HDWhiteRoomManager shareInstance].roomState = NO;
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomFail)]){
        [self.whiteDelegate onFastboardDidJoinRoomSuccess];
    }
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
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomFail)]){
        [self.whiteDelegate onFastboardDidJoinRoomFail];
    }
}
// MARK: - WhiteRoomCallbackDelegate
-(void)fireRoomStateChanged:(WhiteRoomState *)modifyState{

    NSLog(@"fireRoomStateChanged = %@",modifyState);
}


@end
