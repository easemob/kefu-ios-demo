//
//  HDVideoAnswerCallBackView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/7.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVideoVerticalAlignmentLabel.h"
#import "MBProgressHUD+Add.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^HDVECClickVideoAnswerCallBlock)(UIButton *btn);
typedef void(^HDVECClickCloseRefuseAnswerCallBlock)(UIButton *btn);
@interface HDVECAnswerCallBackView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *onBtn;
@property (nonatomic, strong) UIButton *offBtn;
@property (nonatomic, strong) HDVideoVerticalAlignmentLabel *answerLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, copy) HDVECClickVideoAnswerCallBlock clickVideoAnswerCallBlock;
@property (nonatomic, copy) HDVECClickCloseRefuseAnswerCallBlock clickCloseRefuseAnswerCallBlock;
@end

NS_ASSUME_NONNULL_END
