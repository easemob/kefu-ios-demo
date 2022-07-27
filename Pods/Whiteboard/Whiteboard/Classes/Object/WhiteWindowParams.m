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
    _containerSizeRatio = @(9/16);
    _debug = YES;
    _prefersColorScheme = WhitePrefersColorSchemeLight;
    return self;
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

