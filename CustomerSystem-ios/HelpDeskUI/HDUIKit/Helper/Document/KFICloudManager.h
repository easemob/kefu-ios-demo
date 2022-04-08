//
//  iCloudManager.h
//  HLtest
//
//  Created by houli on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^downloadBlock)(id obj);
@interface KFICloudManager : NSObject
+ (BOOL)iCloudEnable;

+ (void)downloadWithDocumentURL:(NSURL*)url callBack:(downloadBlock)block;
@end

NS_ASSUME_NONNULL_END
