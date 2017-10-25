//
//  SCLoginManager.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDChatViewController.h"

@interface HEmojiPackage :NSObject 
//表情包id
@property(nonatomic,copy) NSString *packageId;
//表情包名字
@property(nonatomic,copy) NSString *packageName;
//表情数
@property(nonatomic,assign) NSInteger emojiNum;
//tenantId
@property(nonatomic,copy) NSString *tenantId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface HEmoji :NSObject

@property(nonatomic,copy) NSString *emojiName;

@property(nonatomic,copy) NSString *originUrl;

@property(nonatomic,copy) NSString *originMediaId;

@property(nonatomic,copy) NSString *originLocalPath;

@property(nonatomic,copy) NSString *thumbnailUrl;

@property(nonatomic,copy) NSString *thumbnailMediaId;

@property(nonatomic,copy) NSString *thumbnailLocalPath;

@property(nonatomic,assign) HDEmotionType emotionType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface SCLoginManager : NSObject

@property(nonatomic,strong)HDChatViewController *curChat; //当前聊天界面

@property (strong, nonatomic) NSString *appkey;  // appkey

@property (strong, nonatomic) NSString *cname;  //IM service account

@property (strong, nonatomic) NSString *nickname; //My nickname

@property (strong, nonatomic) NSString *username;  // IM account

@property (strong, nonatomic) NSString *password;   //IM password

@property (copy, nonatomic) NSString *tenantId;

@property (copy, nonatomic) NSString *projectId;  //leaveMsgId

@property(nonatomic,assign) BOOL isLogged;

+ (instancetype)shareLoginManager;

- (BOOL)loginKefuSDK;

- (void)refreshManagerData;

- (void)cacheBigExpression;

@end
