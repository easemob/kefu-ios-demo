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
typedef void(^HDConvertCompletionHandlerV5)(BOOL success, WhiteConversionInfoV5 * _Nullable info, NSError * _Nullable error);
typedef void(^HDConvertProgressHandlerV5)(CGFloat progress, WhiteConversionInfoV5 * _Nullable info);

typedef NS_ENUM(NSInteger, HDConverterErrorCodeV5) {
    /** 查询时出错，一般是网络问题，请重启查询服务 */
    HDConverterErrorCodeV5CheckFail   = 50004,
};

/*!
 *  \~chinese
 *   上传文件类型
 */
typedef enum{

    HDFastBoardFileTypeimg = 0,  
    HDFastBoardFileTypepdf,
    HDFastBoardFileTypevideo,
    HDFastBoardFileTypemusic,
    HDFastBoardFileTypeppt,
    HDFastBoardFileTypeword,
    HDFastBoardFileTypeunknown,
}HDFastBoardFileType;
@interface HDStorageItem : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) HDFastBoardFileType  fileType;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *taskUUID;
@property (nonatomic, strong) NSString *taskToken;
@property (nonatomic, strong) WhiteConvertTypeV5 taskType;
@property (nonatomic, strong) WhiteRegionKey region;

@property (nonatomic, weak, nullable) NSURLSessionTask *urlTask;
@property (nonatomic, copy) HDConvertProgressHandlerV5 progressHandler;
@property (nonatomic, copy) HDConvertCompletionHandlerV5 completionHandler;

- (instancetype)initWithTaskUUID:(NSString *)taskUUID
                           token:(NSString *)token
                          region:(WhiteRegionKey)region
                            type:(WhiteConvertTypeV5)type
                 progressHandler:(ConvertProgressHandlerV5)progressHandler
               completionHandler:(ConvertCompletionHandlerV5)completionHandler;
@end

NS_ASSUME_NONNULL_END
