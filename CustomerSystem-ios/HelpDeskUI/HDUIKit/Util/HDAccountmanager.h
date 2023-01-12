//
//  HDAccountmanager.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/15.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDAccountmanager : NSObject
@property (nonatomic, strong) NSString *appkey;  // 您客服系统中的appkey(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-Appkey)

@property (nonatomic, strong) NSString *cname;  // 您客服系统中的im服务号(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-IM服务号)

@property (nonatomic, strong) NSString *nickname; // 当前登录账号的昵称

@property (nonatomic, strong) NSString *avatarStr; // 当前登录账号的头像url

@property (nonatomic, strong) NSString *username;  // 当前登录账号对应的环信id

@property (nonatomic, strong) NSString *password;   // 当前登录账号对应的环信密码

@property (nonatomic, strong) NSString *tenantId;   // 您客服系统中的关联ID(管理员登录客服系统-管理员模式-设置-企业基本信息-租户ID)

@property (nonatomic, strong) NSString *projectId;  // 您客服系统中的租户ID(管理员登录客服系统-管理员模式-渠道管理-手机APP-关联APP-关联ID)

@property (nonatomic, assign) BOOL isLogged;

+ (instancetype)shareLoginManager;

- (BOOL)loginKefuSDK;

- (HDVisitorInfo *)visitorInfo;

@end

NS_ASSUME_NONNULL_END
