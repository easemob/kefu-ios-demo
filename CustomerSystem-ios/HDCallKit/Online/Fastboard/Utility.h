//
//  Utility.h
//  OCExample
//
//  Created by xuyunshi on 2022/1/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString* Theme NS_STRING_ENUM;
extern Theme const ThemeAuto;
extern Theme const ThemeDark;
extern Theme const ThemeLight;

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject

+ (UIButton *)buttonWith: (NSString *)title index: (int)index;
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
