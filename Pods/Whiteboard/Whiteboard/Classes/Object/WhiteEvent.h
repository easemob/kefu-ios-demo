//
//  WhiteEvent.h
//  WhiteSDK
//
//  Created by yleaf on 2018/10/9.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** SDK 可以触发的自定义事件回调。 */
@interface WhiteEvent : WhiteObject

/** 指定回调事件名称和内容并初始化一个 `WhiteEvent` 对象。
 @param eventName 回调事件名称。

 @param payload 回调事件内容。

 @return 初始化的 `WhiteEvent` 对象。
 */
- (instancetype)initWithName:(NSString *)eventName payload:(id)payload;

/** 回调事件名称。 */
@property (nonatomic, strong) NSString *eventName;

/**
 回调事件内容。
 消息格式取决于发送方，可以为 NSArray（内部元素也需要可以被转换成 JSON ），NSString，NSDictionary，NSNumber（with Boolean，NSInteger，CGFloat）等可以在 JSON 中正常展示的类型。

 */
@property (nonatomic, strong, nullable) id payload;

/** 白板房间号。 */
@property (nonatomic, strong, readonly) NSString *uuid;

/**
 发送事件的用户角色。包括 `system`，`app`，`custom`，`magix`，自定义事件为 `custom`。
 */
@property (nonatomic, strong, readonly) NSString *scope;

/**
 发送事件的用户。
 */
@property (nonatomic, strong, readonly) NSString *authorId;

@end

NS_ASSUME_NONNULL_END
