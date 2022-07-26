//
//  HDEnquiryOptionModel.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/11.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDEnquiryOptionModel : NSObject
@property (nonatomic,copy) NSString *optionId;
@property (nonatomic,copy) NSString *lastUpdateDateTime;
@property (nonatomic,copy) NSString *createDateTime;
@property (nonatomic,copy) NSString *optionName;
@property (nonatomic,copy) NSString *optionValue;
@property (nonatomic,copy) NSString *tenantId;



@end

NS_ASSUME_NONNULL_END
