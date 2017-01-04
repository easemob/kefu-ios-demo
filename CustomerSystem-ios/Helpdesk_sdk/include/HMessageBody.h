//
//  HMessageBody.h
//  helpdesk_sdk
//
//  Created by afanda on 1/3/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
typedef enum{
    HMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
    HMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
    HMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
    HMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
    HMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
    HMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
    HMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Command */
}HMessageBodyType;

/*!
 *  \~chinese
 *  消息体
 *
 *  \~english
 *  Message body
 */
@interface HMessageBody : NSObject

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
@property (nonatomic, readonly) HMessageBodyType type;

@property (nonatomic, strong) EMMessageBody *messageBody;

- (instancetype)initWithEMMessageBody:(EMMessageBody *)messageBody;


@end
