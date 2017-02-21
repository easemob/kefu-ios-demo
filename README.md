
如需旧版商城demo请跳转:[2.x商城Demo](https://github.com/easemob/helpdeskdemo-ios/tree/master-2.x)

## 环信客服SDK (iOS 版)


## Introduction


### 开发工具

> **Xcode**


----

## 目录

* [入门指南](#Getting_started_guide)
  1.[工程配置](#Guide_build) <br>
  2.[初始化](#Guide_init)<br>
  3.[注册](#Guide_register)<br>
  4.[登录](#Guide_login)<br>
  5.[退出](#Guide_logout)<br>
  6.[会话](#Guide_Chat)<br>
  7.[日志](#Guide_Log)<br>
  8.[登录状态](#Guide_Login_Status)<br>



#### <A NAME="Guide_build"></A>工程配置，
 1、在工程中导入 HelpDeskSDK 和 HelpDeskUI。【注意在导入的时候选择Create groups】
 2、向Build Settings -> Linking -> Other Linker Flags 中增加-ObjC.
 3、向Build Phases -> Link Binary With Libraries 中添加依赖库
    AudioToolbox.framework
    AVFoundation.framework
    libc++.dylib
    libz.dylib
    libstdc++.6.0.9.dylib
    libsqlite3.dylib
    (Xcode 7 及以上版本，后缀为tbd)
 4、SDK 不支持 bitcode，在 Build Settings → Build Options → Enable Bitcode 中设置 NO。
 5、在工程info.plist文件中 增加隐私权限
    Privacy - Photo Library Usage Description 需要访问您的相册
    Privacy - Microphone Usage Description 需要访问您的麦克风
    Privacy - Camera Usage Description 需要访问您的摄像机
 6、在pch文件或全局.h文件中添加如下代码
   <code>
   #ifdef __OBJC__
   #import "helpdesk_sdk.h"
   #import "HelpDeskUI.h"
   #endif
   </code>


#### <A NAME="Guide_init"></A>初始化
 HOptions *option = [[HOptions alloc] init];
 option.appkey = @"Your appkey"; //(必填项)
 option.tenantId = @"Your tenantId";//(必填项)
 //推送证书名字
 option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
 //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
 HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
 if (initError) { // 初始化错误
 }
#### <A NAME="Guide_Log"></A>设置调试模式

#### <A NAME="Guide_register"></A>注册

注册建议在服务端创建，而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器。
HError *error = [[HChatClient sharedClient] registerWithUsername:@"username" password:@"password"];
error.code:
HErrorNetworkUnavailable 网络不可用
HErrorUserAlreadyExist 用户已存在
HErrorUserAuthenticationFailed 无开放注册权限（后台管理界面设置[开放|授权]）
HErrorUserIllegalArgument 用户名非法

#### <A NAME="Guide_login"></A>登录
由于HChatClient有一个isLoggedInBefore(BOOL)，登录操作前可以先做个判断。
```
HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore != YES) {
        HError *error = [client loginWithUsername:@"username" password:@"password"];
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
HChatClient *client = [HChatClient sharedClient];
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
HError *error = [[HChatClient sharedClient] logout:YES];
if (error) { //登出出错
} else {//登出成功
}
```


### <A NAME="Advanced_Option"></A>高级选项

#### 添加网络监听,可以显示当前是否连接服务器

```
//添加网络监控，一般在app初始化的时候添加监控，第二个参数是执行代理方法的队列，默认是主队列
[[HChatClient sharedClient] addDelegate:self delegateQueue:nil];
//移除网络监控
[[HChatClient sharedClient] removeDelegate:self];
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
[[HChatClient sharedClient].chat addDelegate:self delegateQueue:nil];
//移除消息监控
[[HChatClient sharedClient].chat removeDelegate:self];

- (void)messagesDidReceive:(NSArray *)aMessages{
     //收到普通消息,格式:<HMessage *>
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
     //收到命令消息,格式:<HMessage *>，命令消息不存数据库，一般用来作为系统通知，例如留言评论更新，
     //会话被客服接入，被转接，被关闭提醒
}

- (void)messageStatusDidChange:(HMessage *)aMessage error:(HError *)aError{
     //消息的状态修改，一般可以用来刷新列表，显示最新的状态
}

- (void)messageAttachmentStatusDidChange:(HMessage *)aMessage error:(HError *)aError{
    //发送消息后，会调用，可以在此刷新列表，显示最新的消息
}
```

#  其他更多属性请进入[官网文档](http://docs.easemob.com/cs/300visitoraccess/iossdk)查询


