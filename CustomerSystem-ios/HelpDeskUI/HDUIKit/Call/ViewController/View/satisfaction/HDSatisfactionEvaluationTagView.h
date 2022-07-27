//
//  HDSatisfactionEvaluationTagView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEvaluationDegreeModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HDSatisfactionEvaluationTagSelectDelegate <NSObject>

- (void)evaluationTagSelectWithArray:(NSArray *)tags;

@end

@interface HDSatisfactionEvaluationTagView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) HEvaluationDegreeModel *evaluationDegreeModel;

@property (nonatomic, weak) id<HDSatisfactionEvaluationTagSelectDelegate> delegate;

@end


NS_ASSUME_NONNULL_END
