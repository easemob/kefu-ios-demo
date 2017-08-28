//
//  HDCallLocalView.h
//  HRTCDemo
//
//  Created by afanda on 7/27/17.
//  Copyright © 2017 easemob. All rights reserved.
//


@protocol HDCallLocalViewDelegate <NSObject>

- (void)restoreBtnClicked;

@end

@interface HDCallLocalView : HCallLocalView

@property(nonatomic,strong) UIButton *restoreBtn;
@property(nonatomic,copy) id<HDCallLocalViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
@end
