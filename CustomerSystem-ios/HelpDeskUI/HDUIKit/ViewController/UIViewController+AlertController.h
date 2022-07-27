//
//  UIViewController+AlertController.h
//  easemob-OA
//
//  Created by 杜洁鹏 on 2018/8/8.
//  Copyright © 2018年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertController)
- (void)showAlertWithTitle:(NSString *)aTitle
    actionTitles:(NSArray *)titles
                cancelTitle:(NSString *)aCancelTitle
                   callBack:(void (^)(NSInteger index))aCallBack;
@end
