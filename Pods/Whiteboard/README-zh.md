# Whiteboard

本项目为 White-SDK-iOS 的开源版本，为了更好的显示源码结构，`Whiteboard` 将项目分为了多个`subpod`，更有利于开发者查看项目源码层级。为此需要修改引用关系。

[![bridge-check](https://github.com/netless-io/Whiteboard-iOS/actions/workflows/bridge.yml/badge.svg)](https://github.com/netless-io/Whiteboard-iOS/actions/workflows/bridge.yml) [![iOS13+Test](https://github.com/netless-io/Whiteboard-iOS/actions/workflows/test.yml/badge.svg)](https://github.com/netless-io/Whiteboard-iOS/actions/workflows/test.yml)

- [Whiteboard](#whiteboard)
  - [文档](#文档)
  - [引用](#引用)
    - [White-SDK-iOS 迁移](#white-sdk-ios-迁移)
  - [Example](#example)
    - [调试特定房间](#调试特定房间)
    - [单元测试](#单元测试)
  - [要求设备](#要求设备)
  - [项目结构](#项目结构)
  - [Native音视频](#native音视频)
  - [动态ppt本地资源包](#动态ppt本地资源包)
  - [fpa加速（iOS 13 及其以上）](#fpa加速ios-13-及其以上)
  - [自定义App插件](#自定义app插件)
    - [注册自定义App插件](#注册自定义app插件)
    - [添加自定义App插件到白板中](#添加自定义app插件到白板中)
  - [使用YYKit](#使用yykit)
  - [部分问题](#部分问题)
  - [Whiteboard - Framework 拖拽方式集成](#whiteboard---framework-拖拽方式集成)

## 文档

[官网文档](https://developer.netless.link) —— [iOS部分](https://developer.netless.link/ios-zh/home)

## 引用

- ### CocoaPods

```
pod 'Whiteboard'
```

- ### Swift Package Manager
```swift
 dependencies: [
    .package(url: "https://github.com/netless-io/Whiteboard-iOS.git", .upToNextMajor(from: "2.15.0"))
]
```

<details><summary>White-SDK-iOS 闭源库迁移</summary>
### White-SDK-iOS 迁移

只需要将

```Objective-C
#import <White-SDK-iOS/WhiteSDK.h>
```

修改为

```Objective-C
#import <Whiteboard/Whiteboard.h>
```

即可。

使用时，只要 import 以下内容即可。

```Objective-C
#import <Whiteboard/Whiteboard.h>
# 使用白板sdk中任意类
```

</details>
## Example

* 启动Example

```shell
cd Example
pod install
```

进入Example文件夹，打开 `Example.xcworkspace` 项目文件。

>同时在`Whiteboard-Prefix.pch` 根据代码注释填写`WhiteSDKToken`，`WhiteAppIdentifier`。

```Objective-C
/* FIXME: sdkToken
 该 sdk token 不应该保存在客户端中，所有涉及 sdk token 的请求（当前类中所有请求），都应该放在服务器中进行，以免泄露产生不必要的风险。
 */
//#define WhiteSDKToken <#@sdk Token#>
//#define WhiteAppIdentifier <#@App identifier#>
#endif
```

### 调试特定房间

如果需要进入确定的房间进行调试，找到`Whiteboard-Prefix.pch`文件中，取消`WhiteRoomUUID`，以及`WhiteRoomToken`注释，同时填入指定的内容。

```C
# 如果填写了 WhiteRoomUUID WhiteRoomToken，WhiteSDKToken 可以填写为空字符串
//#define WhiteSDKToken <#@sdk Token#>
//#define WhiteAppIdentifier <#@App identifier#>

// 如果需要进入特定房间，取消以下两行注释，同时填入对应的 UUID 以及 roomToken
//#define WhiteRoomUUID  <#Room UUID#>
//#define WhiteRoomToken <#Room Token#>
```

此时，如果在加入或者回放房间时，都会进入该房间。

### 单元测试

单元测试需要对某些特殊行为进行测试，所以需要对应房间有以下操作：

1. 调用过插入图片接口（从单元测试启动的房间，已经开启了图片拦截功能）
1. 发送过特定的自定义事件（已定义在单元测试代码中）
1. 发送过大量自定义事件

## 要求设备

运行设备：iOS 10 + 
开发环境：Xcode 10+

## 项目结构

SDK由多个`subpod`组成，依赖结构如下图所示：

![项目依赖结构](./struct.jpeg)

>参数配置类：用于描述和存储API参数，返回值，状态等配置项的类。主要用于与`webview`进行交互。

1. Object：主要作用是通过`YYModel`处理`JSON`转换。包含以下部分：
    1. `Object`基类，所有`sdk`中使用的参数配置类的基类。
    2. `Room`，`Player`中API所涉及到的一些参数配置类。
2. Base：包含`SDK``Displayer`以及部分相关类，主要为以下部分：
    1. `WhiteSDK`以及其初始化参数类。
    2. `WhiteSDK`设置的通用回调`WhiteCommonCallbacks`
    3. `Room`与`Player`共同的父类`Displayer`类的实现。
    4. `Displayer`中API所使用的一些参数配置类。
    5. `Displayer`用来描述当前房间状态的类，为`RoomState`,`PlayerState`的基类。
3. Room：实时房间相关内容：
    1. `Room`类，及其相关事件回调类。
    1. `WhiteSDK+Room`，使用`SDK`创建`Room`的API。
    1. `Room`特有的参数配置类。
    1. 描述`Room`状态相关的类。
4. Player：回放房间相关内容：
    1. `Player`类，及其相关事件回调类。
    1. `WhiteSDK+Player`，使用`SDK`创建`Player`的API。
    1. `Player`特有的参数配置类。
    1. 描述`Player`状态相关的类。
5. NativePlayer：在`iOS`端播放音视频，并与白板播放状态做同步
    1. `WhiteCombinePlayer`类，及其相关部分类。
6. Converter：动静态转换请求封装类。
    * 动静态转换计费以QPS（日并发）计算，客户端无法控制并发，不推荐在生产环境下使用。详情请参考文档。

## Native音视频

sdk 现在支持使用 CombinePlayer，在 Native 端播放音视频，sdk 会负责音视频与白板回放的状态同步。
具体代码示例，可以参看 `WhitePlayerViewController`

>m3u8 格式的音视频，可能需要经过一次 combinePlayerEndBuffering 调用后，才能进行`seek`播放。（否则可能仍然从初始位置开始播放）

```Objective-C
#import <Whiteboard/Whiteboard.h>

@implementation WhitePlayerViewController

- (void)initPlayer
{

    // 创建 WhitePlayer逻辑
    // 1. 配置 SDK 初始化参数，更多参数，可见 WhiteSdkConfiguration 头文件
    WhiteSdkConfiguration *config = [[WhiteSdkConfiguration alloc] initWithApp:[WhiteUtils appIdentifier]];
    // 2. 初始化 SDK
    self.sdk = [[WhiteSDK alloc] initWithWhiteBoardView:self.boardView config:config commonCallbackDelegate:self.commonDelegate];

    // 3. 配置 WhitePlayerConfig，room uuid 与 roomToken 为必须。其他更多参数，见 WhitePlayerConfig.h 头文件
    WhitePlayerConfig *playerConfig = [[WhitePlayerConfig alloc] initWithRoom:self.roomUuid roomToken:self.roomToken];
    
    //音视频，白板混合播放处理类
    self.combinePlayer = [[WhiteCombinePlayer alloc] initWithMediaUrl:[NSURL URLWithString:@"https://netless-media.oss-cn-hangzhou.aliyuncs.com/c447a98ece45696f09c7fc88f649c082_3002a61acef14e4aa1b0154f734a991d.m3u8"]];
    //显示 AVPlayer 画面
    [self.videoView setAVPlayer:self.combinePlayer.nativePlayer];
    //配置代理
    self.combinePlayer.delegate = self;
    
    [self.sdk createReplayerWithConfig:playerConfig callbacks:self.eventDelegate completionHandler:^(BOOL success, WhitePlayer * _Nonnull player, NSError * _Nonnull error) {
        if (self.playBlock) {
            self.playBlock(player, error);
        } else if (error) {
            NSLog(@"创建回放房间失败 error:%@", [error localizedDescription]);
        } else {
            self.player = player;
            [self.player addHighFrequencyEventListener:@"a" fireInterval:1000];
            
            //配置 WhitePlayer
            self.combinePlayer.whitePlayer = player;/Users/Agora/Documents/Agora/Whiteboard-iOS/README-zh.md
            //WhitePlayer 需要先手动 seek 到 0 才会触发缓冲行为
            [player seekToScheduleTime:0];
        }
    }];
}

#pragma mark - WhitePlayerEventDelegate

- (void)phaseChanged:(WhitePlayerPhase)phase
{
    NSLog(@"player %s %ld", __FUNCTION__, (long)phase);
    // 注意！必须完成该操作，WhiteCombinePlayer 才能正确同步状态
    [self.combinePlayer updateWhitePlayerPhase:phase];
}

// 其他回调方法...

#pragma mark - WhiteCombinePlayerDelegate
- (void)combinePlayerStartBuffering
{
    //任意一端进入缓冲
    NSLog(@"combinePlayerStartBuffering");
}

- (void)combinePlayerEndBuffering
{
    //两端都结束缓冲
    NSLog(@"combinePlayerEndBuffering");
}

@end

```

## 动态ppt本地资源包

原理：提前下载动态转换所有需要的资源包，使用 WKWebView iOS 11 开始支持的自定义 scheme 请求，拦截 webView 请求，返回 native 端本地资源。

具体实现，请查看 git 记录：

1. 所需依赖：`add dependency to demo for ppt zip feature`
2. 代码实现：`implement local zip`
>注意，当前 demo 中，实现拦截，还需要在`WhiteBaseViewController.m`中，将`WhitePptParams `的 scheme 参数为`kPPTScheme`。

[动态转换资源包](https://developer.netless.link/server-zh/home/server-dynamic-conversion-zip)


## fpa加速（iOS 13 及其以上）

1. podfile 添加 `pod 'Whiteboard/fpa'` 依赖
2. 配置 WhiteRoomConfig 的 `nativeWebSocket` 为 YES
3. 如需监听FPA连接状态，可以调用 `[[FpaProxyService sharedFpaProxyService] setupDelegate:(id<FpaProxyServiceDelegate>)self];`

注意：如果是M1的电脑想要在模拟器调试，请在Podfile里加入如下声明：
```ruby
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
```

## 自定义App插件

自定义App插件可以扩展白板功能，用户通过编写js代码来实现自己的白板插件。

[如何开发自定义白板App](https://github.com/netless-io/window-manager/blob/master/docs/develop-app.md)

### 注册自定义App插件

Native端在使用自定义App时需要注册对应的App到SDK中。

注册方法时`WhiteSDk`的`registerAppWithParams:`

其中`WhiteRegisterAppParams`有两种生成方式：
 1. 复制js代码到本地工程，直接注入js字符串。使用这种方法要注意，需要在variable中提供自定义App的变量名，也就是variable。
   
 ```Objective-C
 @interface WhiteRegisterAppParams : WhiteObject
 
/** 创建一个由js代码生成的自定义app
 @param javascriptString js代码字符串
 @param kind 插件类型名称，需要在多端保持一致
 @param appOptions 插件注册额外参数，按需填
 @param variable 在上述注入的javascript中，要插入的app变量名
 */
+ (instancetype)paramsWithJavascriptString: (NSString *)javascriptString kind:(NSString *)kind appOptions:(NSDictionary *)appOptions variable:(NSString *)variable;
 ```
 2. 提供一个js代码的下载地址，由sdk完成下载和注入。使用这种方法要注意，App变量的查找将由kind参数决定。请保持js中App变量名与kind一致。
   ```Objective-C
@interface WhiteRegisterAppParams : WhiteObject

/** 创建一个由远端js生成的自定义app
 @param url js地址
 @param kind 插件类型名称，需要在多端保持一致。（白板会利用这个名字去寻找app入口)
 @param appOptions 插件注册额外参数，按需填
 */
+ (instancetype)paramsWithUrl: (NSString *)url kind:(NSString *)kind appOptions:(NSDictionary *)appOptions;
   ```

### 添加自定义App插件到白板中

添加自定义App方法是`WhiteRoom`的`addApp:comletionHandler:`

其中`WhiteAppParam`用来描述你的自定义App

请调用该方法完成`WhiteAppParam`初始化

```Objective-C
@interface WhiteAppParam : WhiteObject

/** 特定的App，一般用来创建自定义的App插入参数
 @param kind 注册App时使用的kind
 @param options 详见[WhiteAppOptions](WhiteAppOptions)
 @param attrs 初始化App的参数，按需填
 */
- (instancetype)initWithKind:(NSString *)kind options:(WhiteAppOptions *)options attrs:(NSDictionary *)attrs;
```

## 使用YYKit

本SDK默认依赖为YYModel，部分使用者若使用YYKit，依赖关系将会发生错误。

解决方法为修改Podfile:

``` ruby
pod 'Whiteboard/Whiteboard-YYKit'
```

如果你引用了fpa你可以这样声明:

``` ruby
pod 'Whiteboard/fpa-YYKit'
```

## 部分问题

1. 目前 SDK 关键字为`White`，未严格使用前置三大写字母做前缀。
2. 在白板内容比较复杂的情况下，白板有可能会因为内存不足的原因被系统kill掉,导致白屏，我们在 2.16.30 的版本中对该情况进行了主动恢复。在 2.16.30 的版本前，可以通过设置  `WhiteBoardView` 的 `navigationDelegate` 来监听 `webViewWebContentProcessDidTerminate:` 方法。当白板被kill掉时，会调用该方法，你可以在该方法中提示用户重新连接以恢复白板。

## Whiteboard - Framework 拖拽方式集成

Framework 打包(需安装pod package 插件:`sudo gem install cocoapods-packager`)
1. `pod package Whiteboard.podspec --embedded  --force` (基于Github源码)  
2. `pod package Whiteboard.podspec --force --embedded --local`(基于本地源码)  
注意: --local 控制符需要安装以下内容  
`gem install specific_install`
`gem specific_install https://github.com/CocoaPods/cocoapods-packager`
  

关于Framework 手动添加  
Whiteboard.framework  yymodel.framework dsBridge.framework  一并拖入Embed设置为 Do not embed

FAQ：  
遇到问题：have the same architectures (arm64) and can't be in the same fat output file  
参考  
1.https://github.com/CocoaPods/cocoapods-packager/issues/259  

2.“could not build module xxx” 报错：修改工程target  - Allow Non-modular Includes In Framework Modules  

3.Command CodeSign failed with a nonzero exit code报错
Whiteboard.framework 改为Do not embed

- [ ] TODO:framework bundle 路径有问题
