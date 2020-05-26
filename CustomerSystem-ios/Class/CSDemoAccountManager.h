//
//  CSDemoAccountManager.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDChatViewController.h"

@interface HEmojiPackage :NSObject 
//表情包id
@property (nonatomic,copy) NSString *packageId;
//表情包名字
@property (nonatomic,copy) NSString *packageName;
//表情数
@property (nonatomic,assign) NSInteger emojiNum;
//tenantId
@property (nonatomic,copy) NSString *tenantId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface HEmoji :NSObject

@property (nonatomic,copy) NSString *emojiName;

@property (nonatomic,copy) NSString *originUrl;

@property (nonatomic,copy) NSString *originMediaId;

@property (nonatomic,copy) NSString *originLocalPath;

@property (nonatomic,copy) NSString *thumbnailUrl;

@property (nonatomic,copy) NSString *thumbnailMediaId;

@property (nonatomic,copy) NSString *thumbnailLocalPath;

@property (nonatomic,copy) NSString *tenantId;

@property (nonatomic,assign) HDEmotionType emotionType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

// 登录账号管理，此数据应该由您服务器返回
@interface CSDemoAccountManager : NSObject

@property (nonatomic,strong) HDChatViewController *curChat; //当前聊天界面

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

- (void)refreshManagerData;

- (void)cacheBigExpression;

- (HDVisitorInfo *)visitorInfo;

@end
