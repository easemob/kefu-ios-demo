//
//  HDCustomEmojiManager.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/9.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDCustomEmojiManager.h"
#import "HDSDWebImageManager.h"
@implementation HEmojiPackage
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _packageId = [dictionary valueForKey:@"id"];
        _packageName = [dictionary valueForKey:@"packageName"];
        _emojiNum = [[dictionary valueForKey:@"fileNum"] integerValue];
        _tenantId = [[dictionary valueForKey:@"tenantId"] stringValue];
    }
    return self;
}

@end

@implementation HEmoji

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _emojiName = [dictionary valueForKey:@"fileName"];
        _originUrl = [dictionary valueForKey:@"originUrl"];
        _thumbnailUrl = [dictionary valueForKey:@"thumbnailUrl"];
        _originMediaId = [dictionary valueForKey:@"originMediaId"];
        _thumbnailMediaId = [dictionary valueForKey:@"thumbnailMediaId"];
        _tenantId = [dictionary valueForKey:@"tenantId"];
    }
    return self;
}

- (NSString *)originUrl {
    NSString *orUrl = [[HDClient sharedClient].kefuRestServer stringByAppendingString:_originUrl];
    return orUrl;
}

- (NSString *)thumbnailUrl {
    NSString *thUrl = [[HDClient sharedClient].kefuRestServer stringByAppendingString:_thumbnailUrl];
    return thUrl;
}

- (NSString *)originLocalPath {
    
    return [[HDSDWebImageManager shareInstance] defaultCachePathForKey:_originMediaId];
}

- (NSString *)thumbnailLocalPath {
    return [[HDSDWebImageManager shareInstance] defaultCachePathForKey:_originMediaId];
}

- (HDEmotionType)emotionType {
    return HDEmotionGif;
}

@end



@implementation HDCustomEmojiManager
{
    NSString *_emojiPath;
}
static HDCustomEmojiManager *_manager = nil;
+ (instancetype)shareManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
- (void)createPlist {
    NSString *path=NSTemporaryDirectory();
    NSLog(@"path = %@",path);
    _emojiPath =[path stringByAppendingPathComponent:@"emoji.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:_emojiPath]) {
         [fm createFileAtPath:_emojiPath contents:nil attributes:nil];
        [[NSMutableDictionary dictionaryWithCapacity:0] writeToFile:_emojiPath atomically:YES];
    }
}

- (void)setEmojiValue:(id)value forKey:(NSString *)key {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithContentsOfFile:_emojiPath];
    [mDic setValue:value forKey:key];
    [mDic writeToFile:_emojiPath atomically:YES];
}

- (void)cacheBigExpression {
    [self createPlist];
    HDChatManager *chat = [HDClient sharedClient].chatManager;
    [chat getEmojiPackageListCompletion:^(NSArray<NSDictionary *> *emojiPackages, HDError *error) {
        NSLog(@"getEmojiPackageList=%@",emojiPackages);
        if (error == nil) {
            NSMutableArray *hPackages = @[].mutableCopy;
            [self setEmojiValue:emojiPackages forKey:@"emojiPackages"];
            for (NSDictionary *dict in emojiPackages) {
                HEmojiPackage *emojiPackage = [[HEmojiPackage alloc] initWithDictionary:dict];
                [hPackages addObject:emojiPackage];
            }
            for (HEmojiPackage *package in hPackages) {
                [chat getEmojisWithPackageId:package.packageId completion:^(NSArray<NSDictionary *> *emojis, HDError *error) {
                    if (error == nil) {
                        [self setEmojiValue:emojis forKey:[NSString stringWithFormat:@"emojis%@",package.packageId]];
                    }
                }];
            }
        }
    }];
}
@end
