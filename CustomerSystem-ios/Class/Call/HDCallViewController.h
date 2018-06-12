//
//  HDCallViewController.h
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/8.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCallViewController : UIViewController
typedef void (^HangUpCallback)(HDCallViewController *callVC, NSString *timeStr);
@property (nonatomic, copy) HangUpCallback hangUpCallback;

// 根据被叫初始化HDCallVC
+ (HDCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName
                                        hangUpCallBack:(HangUpCallback)callback;

+ (HDCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName;

@end
