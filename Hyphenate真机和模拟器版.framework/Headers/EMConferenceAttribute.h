//
//  EMConferenceAttribute.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2019/5/17.
//  Copyright © 2019 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMCallEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMConferenceAttribute : NSObject
@property (nonatomic, readonly) EMConferenceAttributeAction action;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *value;

@end

NS_ASSUME_NONNULL_END
