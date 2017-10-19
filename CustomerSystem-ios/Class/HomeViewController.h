//
//  HomeViewController.h
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/13.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDChatViewController.h"

//#import "EaseMob.h"

static NSString *g_appkey = nil;
static NSString *g_cname = nil;

@interface HomeViewController : UITabBarController

@property(nonatomic,strong)HDChatViewController *curChat; //当前聊天界面

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;


//- (void)networkChanged:(EMConnectionState)connectionState;

@end
