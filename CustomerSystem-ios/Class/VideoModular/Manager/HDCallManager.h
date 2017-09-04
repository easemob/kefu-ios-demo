//
//  HDCallManager.h
//  HRTCDemo
//
//  Created by afanda on 7/26/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCallViewController.h"
#define KWH kScreenWidth/2

@interface HDCallManager : NSObject<HCallManagerDelegate,HDCallBackViewDelegate>

@property(nonatomic,strong) HCallLocalView *localView;

@property(nonatomic,strong) UIViewController *rootViewController;

@property(nonatomic,strong) HDCallViewController *currentCallVC;

+ (instancetype)sharedInstance;

- (void)exitSession;

//接受视频邀请
- (void)acceptCallCompletion:(void (^)(id obj, HError *error))completion;



//离开一个会话
- (void)endCall;

- (void)reLayoutVideos;

//设置扬声器
- (void)setSpeakEnable:(BOOL)enable;


@end
