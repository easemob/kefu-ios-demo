//
//  HDStorageItem.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/7.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDStorageItem.h"

@implementation HDStorageItem

- (instancetype)initWithTaskUUID:(NSString *)taskUUID
                           token:(NSString *)token
                          region:(WhiteRegionKey)region
                            type:(WhiteConvertTypeV5)type
                 progressHandler:(ConvertProgressHandlerV5)progressHandler
               completionHandler:(ConvertCompletionHandlerV5)completionHandler
{
    if (self = [super init]) {
        self.taskUUID = taskUUID;
        self.taskToken = token;
        self.region = region;
        self.taskType = type;
        self.progressHandler = progressHandler;
        self.completionHandler = completionHandler;
    }
    return self;
}
@end
