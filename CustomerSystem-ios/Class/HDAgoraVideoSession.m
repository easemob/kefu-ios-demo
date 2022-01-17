//
//  HDAgoraVideoSession.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDAgoraVideoSession.h"

@implementation HDAgoraVideoSession
+ (instancetype)localSession {
    return [[HDAgoraVideoSession alloc] initWithUid:0];
}

- (instancetype)initWithUid:(NSUInteger)uid {
    if (self = [super init]) {
        self.uid = uid;
        self.hostingView.translatesAutoresizingMaskIntoConstraints = NO;
        self.canvas = [[HDAgoraRtcVideoCanvas alloc] init];
        self.canvas.uid = uid;
    }
    return self;
}
- (void)setHostingView:(UIView *)hostingView{
    
    _hostingView= hostingView;
    self.canvas.view = hostingView;
    
}
@end
