//
//  HRobotUnsolveItemView.h
//  SelectItemView
//
//  Created by 杜洁鹏 on 2019/10/15.
//  Copyright © 2019 Easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HRobotUnsolveItemView;
@protocol HRobotUnsolveItemViewDelegate <NSObject>

- (void)submitView:(HRobotUnsolveItemView *)aView list:(NSArray *)tags message:(HDMessage *)aMsg;
- (void)dismissView:(HRobotUnsolveItemView *)aView;

@end

@interface HRobotUnsolveItemView : UIView
@property (nonatomic, assign) id <HRobotUnsolveItemViewDelegate> delegate;
- (instancetype)initWithList:(NSArray *)aList
                      message:(HDMessage *)aMsg;
@end

NS_ASSUME_NONNULL_END
