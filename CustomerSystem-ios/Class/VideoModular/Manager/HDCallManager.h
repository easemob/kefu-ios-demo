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
#import "MockData.h"

@interface HDCallManager : NSObject<EMediaSessionDelegate,HDCallBackViewDelegate>


@property(nonatomic,strong) UIViewController *rootViewController;

@property(nonatomic,strong) HDCallViewController *currentCallVC;
@property(nonatomic,strong) EMediaSession *currentSession;

+ (instancetype)sharedInstance;


- (void)receiveVideoRequestExtension:(NSDictionary *)extension;

- (void)exitSession;

- (void)acceptVideoRequest;

//发布一个流
- (void) publish:(EMediaSession *) session publishConfig:(EMediaPublishConfiguration *)config onDone:(EMediaIdBlockType)block;

//离开一个会话
- (void) exit:(EMediaSession *) session onDone:(EMediaIdBlockType)block;

- (void)reLayoutVideos;

//设置扬声器
- (void)setSpeakEnable:(BOOL)enable;




- (NSString *)getExt;

@end
