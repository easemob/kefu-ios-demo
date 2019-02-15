//
//  UIViewController+AlertController.m
//  easemob-OA
//
//  Created by 杜洁鹏 on 2018/8/8.
//  Copyright © 2018年 EaseMob. All rights reserved.
//

#import "UIViewController+AlertController.h"

@interface EOAAlertAction : UIAlertAction
@property (nonatomic, assign) NSInteger index;
@end

@implementation EOAAlertAction
+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(UIAlertActionStyle)style
                          index:(NSInteger)aIndex
                        handler:(void (^ __nullable)(UIAlertAction *action, NSInteger index))handler {
    __block EOAAlertAction *btn = (EOAAlertAction *)[super actionWithTitle:title
                                                                     style:style
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       if (handler) {
                                                                           handler(action, btn.index);
                                                                       }
                                                                   }];
    btn.index = aIndex;
    return btn;
}

@end

@implementation UIViewController (AlertController)

- (void)showAlertWithTitle:(NSString *)aTitle
              actionTitles:(NSArray *)titles
               cancelTitle:(NSString *)aCancelTitle
                  callBack:(void (^)(NSInteger index))aCallBack {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:aTitle preferredStyle:UIAlertControllerStyleActionSheet];
    int i = 0;
    for (NSString *title in titles) {
        EOAAlertAction *action = [EOAAlertAction actionWithTitle:title
                                                           style:UIAlertActionStyleDefault
                                                           index:i
                                                         handler:^(UIAlertAction *action, NSInteger index)
                                  {
                                      if (aCallBack) {
                                          aCallBack(index);
                                      }
                                  }];
        [alertController addAction:action];
        i++;
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:aCancelTitle style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
