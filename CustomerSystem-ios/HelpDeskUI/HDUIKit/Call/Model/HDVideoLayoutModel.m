//
//  HDVideoLayoutModel.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoLayoutModel.h"

@implementation HDVideoLayoutModel

- (NSString *)initialWelcome{
    
    return @"您好！有什么需要帮助，可以发起视频通话进行咨询呦,";
    
}
- (NSString *)initiateWelcome{
    
    
    return @"您好！您正在发起视频通话进行咨询。";
}
- (NSString *)lineUpCluesWelcome{
    
    return @"您好！客服人员正在马不停蹄的赶过来，请您耐心等待！";
}
-(NSString *)endCluesWelcome{
    
    return @"感谢您的咨询，祝您生活愉快！";
    
}
@end
