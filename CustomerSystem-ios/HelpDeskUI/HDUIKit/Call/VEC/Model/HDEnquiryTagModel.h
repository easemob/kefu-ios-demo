//
//  HDEnquiryTagModel.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDEnquiryTagModel : NSObject

@property (nonatomic,copy) NSString *tagId;
@property (nonatomic,copy) NSString *tenantId;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *tagName;
@property (nonatomic,copy) NSString *createDateTime;
@property (nonatomic,copy) NSString *updateDateTime;
@end

NS_ASSUME_NONNULL_END
