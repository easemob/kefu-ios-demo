//
//  HDStorageItem.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/7.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Whiteboard/Whiteboard.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^HDVECConvertCompletionHandlerV5)(BOOL success, WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error);
typedef void(^HDVECConvertProgressHandlerV5)(CGFloat progress, WhiteConversionInfoV5 * _Nullable info);

typedef NS_ENUM(NSInteger, HDVECConverterErrorCodeV5) {
    /** 查询时出错，一般是网络问题，请重启查询服务 */
    HDVECConverterErrorCodeV5CheckFail   = 50004,
};

/*!
 *  \~chinese
 *   上传文件类型
 */
typedef enum{

    HDVECFastBoardFileTypeimg = 0,  
    HDVECFastBoardFileTypepdf,
    HDVECFastBoardFileTypevideo,
    HDVECFastBoardFileTypemusic,
    HDVECFastBoardFileTypeppt,
    HDVECFastBoardFileTypeword,
    HDVECFastBoardFileTypeunknown,
}HDVECFastBoardFileType;
@interface HDVECStorageItem : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) HDVECFastBoardFileType  fileType;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *taskUUID;
@property (nonatomic, strong) NSString *taskToken;
@property (nonatomic, strong) WhiteConvertTypeV5 taskType;
@property (nonatomic, strong) WhiteRegionKey region;

@property (nonatomic, weak, nullable) NSURLSessionTask *urlTask;
@property (nonatomic, copy) HDVECConvertProgressHandlerV5 progressHandler;
@property (nonatomic, copy) HDVECConvertCompletionHandlerV5 completionHandler;

- (instancetype)initWithTaskUUID:(NSString *)taskUUID
                           token:(NSString *)token
                          region:(WhiteRegionKey)region
                            type:(WhiteConvertTypeV5)type
                 progressHandler:(ConvertProgressHandlerV5)progressHandler
               completionHandler:(ConvertCompletionHandlerV5)completionHandler;
@end

NS_ASSUME_NONNULL_END
