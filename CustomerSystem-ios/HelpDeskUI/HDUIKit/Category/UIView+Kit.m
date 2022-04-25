//
//  UIView+FLExtension.m
//  FLPictureBrowser
//
//  Created by ease
//

#import "UIView+Kit.h"
#import <objc/runtime.h>
@implementation UIView (Kit)
+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)hd_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view hd_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)hd_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.hd_colors = [colorsM copy];
    self.hd_locations = locations;
    self.hd_startPoint = startPoint;
    self.hd_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)hd_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(hd_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.hd_colors];
    }
}

- (NSArray<NSNumber *> *)hd_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHd_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(hd_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.hd_locations];
    }
}

- (CGPoint)hd_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setHd_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(hd_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.hd_startPoint];
    }
}

- (CGPoint)hd_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setHd_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(hd_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.hd_endPoint];
    }
}


//隐藏所有键盘
- (void)hideKeyBoard{

    for (UIWindow* window in [UIApplication sharedApplication].windows){

        for (UIView* view in window.subviews){

            [self dismissAllKeyBoardInView:view];

        }
    }

}
-(BOOL) dismissAllKeyBoardInView:(UIView *)view{
    if([view isFirstResponder]) {
        
        [view resignFirstResponder];
        
        return YES;
        
    }
    for(UIView *subView in view.subviews){
        if([self dismissAllKeyBoardInView:subView]){
            return YES;
        }
    }
    
    return NO;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame =frame;
}

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y= originY;
    self.frame =frame;
}

- (CGFloat)originX {
    return self.frame.origin.x;
}


- (CGFloat)originY {
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    self.frame =frame;
    
}
-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame =frame;
}

-(CGFloat)width
{
    return self.frame.size.width;
    
}

-(CGFloat)height
{
    return self.frame.size.height;
    
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    self.frame =frame;
    
    
}

-(CGSize)size
{
    
    return self.frame.size;
    
}

-(void)setOrigin:(CGPoint)origin
{
    
    CGRect frame =self.frame;
    frame.origin =origin;
    self.frame = frame;
}


-(CGPoint)origin
{
    return self.frame.origin;
    
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
@end
@implementation UILabel (Kit)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
