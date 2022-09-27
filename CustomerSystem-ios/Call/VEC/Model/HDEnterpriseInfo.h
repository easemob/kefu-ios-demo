//
//  HDEnterpriseInfo.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/8/1.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDEnterpriseInfo : NSObject
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *agentMaxEnableNum;
@property (nonatomic,copy) NSString *agentMaxNum;
@property (nonatomic,copy) NSString *agentMaxOnlineNum;
@property (nonatomic,copy) NSString *agreementExpireTime;
@property (nonatomic,copy) NSString *allAgentMaxEnableNum;

@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *crateDateTime;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,copy) NSString *isExperience;
@property (nonatomic,copy) NSString *language;
@property (nonatomic,copy) NSString *lastUpdateDateTime;

@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *organId;

@property (nonatomic,copy) NSString *organName;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *serviceLevel;

@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *tenantId;
@property (nonatomic,copy) NSString *ticketAgentMaxEnableNum;
@property (nonatomic,copy) NSString *timeZone;

@end

NS_ASSUME_NONNULL_END
