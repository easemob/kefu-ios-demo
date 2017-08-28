//
//  HDCallBackView.h
//  HRTCDemo
//
//  Created by afanda on 7/27/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HDCallBackViewDelegate <NSObject>

- (void)restoreBtnClicked;

@end
@interface HDCallBackView : UIView

@property(nonatomic,strong) UILabel  *nameLabel;
@property(nonatomic,strong) UIButton *restoreBtn;

@property(nonatomic,assign) id<HDCallBackViewDelegate> delegate;


- (void)addSubviewRestoreBtn;
- (void)addSubviewNameLabel;
@end
