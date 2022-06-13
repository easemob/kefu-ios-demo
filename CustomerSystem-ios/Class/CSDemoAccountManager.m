//
//  CSDemoAccountManager.m
//  CustomerSystem-ios
//
//  Created by ease on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "CSDemoAccountManager.h"
#import <objc/runtime.h>
#import "LocalDefine.h"
#import "HDCustomEmojiManager.h"
#import "HDAccountmanager.h"

@implementation CSDemoAccountManager

static CSDemoAccountManager *_manager = nil;
+ (instancetype)shareLoginManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (void)setAppkey:(NSString *)appkey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appkey forKey:kAppKey];
    [userDefaults synchronize];
}


- (void)setCname:(NSString *)cname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cname forKey:kCustomerName];
    [userDefaults synchronize];
}

- (void)setTenantId:(NSString *)tenantId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tenantId forKey:kCustomerTenantId];
    [userDefaults synchronize];
}

- (void)setNickname:(NSString *)nickname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nickname forKey:kCustomerNickname];
    [userDefaults synchronize];
}

- (void)setProjectId:(NSString *)projectId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:projectId forKey:kCustomerProjectId];
    [userDefaults synchronize];
}

- (void)setConfigId:(NSString *)configId{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:configId forKey:kCustomerConfigId];
    [userDefaults synchronize];
    
}

- (NSString *)appkey {
    NSString *apk = [fUserDefaults objectForKey:kAppKey];
    if ([apk length] == 0) {
        apk = kDefaultAppKey;
        [fUserDefaults setObject:apk forKey:kAppKey];
        [fUserDefaults synchronize];
    }
    return apk;
}

- (NSString *)cname {
    NSString *im = [fUserDefaults objectForKey:kCustomerName];
    if ([im length] == 0) {
        im = kDefaultCustomerName;
        [fUserDefaults setObject:im forKey:kCustomerName];
        [fUserDefaults synchronize];
    }
    return im;
}

- (NSString *)nickname {
    NSString * tnickname = [fUserDefaults objectForKey:kCustomerNickname];
    if ([tnickname length] == 0) {
        tnickname = kDefaultCustomerNickname;
        [fUserDefaults setObject:tnickname forKey:kCustomerNickname];
        [fUserDefaults synchronize];
    }
    [HDAccountmanager shareLoginManager].nickname = tnickname;
    return tnickname;
}

- (NSString *)avatarStr {
    return @"https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/e998ef4e7cbcfdb345716c5562a29956_121_121.png";
}

- (NSString *)tenantId {
    NSString *ttenantId = [fUserDefaults objectForKey:kCustomerTenantId];
    if ([ttenantId length] == 0) {
        ttenantId = kDefaultTenantId;
        [fUserDefaults setObject:ttenantId forKey:kCustomerTenantId];
        [fUserDefaults synchronize];
    }
    return ttenantId;
}

- (NSString *)projectId {
    NSString *tprojectId = [fUserDefaults objectForKey:kCustomerProjectId];
    if ([tprojectId length] == 0) {
        tprojectId = kDefaultProjectId;
        [fUserDefaults setObject:tprojectId forKey:kCustomerProjectId];
        [fUserDefaults synchronize];
    }
    return tprojectId;
}
- (NSString *)configId {
    NSString *tconfigId = [fUserDefaults objectForKey:kCustomerConfigId];
    if ([tconfigId length] == 0) {
        tconfigId = kDefaultConfigId;
        [fUserDefaults setObject:tconfigId forKey:kCustomerConfigId];
        [fUserDefaults synchronize];
    }
    return tconfigId;
}
- (instancetype)init {
    if (self = [super init]) {
        _password = hxPassWord;
    }
    return self;
}
//登录IM
- (BOOL)loginKefuSDK {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCustomEmojiManager shareManager]  cacheBigExpression];
    });
    HDClient *client = [HDClient sharedClient];
    if (client.isLoggedInBefore) {
        return YES;
    }
    if (![self registerIMuser]) {
        return NO;
    }
    return  [self login];
}

- (BOOL)loginKefuSDKTest {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDCustomEmojiManager shareManager]  cacheBigExpression];
    });

    if (![self registerIMuser]) {
        return NO;
    }
    return  [self login];
}


- (BOOL)login {
    HDError *error = [[HDClient sharedClient] loginWithUsername:self.username password:hxPassWord];
    if (!error) { //IM登录成功
        
        return YES;
    } else { //登录失败
        NSLog(@"登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
        return NO;
    }
    return NO;
}

//创建一个随机的用户名
- (NSString *)getRandomUsername {
    NSString *username = nil;
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
    username = [username stringByAppendingString:[NSString stringWithFormat:@"%u",arc4random()%100000]];
    return [username lowercaseString];
}

- (BOOL)registerIMuser { //举个栗子。注册建议在服务端创建环信id与自己app的账号一一对应，\
    而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器
    HDError *error = nil;
    NSString *newUser = [self getRandomUsername];
    self.username = newUser;
    error = [[HDClient sharedClient] registerWithUsername:newUser password:hxPassWord];
    if (error) {
        /*
         "network_anomalies" = "Network anomalies, please try again!";
         "account_already_exists" = "Registered account already exists, please try again!";
         "without_permission" = "Without permission, please sign in to open mode!";
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == HDErrorUserAlreadyExist) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"account_already_exists", @"Registered account already exists, please try again!") delegate:nil cancelButtonTitle:NSLocalizedString(@"setting_confirm", @"confirm") otherButtonTitles:nil, nil];
                [alertView show];
            }else if(error.code == 208){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"without_permission", @"Without permission, please sign in to open mode!") delegate:nil cancelButtonTitle:NSLocalizedString(@"setting_confirm", @"confirm") otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"network_anomalies", @"Network anomalies, please try again!")  delegate:nil cancelButtonTitle:NSLocalizedString(@"setting_confirm", @"confirm") otherButtonTitles:nil, nil];
                [alertView show];
            }
        });
        return NO;
    }
    return YES;
}
- (void)registerIMuserCallBackCompletion:(void (^)(NSString *aUsername, HDError *aError))aCompletionBlock { //举个栗子。注册建议在服务端创建环信id与自己app的账号一一对应，\
    而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器
    HDError *error = nil;
    NSString *newUser = [self getRandomUsername];
    self.username = newUser;
//    error = [[HDClient sharedClient] registerWithUsername:newUser password:hxPassWord ];
  
    [[HDClient sharedClient] registerWithUsername:newUser password:hxPassWord  completion:aCompletionBlock];
    
    
}
- (void)refreshManagerData {
    unsigned int propertysCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertysCount);
    for (int i=0; i<propertysCount-1; i++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        //因为都是NSString所以直接赋值
        [self setValue:@"" forKey:key];
    }
}
 - (HDVisitorInfo *)visitorInfo {
    HDVisitorInfo *visitor = [[HDVisitorInfo alloc] init];
    visitor.name = @"";
    visitor.qq = @"";
    visitor.phone = @"";
    visitor.companyName = @"";
    visitor.nickName = self.nickname;
    visitor.email = @"";
    visitor.desc = @"";
    
    return visitor;
}

@end
