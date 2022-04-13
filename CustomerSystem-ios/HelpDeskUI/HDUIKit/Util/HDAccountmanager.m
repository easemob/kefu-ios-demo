//
//  HDAccountmanager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/15.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDAccountmanager.h"
#import "HDCustomEmojiManager.h"

@implementation HDAccountmanager
static HDAccountmanager *_manager = nil;
+ (instancetype)shareLoginManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
- (NSString *)avatarStr {
    return @"https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/e998ef4e7cbcfdb345716c5562a29956_121_121.png";
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
