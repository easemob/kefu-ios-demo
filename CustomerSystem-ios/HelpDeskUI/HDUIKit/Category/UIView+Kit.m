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

- (void)setHd_originX:(CGFloat)hd_originX {
    CGRect frame = self.frame;
    frame.origin.x = hd_originX;
    self.frame =frame;
}

-(void)setHd_originY:(CGFloat)hd_originY {
    CGRect frame = self.frame;
    frame.origin.y= hd_originY;
    self.frame =frame;
}

- (CGFloat)hd_originX {
    return self.frame.origin.x;
}


- (CGFloat)hd_originY {
    return self.frame.origin.y;
}

-(void)setHd_width:(CGFloat)hd_width
{
    CGRect frame = self.frame;
    
    frame.size.width = hd_width;
    self.frame =frame;
    
}
-(void)setHd_height:(CGFloat)hd_height
{
    CGRect frame = self.frame;
    frame.size.height = hd_height;
    self.frame =frame;
}
-(CGFloat)hd_width
{
    return self.frame.size.width;
    
}
-(CGFloat)hd_height
{
    return self.frame.size.height;
    
}
-(void)setHd_size:(CGSize)hd_size
{
    CGRect frame = self.frame;
    
    frame.size = hd_size;
    self.frame =frame;
    
    
}
- (CGSize)hd_size
{
    
    return self.frame.size;
    
}
- (void)setHd_origin:(CGPoint)hd_origin
{
    CGRect frame =self.frame;
    frame.origin =hd_origin;
    self.frame = frame;
}

-(CGPoint)hd_origin
{
    return self.frame.origin;
    
}
-(CGFloat)hd_left
{
    return self.frame.origin.x;
}

//- (void)setLeft:(CGFloat)x
-(void)setHd_left:(CGFloat)hd_left
{
    CGRect frame = self.frame;
    frame.origin.x = hd_left;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}
//- (void)setTop:(CGFloat)y
-(void)setHd_top:(CGFloat)hd_top
{
    CGRect frame = self.frame;
    frame.origin.y = hd_top;
    self.frame = frame;
}
- (CGFloat)hd_right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setHd_right:(CGFloat)hd_right
{
    CGRect frame = self.frame;
    frame.origin.x = hd_right - frame.size.width;
    self.frame = frame;
}
-(CGFloat)hd_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setHd_bottom:(CGFloat)hd_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = hd_bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)hd_centerX
{
    return self.center.x;
}
-(void)setHd_centerX:(CGFloat)hd_centerX
{
    self.center = CGPointMake(hd_centerX, self.center.y);
}
- (CGFloat)hd_centerY
{
    return self.center.y;
}
- (void)setHd_centerY:(CGFloat)hd_centerY
{
    self.center = CGPointMake(self.center.x, hd_centerY);
}
@end
@implementation UILabel (Kit)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
