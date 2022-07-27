//
//  WhiteSocket+Private.h
//  Whiteboard
//
//  Created by yleaf on 2021/11/2.
//

#import "WhiteSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteSocket (Private)


- (instancetype)initWithBridge:(WhiteBoardView *)bridge;
- (void)releaseSocket;

@end

NS_ASSUME_NONNULL_END
