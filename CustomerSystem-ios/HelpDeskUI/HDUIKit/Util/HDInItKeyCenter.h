//
//  HDInItKeyCenter.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/1/9.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDInItKeyCenter : NSObject
@property (nonatomic, strong) NSString *appkey;  // 您客服系统中的appkey(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-Appkey)

@property (nonatomic, strong) NSString *imServiceNum;  // 您客服系统中的im服务号(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-IM服务号)

@property (nonatomic, strong) NSString *tenantId;   // 您客服系统中的关联ID(管理员登录客服系统-管理员模式-设置-企业基本信息-租户ID)

@property (nonatomic, strong) NSString *projectId;  // 您客服系统中的租户ID(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-关联ID)

+ (instancetype)shareInitManager;


- (void)changeAppKey:(NSString *)appKey withTenantId:(NSString *)tenantId;

@end

NS_ASSUME_NONNULL_END
