/************************************************************
  *  * EaseMob CONFIDENTIAL
  * __________________
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
  *
  * NOTICE: All information contained herein is, and remains
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#ifndef ChatDemo_UI2_0_ChatDemoUIDefine_h
#define ChatDemo_UI2_0_ChatDemoUIDefine_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define iPhoneXBottomHeight  ([UIScreen mainScreen].bounds.size.height==812?34:0)
#define kWeakSelf __weak __typeof__(self) weakSelf = self;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//notification
#define KNOTIFICATION_ADDMSG_TO_LIST @"KNOTIFICATION_ADDMSG_TO_LIST"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CHAT @"chat"
#define KNOTIFICATION_VEC @"hd_easemob_vec_call"
#define KNOTIFICATION_SETTINGCHANGE @"settingChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

//default

#define kDefaultAppKey @"1400171218061390#kefuchannelapp387"
#define kDefaultCustomerName @"kefuchannelimid_742962"
#define kDefaultCustomerNickname @"访客昵称"
#define kDefaultTenantId @"387"
#define kDefaultProjectId @"48350"
#define kDefaultConfigId @"c9570743-2e93-4287-b52e-1d070d2b997e"

#define kAppKey @"KF_appkey"
#define kCustomerName @"KF_name"
#define kCustomerNickname @"KF_nickname"
#define kCustomerTenantId @"KF_tenantId"
#define kCustomerProjectId @"KF_projectId"
#define kCustomerConfigId @"KF_configId"


#define hxPassWord @"123456"

#endif
