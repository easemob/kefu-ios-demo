//
//  WhiteMemberInformation.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/14.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 用于自定义用户信息。 */
@interface WhiteMemberInformation : WhiteObject

/**
 `MemberInformation` 构造方法，用于初始化用户信息对象。
 
 @param userId 用户 ID
 @param nickName 用户昵称
 @param avatarUrl 用户头像图片地址
 */
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)nickName avatar:(NSString *)avatarUrl;


@property (nonatomic, assign, readwrite) NSInteger id;


/** 用户昵称 */
@property (nonatomic, copy, readonly) NSString *nickName;
/** 头像图片地址 */
@property (nonatomic, copy, readonly, nullable) NSString *avatar;
/**
 用户 ID。请保证用户 ID 的唯一性。
 */
@property (nonatomic, copy, readonly, nullable) NSString *userId;

@end

NS_ASSUME_NONNULL_END
