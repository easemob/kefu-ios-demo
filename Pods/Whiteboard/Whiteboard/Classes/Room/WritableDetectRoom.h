//
//  WritableDetectRoom.h
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/17.
//

#if DEBUG
#import "WhiteRoom.h"

NS_ASSUME_NONNULL_BEGIN

/// isa exchanged room, just in debug mode
@interface WritableDetectRoom : WhiteRoom

+ (void)startObserveRoom:(WhiteRoom *)room;

@end

NS_ASSUME_NONNULL_END
#endif
