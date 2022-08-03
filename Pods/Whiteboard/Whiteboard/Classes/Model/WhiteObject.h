//
//  WhiteModel.h
//  Whiteboard
//
//  Created by yleaf on 2020/9/19.
//

#import <Foundation/Foundation.h>
#import "NSObject+YY.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteObject : NSObject

- (NSString *)jsonString;
- (NSDictionary *)jsonDict;

@end

NS_ASSUME_NONNULL_END
