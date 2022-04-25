//
//  WhiteDisplayerState+Private.h
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/29.
//

#import "WhiteDisplayerState.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhiteDisplayerState (Private)

+ (WhiteGlobalState *)getGlobalStateInstanceFromJSON:(NSString *)json;

@end

NS_ASSUME_NONNULL_END
