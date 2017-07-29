//
//  HDCallLocalView.h
//  HRTCDemo
//
//  Created by afanda on 7/27/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "EMCallLocalView.h"

@protocol HDCallLocalViewDelegate <NSObject>

- (void)restoreBtnClicked;

@end

@interface HDCallLocalView : EMCallLocalView

@property(nonatomic,strong) UIButton *restoreBtn;
@property(nonatomic,copy) id<HDCallLocalViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
@end
