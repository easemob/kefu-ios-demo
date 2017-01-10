//
//  HOptoins.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMOptions;


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

- (EMOptions *) toEMOptions;

@end
