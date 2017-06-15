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
#define kWeakSelf __weak __typeof__(self) weakSelf = self;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//notification
#define KNOTIFICATION_ADDMSG_TO_LIST @"KNOTIFICATION_ADDMSG_TO_LIST"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CHAT @"chat"
#define KNOTIFICATION_SETTINGCHANGE @"settingChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

//default
//#define kDefaultAppKey @"1141161024115978#kefuchannelapp29593"
//#define kDefaultCustomerName @"kefuchannelimid_012680"
//#define kDefaultCustomerNickname @"昵称"
//#define kDefaultTenantId @"29593"
//#define kDefaultProjectId @"306713"

//#define kDefaultAppKey @"1109170214115812#kefuchannelapp2155"
//#define kDefaultCustomerName @"kefuchannelimid_101289"
//#define kDefaultCustomerNickname @"昵称"
//#define kDefaultTenantId @"2155"
//#define kDefaultProjectId @"56107"

//mine
#define kDefaultAppKey @"1124161024178184#kefuchannelapp29044"
#define kDefaultCustomerName @"kefuchannelimid_008267"
#define kDefaultCustomerNickname @"风口上的🐷"
#define kDefaultTenantId @"29044"
#define kDefaultProjectId @"306164"

//sandbox
//#define kDefaultAppKey @"1146170602115135#kefuchannelapp28237"
//#define kDefaultCustomerName @"kefuchannelimid_600609"
//#define kDefaultCustomerNickname @"风口上的猪"
//#define kDefaultTenantId @"28237"
//#define kDefaultProjectId @"437101"

//sandbox_yuzhao
//#define kDefaultAppKey @"1104161223178990#kefuchannelapp5324"
//#define kDefaultCustomerName @"kefuchannelimid_717892"
//#define kDefaultCustomerNickname @"风口上的猪"
//#define kDefaultTenantId @"5324"
//#define kDefaultProjectId @"89328"

#define kAppKey @"KF_appkey"
#define kCustomerName @"KF_name"
#define kCustomerNickname @"KF_nickname"
#define kCustomerTenantId @"KF_tenantId"
#define kCustomerProjectId @"KF_projectId"


#define hxPassWord @"123456"

#endif
