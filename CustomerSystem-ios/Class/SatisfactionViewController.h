//
//  SatisfactionViewController.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMessageModel.h"
@protocol SatisfactionDelegate <NSObject>

@optional
- (void)commitSatisfactionWithExt:(NSDictionary*)ext messageModel:(id<IMessageModel>)model;

@required

- (void)backFromSatisfactionViewController;

@end

@interface SatisfactionViewController : UIViewController

@property (nonatomic, strong) id<IMessageModel> messageModel;
@property (nonatomic, weak) id<SatisfactionDelegate> delegate;

@property(nonatomic,copy) void(^EvaluateSuccessBlock)();

@end
