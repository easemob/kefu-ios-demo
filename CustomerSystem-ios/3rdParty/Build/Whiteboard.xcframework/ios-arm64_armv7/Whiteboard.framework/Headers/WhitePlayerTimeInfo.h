//
//  WhitePlayerTimeInfo.h
//  WhiteSDK
//
//  Created by yleaf on 2019/2/28.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 白板回放的播放时间信息。 */
@interface WhitePlayerTimeInfo : WhiteObject

/** 当前的回放进度（秒）。 */
@property (nonatomic, assign, readonly) NSTimeInterval scheduleTime;

/** 回放的总时长（秒）。 */
@property (nonatomic, assign, readonly) NSTimeInterval timeDuration;

/** 回放的总 frame 数。 */
@property (nonatomic, assign, readonly) NSInteger framesCount;

/** 回放的起始时间。

 UTC 时间戳（秒），你需要自行转换为 UTC 时间。
 
 例如，如果返回 `1615370614.269`，表示的 UTC 时间为 2021-03-10 18:03:34 GMT+0800。 */
@property (nonatomic, assign, readonly) NSTimeInterval beginTimestamp;

@end

NS_ASSUME_NONNULL_END
