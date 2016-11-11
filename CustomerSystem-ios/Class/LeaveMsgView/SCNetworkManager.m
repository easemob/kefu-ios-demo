//
//  SCNetworkManager.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/10.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCNetworkManager.h"

@implementation SCNetworkManager
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}

+(instancetype)sharedInstance {
    static SCNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCNetworkManager alloc] init];
    });
    return manager;
}

- (void)downloadFileWithUrl:(NSString *)url completionHander:(void (^)(BOOL success,NSURL *filePath,NSError *error))completion{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) { //成功
            if (completion) {
                completion(YES,filePath,nil);
            }
        }else{
            if (completion) {
                completion(NO,nil,error);
            }
        }
    }];
    
    [_downloadTask resume];
}

@end
