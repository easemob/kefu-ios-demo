//
//  MemberState.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/14.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ApplianceName

/** 白板绘图工具。 */
typedef NSString * WhiteApplianceNameKey NS_STRING_ENUM;
/** 点击工具，无任何作用。 */
extern WhiteApplianceNameKey const ApplianceClicker;
/** 铅笔。 */
extern WhiteApplianceNameKey const AppliancePencil;
/** 选择工具。 */
extern WhiteApplianceNameKey const ApplianceSelector;
/** 文字工具。 */
extern WhiteApplianceNameKey const ApplianceText;
/** 椭圆工具。 */
extern WhiteApplianceNameKey const ApplianceEllipse;
/** 矩形工具。 */
extern WhiteApplianceNameKey const ApplianceRectangle;
/** 橡皮工具。 */
extern WhiteApplianceNameKey const ApplianceEraser;
/** 直线工具。 */
extern WhiteApplianceNameKey const ApplianceStraight;
/** 箭头工具。 */
extern WhiteApplianceNameKey const ApplianceArrow;
/** 抓手工具。 */
extern WhiteApplianceNameKey const ApplianceHand;
/** 激光笔工具。 */
extern WhiteApplianceNameKey const ApplianceLaserPointer;
/** 图形工具，需要设置 `ShapeType` 属性，如果不设置，则默认设置为三角形。
 @since 2.12.24 */
extern WhiteApplianceNameKey const ApplianceShape;

#pragma mark - ShapeKey

/** 图形形状。 */
typedef NSString * WhiteApplianceShapeTypeKey NS_STRING_ENUM;
/** 三角形。
 @since 2.12.24  */
extern WhiteApplianceShapeTypeKey const ApplianceShapeTypeTriangle;
/** 菱形。
 @since 2.12.24  */
extern WhiteApplianceShapeTypeKey const ApplianceShapeTypeRhombus;
/** 五角星。
 @since 2.12.24  */
extern WhiteApplianceShapeTypeKey const ApplianceShapeTypePentagram;
/** 对话气泡。
 @since 2.12.24  */
extern WhiteApplianceShapeTypeKey const ApplianceShapeTypeSpeechBalloon;

#pragma mark - ReadonlyMemberState

/** 互动白板实时房间的工具状态（只读）。初始工具为pencil，无默认值。 */
@interface WhiteReadonlyMemberState : WhiteObject

/** 互动白板实时房间内当前使用的工具名称。初始工具为pencil，无默认值。 */
@property (nonatomic, copy, readonly) WhiteApplianceNameKey currentApplianceName;
/** 线条颜色，为 RGB 格式，例如，(0, 0, 255) 表示蓝色。 */
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *strokeColor;
/** 线条粗细。 */
@property (nonatomic, strong, readonly, nullable) NSNumber *strokeWidth;
/** 字体大小。 */
@property (nonatomic, strong, readonly, nullable) NSNumber *textSize;
/** 当教具为 `Shape` 时，所选定的 shape 图形。
 @since 2.12.24 */
@property (nonatomic, strong, readonly, nullable) WhiteApplianceShapeTypeKey shapeType;
@end

#pragma mark - MemberState

/** 互动白板实时房间的工具状态。初始工具为pencil，无默认值。 */
@interface WhiteMemberState : WhiteReadonlyMemberState
/** 互动白板实时房间内当前使用的工具名称。初始工具为pencil，无默认值。 */
@property (nonatomic, copy, readwrite, nullable) WhiteApplianceNameKey currentApplianceName;
/** 线条颜色，为 RGB 格式，例如，(0, 0, 255) 表示蓝色。 */
@property (nonatomic, copy, readwrite, nullable) NSArray<NSNumber *> *strokeColor;
/** 线条粗细。 */
@property (nonatomic, strong, readwrite, nullable) NSNumber *strokeWidth;
/** 字体大小。 */
@property (nonatomic, strong, readwrite, nullable) NSNumber *textSize;
/**
 当 currentApplianceName 为 Shape 时，所选定的 shape 图形；
 如果只设置 currentApplianceName 为 shape，iOS 端会默认设置为三角形
 @since 2.12.24
 */
@property (nonatomic, strong, readwrite, nullable) WhiteApplianceShapeTypeKey shapeType;

@end

NS_ASSUME_NONNULL_END
