//
//  UIButton+HD.m
//  CustomerSystem-ios
//
//  Created by easemob on 2023/4/23.
//  Copyright © 2023 easemob. All rights reserved.
//

#import "UIButton+HD.h"
#import <objc/runtime.h>
#define defaultInterval 0.5  //默认时间间隔

@interface UIButton ()

/**
 *  bool YES 忽略点击事件   NO 允许点击事件
 */
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end
static const char *UIControl_eventTimeInterval = "UIControl_eventTimeInterval";
static const char *UIControl_enventIsIgnoreEvent = "UIControl_enventIsIgnoreEvent";
@implementation UIButton (HD)
// runtime 动态绑定 属性
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
    
- (BOOL)isIgnoreEvent{

    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent) boolValue];
}

- (NSTimeInterval)eventTimeInterval{
       
    return [objc_getAssociatedObject(self, UIControl_eventTimeInterval) doubleValue];
}

- (void)setEventTimeInterval:(NSTimeInterval)eventTimeInterval{
   
    objc_setAssociatedObject(self, UIControl_eventTimeInterval, @(eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{   
    // Method Swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(_wxd_sendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self,selA);
        
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            //添加失败了 说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}
- (void)_wxd_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    self.eventTimeInterval = self.eventTimeInterval == 0 ? defaultInterval : self.eventTimeInterval;
    if (self.isIgnoreEvent){
        return;
    }else if (self.eventTimeInterval > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.eventTimeInterval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [self setIsIgnoreEvent:NO];
        });
    }
    self.isIgnoreEvent = YES;
    //这里看上去会陷入递归调用死循环，但在运行期此方法是和sendAction:to:forEvent:互换的，相当于执行sendAction:to:forEvent:方法，所以并不会陷入死循环。
    [self _wxd_sendAction:action to:target forEvent:event];
}


@end
