//
//  WhiteWindowParams.m
//  Whiteboard
//
//  Created by yleaf on 2022/2/9.
//

#import "WhiteWindowParams.h"

WhitePrefersColorScheme const WhitePrefersColorSchemeAuto = @"auto";
WhitePrefersColorScheme const WhitePrefersColorSchemeLight = @"light";
WhitePrefersColorScheme const WhitePrefersColorSchemeDark = @"dark";

@implementation WhiteWindowParams

- (instancetype)init {
    self = [super init];
    _chessboard = YES;
    _containerSizeRatio = @(9/16.0);
    _debug = YES;
    _prefersColorScheme = WhitePrefersColorSchemeLight;
    return self;
}

- (void)setContainerSizeRatio:(NSNumber *)containerSizeRatio {
    if (isinf([containerSizeRatio doubleValue])) { return; }
    if (isnan([containerSizeRatio doubleValue])) { return; }
    _containerSizeRatio = containerSizeRatio;
}

- (void)setPrefersColorScheme:(WhitePrefersColorScheme)prefersColorScheme {
    if (@available(iOS 13, *)) {
        _prefersColorScheme = prefersColorScheme;
    } else if ([prefersColorScheme isEqualToString:WhitePrefersColorSchemeAuto]) {
        NSLog(@"WhitePrefersColorSchemeAuto is not available before iOS 13");
        return;
    } else {
        _prefersColorScheme = prefersColorScheme;
    }
}

@end

