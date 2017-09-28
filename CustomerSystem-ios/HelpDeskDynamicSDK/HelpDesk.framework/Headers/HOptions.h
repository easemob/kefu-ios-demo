//
//  HOptoins.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HOptions : NSObject

/*!
 *  \~chinese
 *  app唯一标识符
 *
 *  \~english
 *  Application's unique identifier
 */
@property (nonatomic, strong) NSString *appkey;

/*!
 *  \~chinese
 *  控制台是否输出log, 默认为NO
 *
 *  \~english
 *  Whether print log to console, default is NO
 */
@property (nonatomic, assign) BOOL enableConsoleLog;


/*!
 *  \~chinese
 *  租户ID
 *
 *  \~english
 *  tenantId
 */
@property(nonatomic,copy) NSString *tenantId;

/*!
 *  \~chinese
 *  iOS特有属性，推送证书的名称
 *
 *  只能在[HChatClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  iOS only, push certificate name
 *
 *  Can only set when initialize SDK [HChatClient initializeSDKWithOptions:], can't change it in runtime
 */
@property (nonatomic, strong) NSString *apnsCertName;

/***************SDK 私有部署属性*************/

/*!
 *  \~chinese
 *  是否允许使用DNS, 默认为YES
 *
 *  只能在[HChatClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改。
 *
 *  \~english
 *  Whether to allow using DNS, default is YES
 *
 *  Can only be set when initializing the SDK [HChatClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, assign) BOOL enableDnsConfig;

/*!
 *  \~chinese
 *  IM服务器端口
 *
 *  enableDnsConfig为NO时有效。只能在[HChatClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  IM server port
 *
 *  chatPort is Only effective when isDNSEnabled is NO.
 *  Can only be set when initializing the SDK with [HChatClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, assign) int chatPort;

/*!
 *  \~chinese
 *  IM服务器地址
 *
 *  enableDnsConfig为NO时生效。只能在[HChatClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  IM server
 *
 *  chatServer is Only effective when isDNSEnabled is NO. Can only be set when initializing the SDK with [HChatClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, copy) NSString *chatServer;


/**
 *  客服REST服务器地址,默认:https://kefu.easemob.com ,没有设置的情况下都使用默认地址
 *  只能在[HChatClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 */
@property(nonatomic,copy) NSString *kefuRestServer;

/*!
 *  \~chinese
 *  REST服务器地址
 *
 *  enableDnsConfig为NO时生效。只能在[HChatClient initializeSDKWithOptions:]中设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  REST server
 *
 *  restServer Only effective when isDNSEnabled is NO. Can only be set when initializing the SDK with [HChatClient initializeSDKWithOptions:], cannot be altered in runtime
 */
@property (nonatomic, copy) NSString *restServer;

/**
 是否需要待接入排队功能
 */
@property (nonatomic, assign) BOOL visitorWaitCount;

@end
