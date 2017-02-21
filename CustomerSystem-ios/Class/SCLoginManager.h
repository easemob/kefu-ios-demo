//
//  SCLoginManager.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLoginManager : NSObject

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
@end
