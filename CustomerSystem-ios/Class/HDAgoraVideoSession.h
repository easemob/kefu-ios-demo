//
//  HDAgoraVideoSession.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/1/10.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HDCallViewCollectionViewCellItem;
@interface HDAgoraVideoSession : NSObject
@property (assign, nonatomic) NSUInteger uid;
@property (strong, nonatomic) UIView *hostingView;
@property (strong, nonatomic) HDAgoraRtcVideoCanvas *canvas;
@property (nonatomic, strong) HDCallViewCollectionViewCellItem  * item;
+ (instancetype)localSession;
- (instancetype)initWithUid:(NSUInteger)uid;

@end


