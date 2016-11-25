//
//  HOptoins.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMOptions.h"


@interface HOptions : NSObject

/*!
 *  \~chinese
 *  app唯一标识符
 *
 *  \~english
 *  Application's unique identifier
 */
@property (nonatomic, strong) NSString *appkey;

@property(nonatomic,copy) NSString *tenantId;    //租户ID
@property(nonatomic,strong) NSString  *cname;   //IM服务号
@property(nonatomic,copy) NSString *leaveMsgId;  //留言id

/*!
 *  \~chinese
 *  iOS特有属性，推送证书的名称
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  iOS only, push certificate name
 *
 *  Can only set when initialize SDK [EMClient initializeSDKWithOptions:], can't change it in runtime
 */
@property (nonatomic, strong) NSString *apnsCertName;

- (EMOptions *) toEMOptions;

@end
