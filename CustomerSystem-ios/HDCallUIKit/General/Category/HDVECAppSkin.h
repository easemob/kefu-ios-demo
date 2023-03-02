//
//  HDAppSkin.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/22.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+HLKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDVECAppSkin : NSObject
+ (instancetype)mainSkin;

#pragma mark - 图片 iconfont

//huxin 通用
- (UIColor *)contentColorBlueHX;
- (UIColor *)contentColorF7F7F7;
- (UIColor *)contentColorF2AC3C;
- (UIColor *)contentColorF0F0F0;
- (UIColor *)contentColorE2EDFD;
- (UIColor *)contentColor555555;
- (UIColor *)contentColorBCBCBC;
//项目常用颜色 灰色 背景色
- (UIColor *)contentColorGray;

- (UIColor *)contentColorRed;
- (UIColor *)contentColorBlue;

- (UIColor *)contentColorGray1;
- (UIColor *)contentColorGrayWhithWite;
- (UIColor *)contentColorGreen;
- (UIColor *)contentColorGreenWeb;
- (UIColor *)contentColorGrayalpha:(CGFloat)alpha;
- (UIColor *)contentColorWhitealpha:(CGFloat)alpha;
- (UIColor *)contentColorBlockalpha:(CGFloat)alpha;


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
