//
//  HDCloudDiskModel.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDVECStorageItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDVECCloudDiskModel : NSObject
@property (nonatomic, assign) HDVECFastBoardFileType fileType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *uploadDate;
@property (nonatomic, strong) NSString *fileSize;

@end

NS_ASSUME_NONNULL_END
