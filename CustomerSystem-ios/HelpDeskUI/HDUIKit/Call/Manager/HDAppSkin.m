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
- (UIColor *)contentColorYellow1
{
    return [UIColor colorWithHex:0xFFD500];
}

- (UIColor *)contentColorYellow2
{
    return [UIColor colorWithHex:0xC2A200];
}
- (UIColor *)contentColorYellow3
{
    return [UIColor colorWithHex:0xFE9500];
}
//app 中红色 只有这一种(默认)
- (UIColor *)contentColorRed3
{
    return [UIColor colorWithHex:0xDF1D0F];
}
//app 中红色 点击的红色
- (UIColor *)contentColorRed2
{
    return [UIColor colorWithHex:0xB33618];
}


- (UIColor *)contentColorBlue1
{
    return [UIColor colorWithHex:0x31AEE7];
}

- (UIColor *)contentColorBlue2
{
    return [UIColor colorWithHex:0x2892f4];
}

- (UIColor *)contentColorBlue3
{
    return [UIColor colorWithHex:0x1B94D3];
}


- (UIColor *)contentColorOrange1
{
    return [UIColor colorWithHex:0xFF6C00];
}

- (UIColor *)contentColorOrange2
{
    return [UIColor colorWithHex:0xCC5600];
}

- (UIColor *)barBackgroundDrakColor
{
    return [UIColor colorWithHex:0x333333 alpha:0.9];
}



- (UIColor *)contentColorGray1
{
    return [UIColor colorWithHex:0x333333];
}

- (UIColor *)contentColorGray2
{
    return [UIColor colorWithHex:0x666666];
}

- (UIColor *)contentColorGray3
{
    return [UIColor colorWithHex:0x999999];
}

- (UIColor *)contentColorGray4
{
    return [UIColor colorWithHex:0xDCDCDC];
}

- (UIColor *)contentColorGray6
{
    return [UIColor colorWithHex:0xF5F5F5];
}

- (UIColor *)contentColorGray7
{
    return [UIColor colorWithHex:0xF0F0F0];
}
- (UIColor *)contentColorGray8
{
    return [UIColor colorWithHex:0x88888888];
}
- (UIColor *)contentColorGray9
{
    return [UIColor colorWithHex:0xF2F2F2];
}
- (UIColor *)contentColorGray10
{
    return [UIColor colorWithHex:0xF7F7F7];
}
- (UIColor *)contentColorGray11
{
    
    return [UIColor colorWithHex:0xB9B9B9];
    
}
- (UIColor *)contentColorGray12
{
    
    return [UIColor colorWithHex:0xEFEFEF];
    
}
- (UIColor *)contentColorGrayA
{
    
    return [UIColor colorWithHex:0xAAAAAA];
    
}


- (UIColor *)contentColorSoil1
{
    return [UIColor colorWithHex:0x957357];
}

- (UIColor *)contentColorSoil2
{
    return [UIColor colorWithHex:0xfff3c2];
}

- (UIColor *)contentColorWhite
{
    return [UIColor colorWithHex:0xFFFFFF];
}
- (UIColor *)contentColorWhiteF1
{
    return [UIColor colorWithHex:0xF1F1F1];
}


- (UIColor *)contentColorBlack
{
    return [UIColor colorWithHex:0x000000];
}


//演出票的颜色
- (UIColor *)contentColorGreen
{
    return [UIColor colorWithHex:0x39C046];
}
- (UIColor *)contentColorBrown
{
    return  [UIColor colorWithHex:0xCFA972];
}

//  界面使用的红色
- (UIColor *)navigationBarColor
{
    return [self contentColorRed3];
}

//改版后的导航栏使用白色
- (UIColor *)navigationBarCustomColor
{
    return [self contentColorWhite];
}

- (UIColor *)countDownBackColor
{
    return [UIColor colorWithHex:0xF7F7F7];
}

- (UIColor *)showSelectedSeatColor
{
    return [UIColor colorWithHex:0x21A639];
}

//  主要的分割线颜色
-( UIColor *)seprateLineColor
{
    return [UIColor colorWithHex:0xECECEC];
}

//首页需要的线
-( UIColor *)seprateLineColor1
{
    return [UIColor colorWithHex:0xE5E5E5];
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
