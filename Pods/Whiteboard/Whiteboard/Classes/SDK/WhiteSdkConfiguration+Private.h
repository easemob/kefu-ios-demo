//
//  WhiteSdkConfiguration+Private.h
//  Whiteboard
//
//  Created by yleaf on 2020/8/13.
//

#import "WhiteSdkConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteSdkConfiguration ()

@property (nonatomic, assign) BOOL enableRtcIntercept;
@property (nonatomic, copy) NSArray<NSString *> *netlessUA;

@end

NS_ASSUME_NONNULL_END
