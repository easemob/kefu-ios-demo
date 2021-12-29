/*!
 *  \~chinese
 *  @header EMCmdMessageBody.h
 *  @abstract 命令消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCmdMessageBody.h
 *  @abstract Command message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "EMCommonDefs.h"
#import "EMMessageBody.h"

/*!
 *  \~chinese
 *  自定义消息体
 *
 *  \~english
 *  Custom message body
 */
@interface EMCustomMessageBody : EMMessageBody

@property (nonatomic, copy) NSString *event;

@property (nonatomic, copy) NSDictionary<NSString *,NSString *> *customExt;

- (instancetype)initWithEvent:(NSString *)aEvent customExt:(NSDictionary<NSString *,NSString *> *)aCustomExt;

#pragma mark - EM_DEPRECATED_IOS 3.7.2

@property (nonatomic, copy) NSDictionary *ext; EM_DEPRECATED_IOS(3_6_5, 3_7_2, "Use - customExt");

- (instancetype)initWithEvent:(NSString *)aEvent ext:(NSDictionary *)aExt; EM_DEPRECATED_IOS(3_6_5, 3_7_2, "Use - initWithEvent:customExt:");

@end
