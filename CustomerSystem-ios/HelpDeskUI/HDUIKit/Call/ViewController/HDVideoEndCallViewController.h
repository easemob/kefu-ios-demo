//
//  HDVideoEndCallViewController.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/13.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVideoAnswerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDVideoEndCallViewController : UIViewController
@property (nonatomic, strong) HDVideoAnswerView *hdVideoAnswerView;
/** 单利创建 - Method
*/
 
+ (instancetype)sharedManager;
 
/** 单利销毁 - Method
*/
 
- (void)removeSharedManager;

@end

NS_ASSUME_NONNULL_END
