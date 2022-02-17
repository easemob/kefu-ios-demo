//
//  WhiteFontFace.h
//  Whiteboard-Whiteboard
//
//  Created by yleaf on 2020/12/1.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 字体配置文件，与 CSS 中的 FontFace 属性对应。
 */
@interface WhiteFontFace : WhiteObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFontFamily:(NSString *)name src:(NSString *)src;

/**
 字体名称，需要和 CSS 中 `font-family` 字段的值对应。
 */
@property (nonatomic, strong) NSString *fontFamily;

/**
 字体样式，需要和 CSS 中 `font-style` 字段的值对应。默认值为 `normal`。
 */
@property (nonatomic, strong, nullable) NSString *fontStyle;

/**
 字体粗细，需要和 CSS 中 `font-weight` 字段的值对应。
 */
@property (nonatomic, strong, nullable) NSString *fontWeight;

/**
 字体文件的地址，需要和 CSS 中 `src` 字段的值对应。
 */
@property (nonatomic, strong) NSString *src;

/**
 字体的字符编码范围，需要和 CSS 中 `unicode-range` 字段的值对应。
 */
@property (nonatomic, strong, nullable) NSString *unicodeRange;

@end

NS_ASSUME_NONNULL_END
