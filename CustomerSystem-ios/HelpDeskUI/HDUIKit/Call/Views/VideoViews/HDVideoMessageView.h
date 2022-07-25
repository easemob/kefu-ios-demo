//
//  HDVideoMessageView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickCloseMessageBlock)(UIButton *btn);
NS_ASSUME_NONNULL_BEGIN

@interface HDVideoMessageView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property(nonatomic,copy)ClickCloseMessageBlock clickCloseMessageBlock;
@end

NS_ASSUME_NONNULL_END
