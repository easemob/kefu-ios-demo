//
//  HDCallAppManger.m
//  CustomerSystem-ios
//
//  Created by easemob on 2023/3/24.
//  Copyright © 2023 easemob. All rights reserved.
//

#import "HDCallAppManger.h"

@implementation HDCallAppManger
static HDCallAppManger *shareCall = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCall = [[HDCallAppManger alloc] init];
       
    });
    return shareCall;
}
- (NSDictionary *)dictWithString:(NSString *)string {
    if (string && 0 != string.length) {
        NSError *error;
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return nil;
        }
        return jsonDict;
    }
    
    return nil;
}
@end
