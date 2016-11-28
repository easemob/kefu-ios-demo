//
//  LeaveMsgDetailHeaderView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeaveMsgDetailModel;
@interface LeaveMsgDetailHeaderView : UITableView

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary*)dictionary;

- (void)setDetail:(NSDictionary*)dictionary;

- (LeaveMsgDetailModel*)getMsgDetailModel;

@end
