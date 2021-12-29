//
//  EMGroupMessageAck.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2019/6/3.
//  Copyright © 2019 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMGroupMessageAck : NSObject
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) int readCount;
@property (nonatomic) long long timestamp;
@end

NS_ASSUME_NONNULL_END
