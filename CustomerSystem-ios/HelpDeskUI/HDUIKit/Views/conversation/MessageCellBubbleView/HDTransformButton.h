//
//  HDTransformButton.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickTransformBlock)(UIButton *btn);
@interface HDTransformButton : UIButton
@property (nonatomic, copy) ClickTransformBlock clickTransformBlock;
- (void)setTransformButtonBackgroundColorWithEnable:(BOOL)enable withTitle:(NSString *)title withHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
