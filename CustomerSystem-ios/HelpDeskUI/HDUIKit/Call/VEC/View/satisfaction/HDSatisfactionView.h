//
//  HDSatisfactionView.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"
#import "CWStarRateView.h"
#import "HDSatisfactionEvaluationTagView.h"
#import "HEvaluationDegreeModel.h"
#import "HAppraiseTagsModel.h"
#import "HDAccountmanager.h"
#import "SKTagView.h"
NS_ASSUME_NONNULL_BEGIN

#define kViewSpace 20.f
@protocol HDSatisfactionDelegate <NSObject>

@optional
- (void)commitSatisfactionWithControlArguments:(ControlArguments *)arguments type:(ControlType *)type evaluationTagsArray:(NSMutableArray *)tags evaluationDegreeId:(NSNumber *)evaluationDegreeId;

@required

- (void)backFromSatisfactionViewController;

@end

@interface HDSatisfactionView : UIView
typedef void(^UpdateSelfFrame)(CGFloat height);
@property (nonatomic, strong) id<HDIMessageModel> messageModel;
@property (nonatomic, weak) id<SatisfactionDelegate> delegate;

@property (nonatomic,copy) void(^EvaluateSuccessBlock)();
@property (nonatomic,copy) UpdateSelfFrame updateSelfFrame;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) CWStarRateView *starRateView;
@property (nonatomic, strong) UILabel *evaluateTitle;
//@property (nonatomic, strong) HDSatisfactionEvaluationTagView *evaluationTagView;
@property (nonatomic, strong) SKTagView *evaluationTagView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) NSMutableDictionary *evaluationTagsDict;
@property (nonatomic, strong) NSMutableArray *evaluationTagsArray;


- (void)setEnquiryInvite:(NSDictionary *)enquiryInvite withModel:(HDMessage *)message;
@end

NS_ASSUME_NONNULL_END
