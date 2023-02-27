//
//  Utility.h
//  OCExample
//
//  Created by xuyunshi on 2022/1/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString* HDVECTheme NS_STRING_ENUM;
extern HDVECTheme const HDVECThemeAuto;
extern HDVECTheme const HDVECThemeDark;
extern HDVECTheme const HDVECThemeLight;

NS_ASSUME_NONNULL_BEGIN

@interface HDVECWhiteBoardUtility : NSObject

+ (UIButton *)buttonWith: (NSString *)title index: (int)index;
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
