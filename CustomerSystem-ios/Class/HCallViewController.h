//
//  HCallViewController.h
//  CustomerSystem-ios
//
//  Created by __阿彤木_ on 3/20/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCallViewController : UIViewController

@property (strong, nonatomic, readonly) HCallSession *callSession;

@property (nonatomic) BOOL isDismissing;

- (instancetype)initWithCallSession:(HCallSession *)aCallSession;

//通话通道已建立
- (void)stateToConnected;

//视频已经建立
- (void)didConnected;

//视频数据传输状态改变
- (void)setStatusWithStatus:(HCallStreamingStatus)status;
//网络状态改变
- (void)setNetworkWithNetworkStatus:(HCallNetworkStatus)status;

- (void)clearData;


@end
