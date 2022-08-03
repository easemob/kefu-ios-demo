//
//  WhiteFontFace.m
//  Whiteboard-Whiteboard
//
//  Created by yleaf on 2020/12/1.
//

#import "WhiteFontFace.h"

@implementation WhiteFontFace

- (instancetype)initWithFontFamily:(NSString *)name src:(NSString *)src
{
    self = [super init];
    if (self) {
        _fontFamily = name;
        _src = src;
    }
    return self;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
        @"fontFamily": @"font-family",
        @"fontStyle": @"font-style",
        @"fontWeight": @"font-weight",
        @"unicodeRange": @"unicode-range"
    };
}

@end
