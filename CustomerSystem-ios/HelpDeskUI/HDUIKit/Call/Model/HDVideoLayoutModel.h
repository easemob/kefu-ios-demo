//
//  HDVideoLayoutModel.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDVideoLayoutModel : NSObject

@property (nonatomic, assign) BOOL isVisitorCameraOff;
@property (nonatomic, assign) BOOL isSkipWaitingPage;
@property (nonatomic, assign) NSInteger skipWaitingPage;
@property (nonatomic, assign) NSInteger visitorCameraOff;

@property (nonatomic, strong) NSString *waitingPrompt;
@property (nonatomic, strong) NSString *waitingBackgroundPic;
@property (nonatomic, strong) NSString *callingPrompt;
@property (nonatomic, strong) NSString *callingBackgroundPic;
@property (nonatomic, strong) NSString *queuingPrompt;
@property (nonatomic, strong) NSString *queuingBackgroundPic;
@property (nonatomic, strong) NSString *endingPrompt;
@property (nonatomic, strong) NSString *endingBackgroundPic;
@end

NS_ASSUME_NONNULL_END
