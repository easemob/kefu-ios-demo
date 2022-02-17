//
//  WhiteModel.h
//  Whiteboard
//
//  Created by yleaf on 2020/9/19.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhiteObject : NSObject

+ (instancetype)modelWithJSON:(id)json;
- (NSString *)jsonString;
- (NSDictionary *)jsonDict;

@end

NS_ASSUME_NONNULL_END
