//
//  ChatClientDelegate.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/3/29.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HError.h"

typedef enum{
    HConnectionConnected = 0,  /*! *\~chinese 已连接 *\~english Connected */
    HConnectionDisconnected,   /*! *\~chinese 未连接 *\~english Not connected */
}HConnectionState;

@protocol HChatClientDelegate<NSObject>
@optional

/*!
 *  \~chinese
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 *  @param aConnectionState 当前状态
 *
 *  \~english
 *  Delegate method will be invoked when server connection state has changed
 *
 *  @param aConnectionState Current state
 */
- (void)connectionStateDidChange:(HConnectionState)aConnectionState;

/*!
 *  \~chinese
 *  当前登录账号在其它设备登录时会接收到此回调
 *
 *  \~english
 *  Delegate method will be invoked when current IM account logged into another device
 */
- (void)userAccountDidLoginFromOtherDevice;

/*!
 *  \~chinese
 *  当前登录账号已经被从服务器端删除时会收到该回调
 *
 *  \~english
 *  Delegate method will be invoked when current IM account is removed from server
 */
- (void)userAccountDidRemoveFromServer;
@end
