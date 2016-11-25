//
//  SCLoginManager.h
//  CustomerSystem-ios
//
//  Created by ease on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLoginManager : NSObject
@property (strong, nonatomic) NSString *appkey; 

@property (strong, nonatomic) NSString *cname;

@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *password;

@property (copy, nonatomic) NSString *tenantId;

@property (copy, nonatomic) NSString *projectId;

+ (instancetype)shareLoginManager;

- (BOOL)loginKefuSDK;

- (void)refreshManagerData;
@end
