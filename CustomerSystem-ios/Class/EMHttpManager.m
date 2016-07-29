//
//  EMHttpManager.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMHttpManager.h"

#import "AFHTTPSessionManager.h"
#import "EaseMob.h"
#import "EMIMHelper.h"

#define kPOST_CreateAMessage_API @"tenants/%@/projects/%@/tickets%@"

#define kGET_leaveAMessageDetail_API @"tenants/%@/projects/%@/tickets/%@%@"

#define kGET_leaveAMessageAllComments_API @"tenants/%@/projects/%@/tickets/%@/comments%@"

#define kPOST_leaveAMessage_API @"tenants/%@/projects/%@/tickets/%@/comments%@"

#define kGet_getMessages_API @"tenants/%@/projects/%@/tickets%@"

#define kQUERY_PARAMETER @"?tenantId=%@&easemob-appkey=%@&easemob-username=%@&easemob-target-username=%@"

static EMHttpManager *manager = nil;

@interface EMHttpManager ()
{
    AFHTTPSessionManager *_httpManager;
}

@end

@implementation EMHttpManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kKefuBaseURL]];
        _httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_httpManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        _httpManager.requestSerializer.timeoutInterval = 30.f;
        _httpManager.operationQueue.maxConcurrentOperationCount = 5;
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EMHttpManager alloc] init];
    });
    return manager;
}

- (void)asyncCreateMessageWithTenantId:(NSString*)tenantId
                             projectId:(NSString*)projectId
                            parameters:(NSDictionary*)parameters
                            completion:(void (^)(id responseObject, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:kPOST_CreateAMessage_API,tenantId,projectId,[self _getQueryParameters:tenantId]];
    [_httpManager POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)asyncGetLeaveMessageDetailWithTenantId:(NSString*)tenantId
                                     projectId:(NSString*)projectId
                                      ticketId:(NSInteger)ticketId
                                    parameters:(NSDictionary*)parameters
                                    completion:(void (^)(id responseObject, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:kGET_leaveAMessageDetail_API,tenantId,projectId,@(ticketId),[self _getQueryParameters:tenantId]];
    [_httpManager GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)asyncGetLeaveMessageAllCommentsWithTenantId:(NSString*)tenantId
                                          projectId:(NSString*)projectId
                                           ticketId:(NSInteger)ticketId
                                         parameters:(NSDictionary*)parameters
                                         completion:(void (^)(id responseObject, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:kGET_leaveAMessageAllComments_API,tenantId,projectId,@(ticketId),[self _getQueryParameters:tenantId]];
    [_httpManager GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)asyncLeaveAMessageWithTenantId:(NSString*)tenantId
                             projectId:(NSString*)projectId
                              ticketId:(NSInteger)ticketId
                            parameters:(NSDictionary*)parameters
                            completion:(void (^)(id responseObject, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:kPOST_leaveAMessage_API,tenantId,projectId,@(ticketId),[self _getQueryParameters:tenantId]];
    [_httpManager POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (NSString*)_getQueryParameters:(NSString*)tenantId
{
    NSString *token = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kEaseMobUserToken];
    if (token.length > 0) {
        [_httpManager.requestSerializer setValue:[NSString stringWithFormat:@"Easemob IM %@",token] forHTTPHeaderField:@"Authorization"];
    }
    return [[NSString stringWithFormat:kQUERY_PARAMETER,tenantId,[EMIMHelper defaultHelper].appkey,[EMIMHelper defaultHelper].username,[EMIMHelper defaultHelper].cname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)asyncGetMessagesWithTenantId:(NSString*)tenantId
                           projectId:(NSString*)projectId
                          parameters:(NSDictionary*)parameters
                          completion:(void (^)(id responseObject, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:kGet_getMessages_API,tenantId,projectId,[self _getQueryParameters:tenantId]];
    [_httpManager GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)uploadWithTenantId:(NSString*)tenantId
                      File:(NSData*)file
                parameters:(NSDictionary*)parameters
                completion:(void (^)(id responseObject, NSError *error))completion

{
    
    NSString *path = [NSString stringWithFormat:@"https://a1.easemob.com/%@/chatfiles",[[EMIMHelper defaultHelper].appkey stringByReplacingOccurrencesOfString:@"#" withString:@"/"]];
    if ([[EaseMob sharedInstance].chatManager loginInfo]) {
        [_httpManager.requestSerializer setValue:[NSString stringWithFormat:@"Bear %@",[[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    }
    [_httpManager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([parameters objectForKey:@"fileName"]) {
            [formData appendPartWithFileData:file name:@"file" fileName:[parameters objectForKey:@"fileName"] mimeType:@"image/jpeg"];
        } else {
            [formData appendPartWithFileData:file name:@"file" fileName:@"image" mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
