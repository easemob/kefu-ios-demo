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

@property (nonatomic, assign) BOOL visitorCameraOff;
@property (nonatomic, assign) BOOL skipWaitingPage;

@property (nonatomic, strong) NSString *WaitingPrompt;
@property (nonatomic, strong) NSString *WaitingBackgroundPic;
@property (nonatomic, strong) NSString *CallingPrompt;
@property (nonatomic, strong) NSString *CallingBackgroundPic;
@property (nonatomic, strong) NSString *QueuingPrompt;
@property (nonatomic, strong) NSString *QueuingBackgroundPic;
@property (nonatomic, strong) NSString *EndingPrompt;
@property (nonatomic, strong) NSString *EndingBackgroundPic;
@end

NS_ASSUME_NONNULL_END
