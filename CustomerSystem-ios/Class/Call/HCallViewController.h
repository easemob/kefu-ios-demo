//
//  HCallViewController.h
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/8.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCallViewController : UIViewController
@property (nonatomic, copy) void (^callback)(HCallViewController *callVC, NSString *timeStr);

// 根据被叫初始化HCallVC
+ (HCallViewController *)hasReceivedCallWithAgentName:(NSString *)aAgentName;

@end
