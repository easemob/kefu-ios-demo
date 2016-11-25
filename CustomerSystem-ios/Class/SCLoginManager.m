//
//  SCLoginManager.m
//  CustomerSystem-ios
//
//  Created by ease on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCLoginManager.h"

@implementation SCLoginManager

static SCLoginManager *_manager = nil;
+ (instancetype)shareLoginManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init { //全部为默认设置
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        _appkey = [userDefaults objectForKey:kAppKey];
//        if ([_appkey length] == 0) {
            _appkey = kDefaultAppKey;
//            [userDefaults setObject:_appkey forKey:kAppKey];
//        }
//        _cname = [userDefaults objectForKey:kCustomerName];
//        if ([_cname length] == 0) {
            _cname = kDefaultCustomerName;
//            [userDefaults setObject:_cname forKey:kCustomerName];
//        }
//        
//        _nickname = [userDefaults objectForKey:kCustomerNickname];
//        if ([_nickname length] == 0) {
//            _nickname = @"";
//            [userDefaults setObject:_nickname forKey:kCustomerNickname];
//        }
//        
//        _tenantId = [userDefaults objectForKey:kCustomerTenantId];
//        if ([_tenantId length] == 0) {
            _tenantId = kDefaultTenantId;
//            [userDefaults setObject:_tenantId forKey:kCustomerTenantId];
//        }
//        
//        _projectId = [userDefaults objectForKey:kCustomerProjectId];
//        if ([_projectId length] == 0) {
            _projectId = kDefaultProjectId;
//            [userDefaults setObject:_projectId forKey:kCustomerProjectId];
//        }
//        
        _username = [userDefaults objectForKey:@"username"];
        _password = [userDefaults objectForKey:@"password"];
    }
    return self;
}

- (BOOL)loginKefuSDK {
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedIn && [client.currentUsername isEqualToString:_username]) {
        return YES;
    }
    _username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (_username.length == 0 || _password.length == 0) {
        if (![self registerIMuser]) {
            return NO;
        }
    }
    EMError *error = [self loginIM];
    if (!error) { //IM登录成功
        return YES;
    } else { //登录失败
        NSLog(@"error code :%d,error description:%@",error.code,error.errorDescription);
        return NO;
    }
    return NO;
}

- (EMError *)loginIM {
    EMError *error = nil;
    error = [[HChatClient sharedClient] loginWithUsername:_username password:hxPassWord];
    return error;
}

//随机获取一个用户名
- (NSString *)username {
    NSString *username = nil;
    if (_username.length == 0) {
        int userInt = arc4random() %99999 + 100000 ;
        username = [NSString stringWithFormat:@"%d",userInt];
    } else {
        username = _username;
    }
    return username;
}

- (BOOL)registerIMuser {
    EMError *error = nil;
    NSString *newUser = [self username];
    error = [[HChatClient sharedClient] registerWithUsername: newUser password:hxPassWord];
    if (error) {
        NSLog(@"注册失败，请检查配置信息，如appKey;error code：%d,error description :%@",error.code,error.errorDescription);
        return NO;
    }
    _username = newUser;
    [[NSUserDefaults standardUserDefaults] setValue:newUser forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:hxPassWord forKey:@"password"];
    _password = hxPassWord;
    return YES;
}
- (void)refreshManagerData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:kAppKey];
    _appkey = @"";
//    [userDefaults removeObjectForKey:kCustomerName];
//    _cname = @"";
//    [userDefaults removeObjectForKey:kCustomerNickname];
    _nickname = @"";
//    [userDefaults removeObjectForKey:kCustomerTenantId];
    _tenantId = @"";
//    [userDefaults removeObjectForKey:kCustomerProjectId];
    _projectId = @"";
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    _username = nil;
    _password = nil;
}


@end
