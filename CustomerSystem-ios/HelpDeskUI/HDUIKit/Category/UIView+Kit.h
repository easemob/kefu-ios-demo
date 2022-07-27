//
//  UIView+FLExtension.h
//  FLPictureBrowser
//
//  Created by ease
//

#import <UIKit/UIKit.h>

@interface UIView (Kit)
/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray *hd_colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray<NSNumber *> *hd_locations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

@property CGPoint hd_startPoint;
@property CGPoint hd_endPoint;

+ (UIView *_Nullable)hd_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)hd_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@property (nonatomic) CGFloat hd_originX;
@property (nonatomic) CGFloat hd_originY;
@property (nonatomic) CGFloat hd_left;
@property (nonatomic) CGFloat hd_top;
@property (nonatomic) CGFloat hd_right;
@property (nonatomic) CGFloat hd_bottom;
@property (nonatomic) CGFloat hd_width;
@property (nonatomic) CGFloat hd_height;
@property (nonatomic) CGFloat hd_centerX;
@property (nonatomic) CGFloat hd_centerY;
@property (nonatomic) CGPoint hd_origin;
@property (nonatomic) CGSize  hd_size;

//隐藏所有键盘
- (void)hideKeyBoard;
@end
