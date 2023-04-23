//
//  UIButton+HD.h
//  CustomerSystem-ios
//
//  Created by easemob on 2023/4/23.
//  Copyright © 2023 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HD)
/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

@end

NS_ASSUME_NONNULL_END
