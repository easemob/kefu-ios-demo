//
//  UIViewController+VLDModal.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/18.
//  Copyright © 2022 easemob. All rights reserved.
//
// iOS 13.0 之 presentViewController 模态全屏适配解决方案 如果需要全局 UIViewController 适配。可以打开以下方法
#import "UIViewController+VLDModal.h"
#import <objc/runtime.h>
@implementation UIViewController (VLDModal)


//+ (void)load{
//
//    SEL originalSel = @selector(presentViewController:animated:completion:);
//    SEL overrideSel = @selector(override_presentViewController:animated:completion:);
//
//    Method originalMet = class_getInstanceMethod(self.class, originalSel);
//    Method overrideMet = class_getInstanceMethod(self.class, overrideSel);
//
//    method_exchangeImplementations(originalMet, overrideMet);
//}
//
//#pragma mark - Swizzling
//- (void)override_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
//    if(@available(iOS 13.0, *)){
//        if (viewControllerToPresent.modalPresentationStyle ==  UIModalPresentationPageSheet){
//            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
//        }
//    }
//
//    [self override_presentViewController:viewControllerToPresent animated:flag completion:completion];
//}
@end
