//
//  HDVideoLayoutModel.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoLayoutModel.h"

@implementation HDVideoLayoutModel

- (void)setSkipWaitingPage:(NSInteger)skipWaitingPage{
    
    _skipWaitingPage = skipWaitingPage;
    if (skipWaitingPage == 1) {
        // 是 yes
        
        _isSkipWaitingPage = YES;
    }else{
        
        _isSkipWaitingPage = NO;
    }
}
- (void)setVisitorCameraOff:(NSInteger)visitorCameraOff{
    _visitorCameraOff = visitorCameraOff;
    if (visitorCameraOff == 1) {
        // 是 yes
        
        _isVisitorCameraOff = YES;
    }else{
        
        _isVisitorCameraOff = NO;
    }
}

- (NSString *)waitingPrompt{

    return NSLocalizedString(@"video.call.init.waitingPrompt", @"您好！有什么需要帮助，可以发起视频通话进行咨询呦,");

}
- (NSString *)callingPrompt{

    return NSLocalizedString(@"video.call.init.callingPrompt", @"您好！您正在发起视频通话进行咨询。");
}
- (NSString *)queuingPrompt{

    return NSLocalizedString(@"video.call.init.queuingPrompt", @"您好！客服人员正在马不停蹄的赶过来，请您耐心等待！");
}
-(NSString *)endingPrompt{

    return NSLocalizedString(@"video.call.init.endingPrompt", @"感谢您的咨询，祝您生活愉快！");

}
@end
