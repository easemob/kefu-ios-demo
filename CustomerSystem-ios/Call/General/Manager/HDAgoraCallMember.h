//
//  HDAgoraCallMember.h
//  HelpDesk
//
//  Created by houli on 2022/1/28.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDAgoraCallMember : NSObject
@property (nonatomic,strong ) NSString * memberName;
@property (nonatomic,strong ) NSString * agentNickName;
@property (nonatomic,strong) NSDictionary * extension;
@end

NS_ASSUME_NONNULL_END
