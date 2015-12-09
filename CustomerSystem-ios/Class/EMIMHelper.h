//
//  EMIMHelper.h
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/28.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMIMHelper : NSObject

@property (strong, nonatomic) NSString *appkey;

@property (strong, nonatomic) NSString *cname;

@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *password;

+ (instancetype)defaultHelper;

- (void)loginEasemobSDK;

- (void)refreshHelperData;

@end
