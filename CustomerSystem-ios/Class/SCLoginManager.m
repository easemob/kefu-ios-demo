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

- (void)setAppkey:(NSString *)appkey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _appkey = appkey;
    [userDefaults setObject:_appkey forKey:kAppKey];
}

- (void)setCname:(NSString *)cname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _cname = cname;
    [userDefaults setObject:_cname forKey:kCustomerName];
}

- (void)setTenantId:(NSString *)tenantId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _tenantId = tenantId;
    [userDefaults setObject:_tenantId forKey:kCustomerTenantId];
}

- (void)setNickname:(NSString *)nickname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _nickname = nickname;
    [userDefaults setObject:_nickname forKey:kCustomerNickname];
}

- (void)setProjectId:(NSString *)projectId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _projectId = projectId;
    [userDefaults setObject:_projectId forKey:kCustomerProjectId];
}

- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _appkey = [userDefaults objectForKey:kAppKey];
        if ([_appkey length] == 0) {
            _appkey = kDefaultAppKey;
            [userDefaults setObject:_appkey forKey:kAppKey];
        }
        _cname = [userDefaults objectForKey:kCustomerName];
        if ([_cname length] == 0) {
            _cname = kDefaultCustomerName;
            [userDefaults setObject:_cname forKey:kCustomerName];
        }

        _nickname = [userDefaults objectForKey:kCustomerNickname];
        if ([_nickname length] == 0) {
            _nickname = @"";
            [userDefaults setObject:_nickname forKey:kCustomerNickname];
        }

        _tenantId = [userDefaults objectForKey:kCustomerTenantId];
        if ([_tenantId length] == 0) {
            _tenantId = kDefaultTenantId;
            [userDefaults setObject:_tenantId forKey:kCustomerTenantId];
        }

        _projectId = [userDefaults objectForKey:kCustomerProjectId];
        if ([_projectId length] == 0) {
            _projectId = kDefaultProjectId;
            [userDefaults setObject:_projectId forKey:kCustomerProjectId];
        }
        
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
        if (error.code == EMErrorUserNotFound) {
            [self registerIMuser];
        }
        return NO;
    }
    return NO;
}

- (EMError *)loginIM {
    EMError *error = nil;
    error = [[HChatClient sharedClient] loginWithUsername:_username password:hxPassWord];
    return error;
}

- (NSString *)username {
    NSString *username = nil;
    if (_username.length == 0) {
        UIDevice *device = [UIDevice currentDevice];//创建设备对象
        NSString *deviceUID = [[NSString alloc] initWithString:[[device identifierForVendor] UUIDString]];
        if ([deviceUID length] == 0) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            if (uuid)
            {
                deviceUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
                CFRelease(uuid);
            }
        }
        username = [deviceUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    } else {
        username = _username;
    }
    return username;
}

- (BOOL)registerIMuser { //举个栗子，尽量不要在移动端注册
    EMError *error = nil;
    NSString *newUser = [self username];
    error = [[HChatClient sharedClient] registerWithUsername: newUser password:hxPassWord];
    if (error &&  error.code != EMErrorUserAlreadyExist) {
        NSLog(@"注册失败;error code：%d,error description :%@",error.code,error.errorDescription);
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
