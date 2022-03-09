//
//  HDCustomEmojiManager.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/9.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HEmojiPackage :NSObject
//表情包id
@property (nonatomic,copy) NSString *packageId;
//表情包名字
@property (nonatomic,copy) NSString *packageName;
//表情数
@property (nonatomic,assign) NSInteger emojiNum;
//tenantId
@property (nonatomic,copy) NSString *tenantId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface HEmoji :NSObject

@property (nonatomic,copy) NSString *emojiName;

@property (nonatomic,copy) NSString *originUrl;

@property (nonatomic,copy) NSString *originMediaId;

@property (nonatomic,copy) NSString *originLocalPath;

@property (nonatomic,copy) NSString *thumbnailUrl;

@property (nonatomic,copy) NSString *thumbnailMediaId;

@property (nonatomic,copy) NSString *thumbnailLocalPath;

@property (nonatomic,copy) NSString *tenantId;

@property (nonatomic,assign) HDEmotionType emotionType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
@interface HDCustomEmojiManager : NSObject
@property (nonatomic, strong) NSString *tenantId; 

+ (instancetype)shareManager;
- (void)cacheBigExpression;
@end

NS_ASSUME_NONNULL_END
