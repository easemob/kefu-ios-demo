# Fastboard
<p><a href="./README.md">En</a></p>

快速创建带有操作面板的互动白板界面

支持快速配置操作面板外观

内置常用互动工具，根据需要自由选择

支持跟随ApplePencil系统行为

[高级功能](Advance-zh.md)

# 快速体验
克隆仓库，并且在终端中进入Example目录，执行`pod install`

找到FastboardConfig.xcconfig文件，填入APPID、ROOMUUID和ROOMTOKEN

打开Xcode进入workspace选择你的Team，设定bundle identifier和证书(模拟器不需要)

选择一个模拟器或者真机

按下cmd+R运行示例工程
# 要求设备
运行设备：iOS 10 +，开发环境：Xcode 12+

# 代码示例
### Swift
```swift
// 创建白板房间
let config = FastRoomConfiguration(appIdentifier: *,
                                   roomUUID: *,
                                   roomToken: *,
                                   region: *,
                                   userUID: *)
let fastRoom = Fastboard.createFastRoom(withFastRoomConfig: config)
fastboard.delegate = self
// 添加到视图层级
let fastRoomView = fastRoom.view
view.addSubview(fastRoomView)
fastRoomView.frame = view.bounds
// 白板加入房间
fastRoom.joinRoom()
// 持有白板
self.fastRoom = fastRoom
```
### OC
```ObjectiveC
FastRoomConfiguration* config = [[FastRoomConfiguration alloc] initWithAppIdentifier:* 
                                                                            roomUUID:*
                                                                           roomToken:*
                                                                              region:*
                                                                             userUID:*];
// 创建、持有白板
_fastRoom = [Fastboard createFastRoomWithFastRoomConfig:config];
FastboardView *fastRoomView = _fastRoom.view;
_fastRoom.delegate = self;
// 加入房间
[_fastRoom joinRoom];
//加入视图层级
[self.view addSubview:fastRoomView];
fastRoomView.frame = self.view.bounds;
```

# 接入方式
- CocoaPods
  ```ruby
  pod ‘Fastboard’
  ```

# 房间设置
## 加入房间
```swift
public func joinRoom(completionHandler: ((Result<WhiteRoom, FastError>)->Void)? = nil)
```
## 离开房间
```swift
public func disconnectRoom()
```
## 设置是否可写
  ```swift
  public func updateWritable(_ writable: Bool, completion: ((Error?)->Void)?
  ```
