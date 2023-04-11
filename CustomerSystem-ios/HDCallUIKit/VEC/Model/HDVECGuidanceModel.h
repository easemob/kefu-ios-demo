//
//  HDVECGuidanceModel.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/4/11.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVECGuidanceModel : NSObject
@property (nonatomic, strong) NSString *vec_configid;
@property (nonatomic, strong) NSString *vec_imServiceNum;
@property (nonatomic, strong) NSString *vec_cecSessionId; // cec的会话id
@property (nonatomic, strong) NSString *vec_cecVisitorId; // cec的访客id
@end

NS_ASSUME_NONNULL_END
