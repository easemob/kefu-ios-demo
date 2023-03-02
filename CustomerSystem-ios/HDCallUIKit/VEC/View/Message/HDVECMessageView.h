//
//  HDVideoMessageView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/25.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HDVECClickCloseMessageBlock)(UIButton *btn);
@interface HDVECMessageView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property(nonatomic,copy)HDVECClickCloseMessageBlock clickCloseMessageBlock;
@end

NS_ASSUME_NONNULL_END
