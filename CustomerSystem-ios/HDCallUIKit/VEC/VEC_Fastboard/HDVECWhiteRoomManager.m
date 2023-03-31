//
//  HDWhiteRoomManager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVECWhiteRoomManager.h"
#import "MBProgressHUD+Add.h"
#import "HDVECWhiteConverterManager.h"
#import "HDVECAgoraCallManager.h"
HDVECRoomInfoKey const HDVECRoomInfoAPPID = @"appIdentifier";
HDVECRoomInfoKey const HDVECRoomInfoRoomID = @"roomUUID";
HDVECRoomInfoKey const HDVECRoomInfoRoomToken = @"roomToken";
@interface HDVECWhiteRoomManager () <FastRoomDelegate,WhiteRoomCallbackDelegate>
{
    FastRoom* _fastRoom;
    NSDictionary * _roomKeyDic;
    UIView *_subView;
}
@end
static HDVECWhiteRoomManager *shareWhiteboard = nil;
@implementation HDVECWhiteRoomManager
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWhiteboard = [[HDVECWhiteRoomManager alloc] init];
       
    });
    return shareWhiteboard;
}
- (void)hd_setValueFrom:(NSDictionary *)roomKeyDic{
    

    _roomKeyDic = roomKeyDic;
    
    
      
}
- (NSString *)hd_getValueFrom:(HDVECRoomInfoKey)key{
    
    return  _roomKeyDic[key];
    
}
- (void)hd_OnJoinRoomWithFastView:(UIView *)view{
   
    _subView = view;
    [self setupFastboardWithCustom:nil withFastView:view];
   
}

- (void)hd_joinRoom{
    
    [[HDWhiteboardManager shareInstance] hd_joinWiteBoardRoom];
    
}
- (void)hd_joinVECRoom{
    
    [[HDWhiteboardManager shareInstance] vec_joinWiteBoardRoom:[HDVECAgoraCallManager shareInstance].vec_imServiceNum];
    
}
- (void)reloadFastboardOverlayWithView:(UIView *)view{
   
        Fastboard.globalFastboardRatio =0.8;
        [_fastRoom.room setContainerSizeRatio:@1];
    [_fastRoom.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
        [_fastRoom.view setNeedsLayout];
        [_fastRoom.view layoutIfNeeded];
    

}
// MARK: - Private
- (void)setupFastboardWithCustom: (id<FastRoomOverlay>)custom withFastView:(UIView *)view{
    
//    常见屏幕比例 其实只有三种 4:3 16:9 16:10 在加上一个特殊的 5:4
    Fastboard.globalFastboardRatio = 5.0/4.0 ;
    FastRoomConfiguration* config = [[FastRoomConfiguration alloc] initWithAppIdentifier:[self hd_getValueFrom:HDVECRoomInfoAPPID] roomUUID:[self hd_getValueFrom:HDVECRoomInfoRoomID] roomToken:[self hd_getValueFrom:HDVECRoomInfoRoomToken] region:FastRegionCN userUID:self.uid];
//    config.whiteRoomConfig.windowParams.chessboard = YES;
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
    [_fastRoom.view setNeedsLayout];
    [_fastRoom.view layoutIfNeeded];
    fastRoomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _fastRoom.roomDelegate = self;
    
    if (@available(iOS 13.0, *)) {
        //这个代码是自动判断暗黑模式的代码
        [FastRoomThemeManager.shared apply:FastRoomDefaultTheme.defaultAutoTheme];
        
    } else {
        // Fallback on earlier versions
    }
   
}
//推出房间
- (void)hd_OnLogout {

    if ([HDVECWhiteRoomManager shareInstance].roomState == YES) {
        [HDLog logD:@"HD===%s ==已经在房间==需要退出房间===",__func__];
        [[HDVECWhiteRoomManager shareInstance].fastRoom disconnectRoom];
        [HDVECWhiteRoomManager shareInstance].roomState = NO;
    }
   
    
}
- (void)whiteBoardUploadFileWithFilePath:(NSString *)filePath fileData:(NSData *)fileData fileName:(NSString *)fileName fileType:(HDVECFastBoardFileType)type mimeType:(NSString *)mimeType completion:(void (^)(id _Nonnull, HDError * _Nonnull))completion{
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"uploading...", "Upload attachment") toView:_fastRoom.view];
    hud.layer.zPosition = 1.f;
    __weak MBProgressHUD *weakHud = hud;

   
    [[HDClient sharedClient].whiteboardManager whiteBoardUploadFileWithFilePath:filePath fileData:fileData fileName:fileName mimeType:mimeType progress:^(int64_t total, int64_t now) {
        
    
    } completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
        [weakHud hideAnimated:YES ];
        
        kWeakSelf
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            [MBProgressHUD  dismissInfo:NSLocalizedString(@"success!", "success!") withWindow:[UIApplication sharedApplication].keyWindow];
            if (completion) {
                //上传成功 删除文件
                completion(responseObject,error);
            }
            
            NSDictionary *dic = responseObject;
            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                
                NSString * url = [dic valueForKey:@"entity"];
                if (url) {
                    
                    if (type == HDVECFastBoardFileTypevideo || type == HDVECFastBoardFileTypeimg) {
                        //不需要转换
                        HDVECStorageItem * item = [[HDVECStorageItem alloc] init];
                        item.fileType = type;
                        item.fileName = fileName;
                    
                        item.fileUrl = url;
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                              //todo
                            [weakSelf insertItem:item];
                        });
                        
                    }else{
                        //需要转换
                        // 调用文档转换
                        NSString * convertType;
                        if (type == HDVECFastBoardFileTypeppt) {
                            convertType =WhiteConvertTypeDynamic;
                        }else{
                            convertType =WhiteConvertTypeStatic;
                        }
                        
                        [[HDWhiteboardManager shareInstance] hd_wordConverterPptPage:url type:convertType completion:^(id  _Nonnull responseObject, HDError * _Nonnull error) {
                            if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
                            NSLog(@"=== %@",responseObject);
                                [HDLog logD:@"HD===%s ==responseObject==%@",__func__,responseObject];
                            if ([[dic allKeys] containsObject:@"status"] && [[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
                                NSDictionary *itemDic = [responseObject valueForKey:@"entity"] ;
                                //组装数据
                                HDVECStorageItem * item = [[HDVECStorageItem alloc] init];
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
                                HDVECWhiteConverterManager  * conver = [[HDVECWhiteConverterManager alloc] init];
                                [conver insertPollingTaskWithTaskUUID:item.taskUUID token:item.taskToken region:item.region taskType:item.taskType progress:^(CGFloat progress, WhiteConversionInfoV5 * _Nullable info) {
                                                                    
                                                                
                                } result:^(BOOL success, WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error) {
                                    
                                    if (success) {
                                        [conver endPolling];
                                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                                              //todo
                                            [weakSelf __urlsignatureWithInsertItem:item withPage:info];
                                        });
                                        
                                        
                                    }else{
                                        if ([info.status isEqualToString:WhiteConvertStatusV5Fail]) {
                                            [MBProgressHUD  dismissInfo:NSLocalizedString(@"video.whiteboardConvertFail", "video.whiteboardConvertFail")  withWindow:[UIApplication sharedApplication].keyWindow];
                                            [conver endPolling];
                                        }
                                        
                                        
                                    }
                                    
                                                              
                                }];
                            
                              
                            }
                            
                            }
                        }];
                    }
                    
                }
            }
        }else{
            
            [MBProgressHUD  dismissInfo:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment.failed", "leaveMessage.leavemsg.uploadattachment.failed")  withWindow:[UIApplication sharedApplication].keyWindow];
            
        }
    
    }];

}

- (void)insertItem:(HDVECStorageItem *)item {
    
    if (item.fileType == HDVECFastBoardFileTypeimg) {
        [[NSURLSession.sharedSession downloadTaskWithURL:[NSURL URLWithString:item.fileUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) { return ; }
//            NSData* data = [[NSData alloc] initWithContentsOfURL:location];
//            UIImage* img = [UIImage imageWithData:data];
            // 远程图片的路径
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                  //todo
                [self->_fastRoom insertImg:[NSURL URLWithString:item.fileUrl] imageSize:CGSizeMake(_fastRoom.view.bounds.size.width/2, _fastRoom.view.bounds.size.height/2)];
            });
           
        }] resume];
    }
    
    if ((item.fileType == HDVECFastBoardFileTypevideo) || (item.fileType == HDVECFastBoardFileTypemusic)) {
        [self->_fastRoom insertMedia:[NSURL URLWithString:item.fileUrl] title:item.fileName completionHandler:nil];
        return;
    }
}
- (void)__urlsignatureWithInsertItem:(HDVECStorageItem*)item withPage:(WhiteConversionInfoV5 *)info{
    NSArray* pages = info.progress.convertedFileList;
           if (!pages) { return; }

            switch (item.fileType) {
                case HDVECFastBoardFileTypeimg:
                    break;
                case HDVECFastBoardFileTypepdf:
                    [self->_fastRoom insertStaticDocument:pages
                                                     title:item.fileName completionHandler:nil];
                    break;
                case HDVECFastBoardFileTypevideo:
                    break;
                case HDVECFastBoardFileTypemusic:
                    break;
                case HDVECFastBoardFileTypeppt:
                    if (item.taskType == WhiteConvertTypeDynamic) {
                        [self->_fastRoom insertPptx:pages
                                               title:item.fileName completionHandler:nil];
                    } else {
                        [self->_fastRoom insertStaticDocument:pages
                                                         title:item.fileName completionHandler:nil];
                    }
                    break;
                case HDVECFastBoardFileTypeword:
                    [self->_fastRoom insertStaticDocument:pages
                                                     title:item.fileName completionHandler:nil];
                    break;
                case HDVECFastBoardFileTypeunknown:
                    break;
            }
    
        
        

    
    
}
- (FastRoom *)fastRoom{
    
    return _fastRoom;
}
// MARK: - Fastboard Delegate
- (void)fastboard:(Fastboard * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    [HDLog logE:@"HD===%s ==error %@",__func__,error];
    [HDVECWhiteRoomManager shareInstance].roomState = NO;
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomFail)]){
        [self.whiteDelegate onFastboardDidJoinRoomSuccess];
    }
}

- (void)fastboardPhaseDidUpdate:(Fastboard * _Nonnull)fastboard phase:(enum FastRoomPhase)phase {
    NSLog(@"phase, %d", (int)phase);
    [HDLog logD:@"HD===%s phase, %d",__func__,(int)phase];
}

- (void)fastboardUserKickedOut:(Fastboard * _Nonnull)fastboard reason:(NSString * _Nonnull)reason {

    [HDLog logD:@"HD===%s kicked out",__func__];
}

- (void)fastboardDidJoinRoomSuccess:(FastRoom * _Nonnull)fastboard room:(WhiteRoom * _Nonnull)room {
  
    [HDLog logD:@"HD===%s fastboardDidJoinRoomSuccess = %@ == %@",__func__,fastboard.room.uuid,fastboard.room.roomMembers];
    [HDVECWhiteRoomManager shareInstance].roomState = YES;
    
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomSuccess)]){
        [self.whiteDelegate onFastboardDidJoinRoomSuccess];
    }
    
}
- (void)fastboardDidOccurError:(FastRoom * _Nonnull)fastboard error:(FastRoomError * _Nonnull)error {
    [HDLog logD:@"HD===%s fastboardDidOccurError",__func__];
    [HDVECWhiteRoomManager shareInstance].roomState = NO;
    //通知代理
    if([self.whiteDelegate respondsToSelector:@selector(onFastboardDidJoinRoomFail)]){
        [self.whiteDelegate onFastboardDidJoinRoomFail];
    }
}
// MARK: - WhiteRoomCallbackDelegate
-(void)fireRoomStateChanged:(WhiteRoomState *)modifyState{

    [HDLog logD:@"HD===%s fireRoomStateChanged = %@",__func__,modifyState];
}


@end