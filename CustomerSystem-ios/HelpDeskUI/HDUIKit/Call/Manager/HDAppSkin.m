//
//  HDAppSkin.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/22.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDAppSkin.h"
#import "UIColor+HLKit.h"
@implementation HDAppSkin
+ (instancetype)mainSkin
{
    static HDAppSkin *mainSkin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainSkin = [[HDAppSkin alloc] init];
    });
    return mainSkin;
}

- (UIColor *)contentColorGray{
    
    return [UIColor hl_colorWithRed:232 green:238 blue:248];
}
- (UIColor *)contentColorGray1{
    
    return [UIColor hl_colorWithRed:179 green:180 blue:181];
}


- (UIFont *)systemFontMicro
{
    return [UIFont systemFontOfSize:12];
}

- (UIFont *)systemFontSmall
{
    return [UIFont systemFontOfSize:14];
}

- (UIFont *)systemFontMedium
{
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)systemFontLarge
{
    return [UIFont systemFontOfSize:17];
}

- (UIFont *)systemFont8pt
{
    return [UIFont systemFontOfSize:8];
}

- (UIFont *)systemFont9pt
{
    return [UIFont systemFontOfSize:9];
}

- (UIFont *)systemFont10pt
{
    return [UIFont systemFontOfSize:10];
}

- (UIFont *)systemFont11pt
{
    return [UIFont systemFontOfSize:11];
}

- (UIFont *)systemFont12pt
{
    return [UIFont systemFontOfSize:12];
}

- (UIFont *)systemFont13pt
{
    return [UIFont systemFontOfSize:13];
}

- (UIFont *)systemFont14pt
{
    return [UIFont systemFontOfSize:14];
}

- (UIFont *)systemFont15pt
{
    return [UIFont systemFontOfSize:15];
}

- (UIFont *)systemFont16pt
{
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)systemFont17pt
{
    return [UIFont systemFontOfSize:17];
}

- (UIFont *)systemFont18pt
{
    return [UIFont systemFontOfSize:18];
}

- (UIFont *)systemFont19pt
{
    return [UIFont systemFontOfSize:19];
}

- (UIFont *)systemFont21pt
{
    return [UIFont systemFontOfSize:21];
}

- (UIFont *)systemFont30pt
{
    return [UIFont systemFontOfSize:30];
}

-(UIFont *)systemFont35pt
{
    
    return [UIFont systemFontOfSize:35];
}

- (UIFont *)systemBoldFont14pt
{
    return [UIFont boldSystemFontOfSize:14];
}


- (UIFont *)systemBoldFont16pt
{
    return [UIFont boldSystemFontOfSize:16];
}

- (UIFont *)systemBoldFont18pt
{
    return [UIFont boldSystemFontOfSize:18];
}

- (UIFont *)systemBoldFont19pt
{
    return [UIFont boldSystemFontOfSize:19];
}

- (UIFont *)systemBoldFont21pt
{
    return [UIFont boldSystemFontOfSize:21];
}

@end
