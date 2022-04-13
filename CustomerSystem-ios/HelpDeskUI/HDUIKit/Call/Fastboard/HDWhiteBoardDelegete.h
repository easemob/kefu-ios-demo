//
//  HDWhiteBoardDelegete.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDWhiteBoardDelegete <NSObject>
@optional
/*!
 *  \~chinese
 *  加入白板房间
 *
 */
- (void)onFastboardDidJoinRoomSuccess;
@end

NS_ASSUME_NONNULL_END
