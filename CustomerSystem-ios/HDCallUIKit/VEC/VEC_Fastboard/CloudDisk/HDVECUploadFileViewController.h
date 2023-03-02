//
//  HDUploadFileViewController.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVECUploadFileViewController : UIViewController
typedef void (^HDVECUploadFileResultBlock)(NSDictionary *dic);
typedef void (^HDVECUploadFileDismissBlock)(UIViewController * vc);
@property (nonatomic, copy) HDVECUploadFileResultBlock hdUploadFileResultBlock;
@property (nonatomic, copy) HDVECUploadFileDismissBlock hdUploadFileDismissBlock;

/** 单利创建 - Method
*/
 
+ (instancetype)sharedManager;
 
/** 单利销毁 - Method
*/
 
- (void)removeSharedManager;

@end

NS_ASSUME_NONNULL_END
