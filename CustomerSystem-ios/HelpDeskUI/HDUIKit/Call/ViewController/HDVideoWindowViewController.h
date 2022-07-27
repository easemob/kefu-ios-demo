//
//  HDUploadFileViewController.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVideoWindowViewController : UIViewController


/** 单利创建 - Method
*/
 
+ (instancetype)sharedManager;
 
/** 单利销毁 - Method
*/
 
- (void)removeSharedManager;

/**
 *  界面展示
 */
- (void)showView;
/**
 *  界面隐藏
 */
-(void)hideView;

/**
 *  界面移除
 */
- (void)removeView;
@end

NS_ASSUME_NONNULL_END
