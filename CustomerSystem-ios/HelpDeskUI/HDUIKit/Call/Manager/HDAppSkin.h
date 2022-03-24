//
//  HDAppSkin.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/22.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDAppSkin : NSObject
+ (instancetype)mainSkin;

#pragma mark - 图片 iconfont



- (UIColor *)contentColorYellow1;
- (UIColor *)contentColorYellow2;
- (UIColor *)contentColorYellow3;
//app 中红色 只有这一种
- (UIColor *)contentColorRed3;
- (UIColor *)contentColorRed2;
- (UIColor *)contentColorBlue1;
- (UIColor *)contentColorBlue2;
- (UIColor *)contentColorBlue3;
- (UIColor *)contentColorOrange1;
- (UIColor *)contentColorOrange2;
- (UIColor *)navigationBarColor;
- (UIColor *)navigationBarCustomColor;
- (UIColor *)seprateLineColor;
- (UIColor *)seprateLineColor1;
- (UIColor *)countDownBackColor;
- (UIColor *)showSelectedSeatColor;

- (UIColor *)barBackgroundDrakColor;
//项目常用颜色 灰色
- (UIColor *)contentColorGray1;
- (UIColor *)contentColorGray2;
- (UIColor *)contentColorGray3;
- (UIColor *)contentColorGray4;
- (UIColor *)contentColorGray6;
- (UIColor *)contentColorGray7;
- (UIColor *)contentColorGray8;
- (UIColor *)contentColorGray9;
- (UIColor *)contentColorGray10;
- (UIColor *)contentColorGray11;
- (UIColor *)contentColorGray12;
- (UIColor *)contentColorGrayA;

- (UIColor *)contentColorSoil1;
- (UIColor *)contentColorSoil2;

//项目常用颜色 白色
- (UIColor *)contentColorWhite;
- (UIColor *)contentColorWhiteF1;
//项目常用颜色 黑色
- (UIColor *)contentColorBlack;

- (UIColor *)contentColorGreen;
- (UIColor *)contentColorBrown;
- (UIFont *)systemFontMicro;
- (UIFont *)systemFontSmall;
- (UIFont *)systemFontMedium;
- (UIFont *)systemFontLarge;
- (UIFont *)systemFont8pt;
- (UIFont *)systemFont9pt;
- (UIFont *)systemFont10pt;
- (UIFont *)systemFont11pt;
- (UIFont *)systemFont12pt;
- (UIFont *)systemFont13pt;
- (UIFont *)systemFont14pt;
- (UIFont *)systemFont15pt;
- (UIFont *)systemFont16pt;
- (UIFont *)systemFont17pt;
- (UIFont *)systemFont18pt;
- (UIFont *)systemFont19pt;
- (UIFont *)systemFont21pt;
- (UIFont *)systemFont30pt;
- (UIFont *)systemFont35pt;

- (UIFont *)systemBoldFont14pt;
- (UIFont *)systemBoldFont16pt;
- (UIFont *)systemBoldFont18pt;
- (UIFont *)systemBoldFont19pt;
- (UIFont *)systemBoldFont21pt;
@end

NS_ASSUME_NONNULL_END
