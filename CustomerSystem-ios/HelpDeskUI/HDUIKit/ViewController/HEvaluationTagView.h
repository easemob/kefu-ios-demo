//
//  HEvaluationTagView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/24.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEvaluationDegreeModel.h"

@protocol HEvaluationTagSelectDelegate <NSObject>

- (void)evaluationTagSelectWithArray:(NSArray *)tags;

@end

@interface HEvaluationTagView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) HEvaluationDegreeModel *evaluationDegreeModel;

@property (nonatomic, weak) id<HEvaluationTagSelectDelegate> delegate;

@end
