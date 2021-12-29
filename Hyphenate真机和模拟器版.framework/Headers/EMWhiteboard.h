//
//  EMWhiteboard.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2020/2/26.
//  Copyright © 2020 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMWhiteboard : NSObject
@property (nonatomic, strong, readonly) NSString *roomId;
@property (nonatomic, strong, readonly) NSString *roomURL;
@end

NS_ASSUME_NONNULL_END
