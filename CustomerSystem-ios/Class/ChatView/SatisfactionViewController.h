//
//  SatisfactionViewController.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol SatisfactionDelegate <NSObject>

@optional
- (void)commitSatisfactionWithExt:(NSDictionary*)ext messageModel:(MessageModel*)model;

@end

@interface SatisfactionViewController : UIViewController

@property (nonatomic, strong) MessageModel *messageModel;
@property (nonatomic, weak) id<SatisfactionDelegate> delegate;

@end
