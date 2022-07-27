//
//  WhiteModel.m
//  Whiteboard
//
//  Created by yleaf on 2020/9/19.
//

#import "WhiteObject.h"

@implementation WhiteObject

+ (instancetype)modelWithJSON:(id)json
{
    return [self yy_modelWithJSON:json];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self jsonDict]];
}

- (NSString *)jsonString
{
    return [self yy_modelToJSONString];
}

- (NSDictionary *)jsonDict
{
    NSDictionary *dict = [self yy_modelToJSONObject];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return @{};
    }
    return [self yy_modelToJSONObject];
}

@end
