//
//  SCLoginManager.h
//  CustomerSystem-ios
//
//  Created by afanda on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLoginManager : NSObject

@property (strong, nonatomic) NSString *appkey;  // appley

@property (strong, nonatomic) NSString *cname;  //IM service account

@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSString *username;  // IM account

@property (strong, nonatomic) NSString *password;   //IM password

@property (copy, nonatomic) NSString *tenantId;

@property (copy, nonatomic) NSString *projectId;  //leaveMsgId

+ (instancetype)shareLoginManager;

- (BOOL)loginKefuSDK;

- (void)refreshManagerData;
@end
