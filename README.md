
如需旧版商城demo请跳转:[2.x商城Demo](https://github.com/easemob/helpdeskdemo-ios/tree/master-2.x)



## 环信客服SDK (iOS 版) ![Build Status](https://travis-ci.org/easemob/kefu-ios-demo.svg?branch=dev-full)


## Introduction


### 开发工具

> **Xcode**


----

## 目录

* [入门指南](#Getting_started_guide)<br>
  1.[工程配置](#Guide_build) <br>
  2.[集成离线推送](#Guide_APNs) <br>
  2.[初始化](#Guide_init)<br>
  3.[注册](#Guide_register)<br>
  4.[登录](#Guide_login)<br>
  5.[退出](#Guide_logout)<br>
  6.[会话](#Guide_Chat)<br>
  7.[登录状态](#Guide_Login_Status)<br>
* [高级选项](#Advanced_Option)<br>


#### <A NAME="Guide_build"></A>工程配置
 请先到[环信官网](http://www.easemob.com/download/cs) 下载"iOS客服访客端SDK".<br>
 1、在工程中导入 HelpDesk.framework、Hyphenate.framework(包含实时音视频) 和 HelpDeskUI.【注意在导入的时候选择Create groups】<br>
 2、选中当前的TARGET,向General → Embedded Binaries 中添加以上两个依赖库. Linked Frameworks and Libraries 中会自动增加. <br>
 3、向Build Settings → Linking → Other Linker Flags 中增加-ObjC【注意区分大小写】. <br>
 4、在工程info.plist文件中 增加隐私权限 <br>
 ```
    Privacy - Photo Library Usage Description 需要访问您的相册
    Privacy - Microphone Usage Description 需要访问您的麦克风
    Privacy - Camera Usage Description 需要访问您的摄像机
 ```
 5、在pch文件或全局.h文件中添加如下代码<br>
 ```
   #ifdef __OBJC__
    #import <HelpDesk/HelpDesk.h>
   #import "HelpDeskUI.h"
   #endif
   ```
#### <A NAME="Guide_APNs"></A>离线推送
```
    //注册APNs推送
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound |   UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    //您注册了推送功能，iOS 会自动回调以下方法，得到 deviceToken，您需要将 deviceToken 传给 SDK。
    // 将得到的deviceToken传给SDK
    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
        [[HDClient sharedClient] bindDeviceToken:deviceToken];
    }

    // 注册deviceToken失败
    - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
        NSLog(@"error -- %@",error);
        //APNS 注册失败，一般是由于使用了通用证书或者是模拟器调试导致，请检查证书并用真机调试。此处是 iOS 系统报的错，如仍不能确定，请从网上查找相关资料。
    }
```
#### <A NAME="Guide_init"></A>初始化
```
 HDOptions *option = [[HDOptions alloc] init];
 option.appkey = @"Your appkey"; //(必填项)
 option.tenantId = @"Your tenantId";//(必填项)
 //推送证书名字
 option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
 //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
 HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option];
 if (initError) { // 初始化错误
 }
 ```

#### <A NAME="Guide_register"></A>注册

注册建议在服务端创建，而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器。
```
HDError *error = [[HDClient sharedClient] registerWithUsername:@"username" password:@"password"];
error.code:
HDErrorNetworkUnavailable 网络不可用
HDErrorUserAlreadyExist 用户已存在
HDErrorUserAuthenticationFailed 无开放注册权限（后台管理界面设置[开放|授权]）
HDErrorUserIllegalArgument 参数不合法
```
#### <A NAME="Guide_login"></A>登陆状态1.4.9.5以后有这个方法
HDClient有一个getIsLoggedInBeforeCompletion() 异步方法 登录操作前可以先做个判断。
HDClient还有有一个getIsLoggedInBefore() 同步方法 登录操作前可以先做个判断。
```
    [[HDClient sharedClient] getIsLoggedInBeforeCompletion:^(BOOL isLoggedInBefore) {
        if (isLoggedInBefore) {
            //进入聊天
            HDMessageViewController *chat = [[HDMessageViewController alloc] initWithConversationChatter:@"IM 服务号"];
             [self.navigationController pushViewController:chat animated:YES];
        }else{
            //注册以后进入聊天
            if ([self registerIMuser]) {
                if ([self login]) {
                    //进入聊天
                    HDMessageViewController *chat = [[HDMessageViewController alloc] initWithConversationChatter:@"IM 服务号"];
                     [self.navigationController pushViewController:chat animated:YES];
                }
            }else{
                //
                NSLog(@"=======注册失败");
            }
        }
        }];

```
#### <A NAME="Guide_login"></A>登录
由于HDClient有一个isLoggedInBefore(BOOL)，登录操作前可以先做个判断。
EMClient 有一个isLoggedIn  和客服sdk 一定要一起判断
```
HDClient *client = [HDClient sharedClient];
EMClient *client = [EMClient sharedClient];
if (client.isLoggedInBefore != YES && [EMClient sharedClient].isLoggedIn != YES) {
        HDError *error = [client loginWithUsername:@"username" password:@"password"];
        if (!error) { //登录成功
            HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"IM 服务号"];
            [self.navigationController pushViewController:chatVC animated:YES];
        } else { //登录失败
            return;
        }
    } else { //已经成功登录
         HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"IM 服务号"];
         [self.navigationController pushViewController:chatVC animated:YES];
    }
}

```

#### <A NAME="Guide_Chat"></A>打开会话页面

```
HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"IM 服务号"];
[self.navigationController pushViewController:chatVC animated:YES];
```
#### <A NAME="Guide_Login_Status"></A>判断是否已经登录

```
HDClient *client = [HDClient sharedClient];
if(client.isLoggedInBefore){
    //已经登录，可以直接进入会话界面
}else{
    //未登录，需要登录后，再进入会话界面
}
```
#### <A NAME="Guide_logout"></A>登出
>登出后则无法收到客服发来的消息
```
//参数为是否解绑推送的devicetoken
HDError *error = [[HDClient sharedClient] logout:YES];
if (error) { //登出出错
} else {//登出成功
}
```
### <A NAME="Advanced_Option"></A>高级选项

#### 添加网络监听,可以显示当前是否连接服务器

```
//添加网络监控，一般在app初始化的时候添加监控，第二个参数是执行代理方法的队列，默认是主队列
[[HDClient sharedClient] addDelegate:self delegateQueue:nil];
//移除网络监控
[[HDClient sharedClient] removeDelegate:self];
/* 有以下几种情况, 会引起该方法的调用:
* 1. 登录成功后, 手机无法上网时, 会调用该回调
* 2. 登录成功后, 网络状态变化时, 会调用该回调*/
- (void)connectionStateDidChange:(HConnectionState)aConnectionState {
    switch (aConnectionState) {
        case HConnectionConnected: {//已连接
            break;
        }
        case HConnectionDisconnected: {//未连接
            break;
        }
        default:
            break;
    }
}
// 当前登录账号已经被从服务器端删除时会收到该回调
- (void)userAccountDidRemoveFromServer {
    
}
//当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice {
    
}
```
#### 添加消息监听

```
//添加消息监控，第二个参数是执行代理方法的队列，默认是主队列
[[HDClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//移除消息监控
[[HDClient sharedClient].chatManager removeDelegate:self];

- (void)messagesDidReceive:(NSArray *)aMessages{
     //收到普通消息,格式:<HDMessage *>
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
     //收到命令消息,格式:<HDMessage *>，命令消息不存数据库，一般用来作为系统通知，例如留言评论更新，
     //会话被客服接入，被转接，被关闭提醒
}

- (void)messageStatusDidChange:(HDMessage *)aMessage error:(HDError *)aError{
     //消息的状态修改，一般可以用来刷新列表，显示最新的状态
}

- (void)messageAttachmentStatusDidChange:(HDMessage *)aMessage error:(HDError *)aError{
    //发送消息后，会调用，可以在此刷新列表，显示最新的消息
}
```

#  其他更多属性请进入[官网文档](http://docs.easemob.com/cs/300visitoraccess/iossdk)查询


