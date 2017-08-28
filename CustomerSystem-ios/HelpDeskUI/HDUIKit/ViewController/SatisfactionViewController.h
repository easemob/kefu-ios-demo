//
//  SatisfactionViewController.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"
@protocol SatisfactionDelegate <NSObject>

@optional
- (void)commitSatisfactionWithControlArguments:(ControlArguments *)arguments type:(ControlType *)type evaluationTagsArray:(NSMutableArray *)tags;

@required

- (void)backFromSatisfactionViewController;

@end

@interface SatisfactionViewController : UIViewController

@property (nonatomic, strong) id<HDIMessageModel> messageModel;
@property (nonatomic, weak) id<SatisfactionDelegate> delegate;

@property(nonatomic,copy) void(^EvaluateSuccessBlock)();

@end
