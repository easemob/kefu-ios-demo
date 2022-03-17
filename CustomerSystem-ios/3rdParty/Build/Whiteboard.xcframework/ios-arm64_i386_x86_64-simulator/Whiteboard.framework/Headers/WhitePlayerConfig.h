//
//  WhitePlayerConfig.h
//  WhiteSDK
//
//  Created by yleaf on 2019/3/1.
//

#import "WhiteObject.h"
#import "WhiteConsts.h"
#import "WhiteCameraBound.h"

NS_ASSUME_NONNULL_BEGIN

/** 用于配置白板回放房间对象。 */
@interface WhitePlayerConfig : WhiteObject


- (instancetype)init NS_UNAVAILABLE;
/**
 设置 Room Token 并初始化 `WhitePlayerConfig` 对象。
 
 @param roomUuid 房间 UUID，即房间唯一标识符。 
 @param roomToken 用于鉴权的 Room Token。
 @return 初始化的 `WhitePlayerConfig` 对象
 */
- (instancetype)initWithRoom:(NSString *)roomUuid roomToken:(NSString *)roomToken;

/** 
 待回放的互动白板房间所在的数据中心。

 数据中心包括：

 - `"cn-hz"`：中国大陆
 - `"us-sv"`：美国
 - `"in-mum"`：印度
 - `"sg"`：新加坡
 - `"gb-lon"`：英国
 
 @since 2.11.0 */
@property (nonatomic, strong, nullable) WhiteRegionKey region;

/** 房间 UUID，即房间唯一标识符。 */
@property (nonatomic, copy) NSString *room;

/** 用于鉴权的 Room Token。 */
@property (nonatomic, copy) NSString *roomToken;

@property (nonatomic, copy, nullable) NSString *slice;

/** 白板回放的起始时间。

Unix 时间戳（毫秒），表示回放的起始 UTC 时间。例如，`1615370614269` 表示 2021-03-10 18:03:34 GMT+0800。 */
@property (nonatomic, strong, nullable) NSNumber *beginTimestamp;

/** 白板回放的持续时长（秒）。如果没有设置，回放会从起始时间一直持续到退出房间。 */
@property (nonatomic, strong, nullable) NSNumber *duration;

/** 白板回放的音频地址。

 **Note:** 

 - 即使传入视频地址，也只会播放音频部分。
 - 如需显示视频画面，请使用 [WhiteCombinePlayer](WhiteCombinePlayer) 方法。
 */
@property (nonatomic, strong, nullable) NSString *mediaURL;

/**
 SDK 回调播放进度的频率（秒）。默认为 0.5 秒。
 */
@property (nonatomic, strong) NSNumber *step;

/** 视角边界，详见 [WhiteCameraBound](WhiteCameraBound)。 */
@property (nonatomic, strong, nullable) WhiteCameraBound *cameraBound;

@end

@interface WhitePlayerConfig (Deprecated)

/** 
 已废弃，请使用 [mediaURL](mediaURL)。
 */
@property (nonatomic, strong, nullable) NSString *audioUrl DEPRECATED_MSG_ATTRIBUTE("use mediaURL property");

@end

NS_ASSUME_NONNULL_END
