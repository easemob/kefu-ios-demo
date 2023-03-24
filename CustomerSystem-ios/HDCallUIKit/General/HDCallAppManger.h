//
//  HDCallAppManger.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/3/24.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCallAppManger : NSObject
+ (instancetype _Nullable )shareInstance;

- (NSDictionary *)dictWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
