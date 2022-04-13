//
//  LeaseMsgReplyController.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaseMsgReplyControllerDelegate <NSObject>

- (void)didSelectSendButtonWithParameters:(NSDictionary*)parameters;

@end

@interface LeaseMsgReplyController : UIViewController

@property (nonatomic, strong) id<LeaseMsgReplyControllerDelegate> delegate;

//清除语音缓存
+ (void)resetFile;

@end
