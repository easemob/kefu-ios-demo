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


@end

NS_ASSUME_NONNULL_END
