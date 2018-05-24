//
//  HDCallViewController.h
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/8.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDCallViewController : UIViewController
@property (nonatomic, copy) void (^callback)(HDCallViewController *callVC, NSString *timeStr);

// 根据被叫初始化HDCallVC
+ (HDCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName;

@end
