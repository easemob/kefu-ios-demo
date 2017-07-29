//
//  HPushOptions.h
//  helpdesk_sdk
//
//  Created by afanda on 2/6/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kPushNickname @"nickname"
#define kPushDisplayStyle @"notification_display_style"
#define kPushNoDisturbing @"notification_no_disturbing"
#define kPushNoDisturbingStartH @"notification_no_disturbing_start"
#define kPushNoDisturbingStartM @"notification_no_disturbing_startM"
#define kPushNoDisturbingEndH @"notification_no_disturbing_end"
#define kPushNoDisturbingEndM @"notification_no_disturbing_endM"

/*!
 *  \~chinese
 *  推送消息的显示风格
 *
 *  \~english
 *  Display style of push message
 */
typedef enum
{
    HPushDisplayStyleSimpleBanner = 0, /*!
                                        *  \~chinese
                                        *  简单显示"您有一条新消息"
                                        *
                                        *  \~english
                                        *  Simply show "You have a new message"
                                        */
    HPushDisplayStyleMessageSummary,   /*!
                                        *  \~chinese
                                        *  显示消息内容
                                        *
                                        *  \~english
                                        *  Show message's content
                                        */
}HPushDisplayStyle;

/*!
 *  \~chinese
 *  推送免打扰设置的状态
 *
 *  \~english
 *  Status of Push Notification no-disturb setting
 */
typedef enum{
    HPushNoDisturbStatusDay = 0,   /*! \~chinese 全天免打扰 \~english The whole day */
    HPushNoDisturbStatusCustom,    /*! \~chinese 自定义时间段免打扰 \~english User defined period */
    HPushNoDisturbStatusClose,     /*! \~chinese 关闭免打扰 \~english Close no-disturb mode */
}HPushNoDisturbStatus;

/*!
 *  \~chinese
 *  消息推送的设置选项
 *
 *  \~english
 *  Apple Push Notification setting options
 */
@interface HPushOptions : NSObject
/*!
 *  \~chinese
 *  推送消息显示的昵称
 *
 *  \~english
 *  User's nickname to be displayed in apple push notification service messages
 */
@property (nonatomic, copy) NSString *displayName;

/*!
 *  \~chinese
 *  推送消息显示的类型
 *
 *  \~english
 *  Display style of notification message
 */
@property (nonatomic) HPushDisplayStyle displayStyle;

/*!
 *  \~chinese
 *  消息推送的免打扰设置
 *
 *  \~english
 *  No disturbing setting of notification message
 */
@property (nonatomic) HPushNoDisturbStatus noDisturbStatus;

/*!
 *  \~chinese
 *  消息推送免打扰开始时间，小时，暂时只支持整点（小时）
 *
 *  \~english
 *  No disturbing mode start time (in hour)
 */
@property (nonatomic) NSInteger noDisturbingStartH;

/*!
 *  \~chinese
 *  消息推送免打扰结束时间，小时，暂时只支持整点（小时）
 *
 *  \~english
 *  No disturbing mode end time (in hour)
 */
@property (nonatomic) NSInteger noDisturbingEndH;
@end
