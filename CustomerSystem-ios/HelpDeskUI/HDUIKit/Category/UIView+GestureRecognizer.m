//
//  UIView+GestureRecognizer.m
//  WSGameCenter
//
//  Created by lcyu on 2017/7/21.
//  Copyright © 2017年 com. All rights reserved.
//

#import "UIView+GestureRecognizer.h"
#import <objc/runtime.h>

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
@implementation UIView (GestureRecognizer)

- (void)setTapActionWithBlock:(void (^)(void))block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (UIGestureRecognizer *)getGR
{
    return objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action) {
            action();
        }
//        !action?:
    }
}

+(instancetype)viewFromXib
{

    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    return view;
}

+ (instancetype)viewFromBundleXib{
    
    //获取bundle
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Res" ofType:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        // 加载 nib 文件
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:resourceBundle];
        NSArray *viewObjs = [nib instantiateWithOwner:nil options:nil];
        // 获取 xib 文件
        UIView *view = viewObjs.firstObject;
    
        return view;
}
@end
