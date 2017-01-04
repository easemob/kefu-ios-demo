//
//  HTextMessageBody.h
//  helpdesk_sdk
//
//  Created by afanda on 1/3/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HMessageBody.h"

/*!
 *  \~chinese
 *  文本消息体
 *
 *  \~english
 *  Text message body
 */
@interface HTextMessageBody : HMessageBody

/*!
 *  \~chinese
 *  文本内容
 *
 *  \~english
 *  Text content
 */
@property (nonatomic, copy, readonly) NSString *text;

/*!
 *  \~chinese
 *  初始化文本消息体
 *
 *  @param aText   文本内容
 *
 *  @result 文本消息体实例
 *
 *  \~english
 *  Initialize a text message body instance
 *
 *  @param aText   Text content
 *
 *  @result Text message body instance
 */
- (instancetype)initWithText:(NSString *)aText;

@property(nonatomic,strong) EMTextMessageBody *textMessagBody;

@end
