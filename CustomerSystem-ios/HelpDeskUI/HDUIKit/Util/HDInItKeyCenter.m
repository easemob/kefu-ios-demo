//
//  HDInItKeyCenter.m
//  CustomerSystem-ios
//
//  Created by easemob on 2023/1/9.
//  Copyright © 2023 easemob. All rights reserved.
//

#import "HDInItKeyCenter.h"
#define kHDDefaultAppKey @"1400171218061390#kefuchannelapp387"
#define kHDDefaultImServiceNum @"kefuchannelimid_742962"
#define kHDDefaultTenantId @"387"
#define kHDDefaultProjectId @"48350"
#define kHDDefaultConfigId @"c9570743-2e93-4287-b52e-1d070d2b997e"

@implementation HDInItKeyCenter
static HDInItKeyCenter *_manager = nil;
+ (instancetype)shareInitManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
- (NSString *)appkey{
    
    if (_appkey&& [_appkey isKindOfClass:[NSString class]] && _appkey.length>0) {
        return  _appkey;
    }else{

        return kHDDefaultAppKey;
    }
}

- (NSString *)tenantId{
    
    if (_tenantId&& [_tenantId isKindOfClass:[NSString class]] && _tenantId.length>0) {
        return  _tenantId;
    }else{

        return kHDDefaultTenantId;
    }
}
- (NSString *)imServiceNum{
    
    if (_imServiceNum&& [_imServiceNum isKindOfClass:[NSString class]] && _imServiceNum.length>0) {
        return  _imServiceNum;
    }else{

        return kHDDefaultImServiceNum;
    }
}
- (NSString *)projectId{
    
    if (_projectId&& [_projectId isKindOfClass:[NSString class]] && _projectId.length>0) {
        return  _projectId;
    }else{

        return kHDDefaultProjectId;
    }
}

-(void)changeAppKey:(NSString *)appKey withTenantId:(NSString *)tenantId{
    //如果在登录状态,账号要退出
    HDClient *client = [HDClient sharedClient];
    HDError *error = [client logout:NO];
    if (error != nil) {
            NSLog(@"登出出错:%@",error.errorDescription);
    }
    HDError *er = [client changeAppKey:appKey];
    if (er == nil) {
        NSLog(@"appkey 已更新");
        // 此时更新 租户id
        [[HDClient  sharedClient] changeTenantId:tenantId];
        
    } else {
        NSLog(@"appkey 更新失败,请手动重启");
    }
}

@end
