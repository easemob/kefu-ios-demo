//
//  HDAgoraVideoSession.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HDAgoraVideoSession : NSObject
@property (assign, nonatomic) NSUInteger uid;
@property (strong, nonatomic) UIView *hostingView;
@property (strong, nonatomic) HDAgoraRtcVideoCanvas *canvas;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) BOOL isVideoMuted;
@property (nonatomic, strong) NSString * memberName;
@property (nonatomic, strong) NSDictionary * extension;
+ (instancetype)localSession;
- (instancetype)initWithUid:(NSUInteger)uid;

@end


