//
//  SCFileManager.m
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 16/11/17.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "SCFileManager.h"

@implementation SCFileManager


static SCFileManager *manager= nil;
+(instancetype)shareFileManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}






@end
