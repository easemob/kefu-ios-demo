//
//  WhiteRoomConfig.h
//  WhiteSDK
//
//  Created by yleaf on 2019/3/30.
//

#import "WhiteObject.h"
#import "WhiteMemberInformation.h"
#import "WhiteCameraBound.h"
#import "WhiteConsts.h"
#import "WhiteWindowParams.h"
NS_ASSUME_NONNULL_BEGIN



/** 
 配置实时房间的参数。 

 **Note:** `WhiteRoomConfig` 类中所有的方法都必须在加入房间前调用；成功加入房间后，调用该类中的任何方法都不会生效。
 */
@interface WhiteRoomConfig : WhiteObject

/**
 设置房间 UUID 和用户信息并初始化 `WhiteRoomConfig` 对象。
 @param uuid 房间 UUID，即房间唯一标识符。
 @param roomToken 用于鉴权的 Room Token。生成该 Room Token 的房间 UUID 必须和上面传入的房间 UUID 一致。
 @param uid 用户标识，可以为任意 string。
 @return 初始化的 `WhiteRoomConfig` 对象。
 */
- (instancetype)initWithUUID:(NSString *)uuid roomToken:(NSString *)roomToken uid:(NSString *)uid;

/**
 设置房间 UUID 和用户信息并初始化 `WhiteRoomConfig` 对象。
 @param uuid 房间 UUID，即房间唯一标识符。
 @param roomToken 用于鉴权的 Room Token。生成该 Room Token 的房间 UUID 必须和上面传入的房间 UUID 一致。
 @param uid 用户标识，可以为任意 string，字符串长度不能超过 1024，2.15.0 后必须填写。
 @param userPayload 自定义用户信息内容，必须为字典或者 WhiteObject 子类。
 @return 初始化的 `WhiteRoomConfig` 对象。
 */
- (instancetype)initWithUUID:(NSString *)uuid roomToken:(NSString *)roomToken uid:(NSString *)uid userPayload:(id _Nullable)userPayload NS_DESIGNATED_INITIALIZER;

/** 房间 UUID，即房间唯一标识符。 */
@property (nonatomic, copy, readonly) NSString *uuid;
/** 用于鉴权的 Room Token。 */
@property (nonatomic, copy, readonly) NSString *roomToken;
/** 用户标识记录，*/
@property (nonatomic, copy, readonly) NSString *uid;
/** 
 待回放的互动白板房间所在的数据中心。

 数据中心包括：

 - `"cn-hz"`：中国大陆
 - `"us-sv"`：美国
 - `"in-mum"`：印度
 - `"sg"`：新加坡
 - `"gb-lon"`：英国
 
 @since 2.11.0 
 */
@property (nonatomic, strong, nullable) WhiteRegionKey region;

/**
 禁止/允许工具响应用户输入。

 - `YES`：禁止工具响应用户输入。
 - `NO`：（默认）允许工具响应用户输入。
 */
@property (nonatomic, assign) BOOL disableDeviceInputs;

/**
 禁止/允许本地用户操作白板的视角，包括缩放和移动视角。

 - `YES`：禁止本地用户操作白板视角。
 - `NO`：（默认）允许本地用户操作白板视角。
 */
@property (nonatomic, assign) BOOL disableCameraTransform;

/**
 是否关闭贝塞尔曲线优化。

 - `YES`：关闭贝塞尔曲线优化。
 - `NO`：（默认）开启贝塞尔曲线优化。
 */
@property (nonatomic, assign) BOOL disableBezier;

/**
 @deprecated 该方法已废弃。请使用 [disableDeviceInputs](disableDeviceInputs:) 和 [disableCameraTransform](disableCameraTransform:)。

 允许/禁止白板响应用户任何操作。

 禁止白板响应用户任何操作后，用户无法使用工具输入内容，也无法对白板进行视角缩放和视角移动。
 */
@property (nonatomic, assign) BOOL disableOperations __attribute__((deprecated("please use disableDeviceInputs and disableCameraTransform")));

/**
 是否关闭橡皮擦擦除图片功能。

 - `YES`：橡皮擦不可以擦除图片。
 - `NO`：（默认）橡皮擦可以擦除图片。
 */
@property (nonatomic, assign) BOOL disableEraseImage;

/**
 是否关闭 ``insertText`` 与 ``updateText`` 操作权限
 
 - `YES`：不允许``insertText`` 与 ``updateText``。
 - `NO`：允许``insertText`` 与 ``updateText``。
 */
@property (nonatomic, assign) BOOL disableTextOperations;

/**
 本地用户的视角边界。详见 [WhiteCameraBound](WhiteCameraBound)。
 */
@property (nonatomic, strong, nullable) WhiteCameraBound *cameraBound;

/**
 自定义的用户信息，可以为 JSON、NSString、NSNumber 格式，推荐格式为 NSDictionary。

 **Note:**

 - 必须使用 [WhiteRoomConfig](WhiteRoomConfig) 子类，以保证字段结构正确。
 - 自定义的用户信息会被完整透传。
 如果要在白板房间中显示用户头像，请在 `userPayload` 中传入 `avatar` 字段并添加用户头像的地址，例如 `"avatar", "https://example.com/user.png")`。
 如果要在白板房间中显示用户明层，请在 `userPayload` 中传入 `cursorName` 字段并添加用户名称，例如 `"cursorName", "exampleName"`。
 - 从 [WhiteMemberInformation](WhiteMemberInformation) 迁移，只需要在 `userPayload` 中，传入相同字段即可。
 */
@property (nonatomic, copy, nullable) id userPayload;

/**
 已废弃，请使用 `userPayload`。

 自定义的用户信息。
 */
@property (nonatomic, copy, nullable) WhiteMemberInformation *memberInfo __attribute__((deprecated("memberInfo is deprecated, please use userPayload")));

/**
 用户是否以互动模式加入白板房间。

 在加入房间后，也可以通过 [setWritable](setWritable:completionHandler:) 方法切换读写模式。

 - `YES`：以互动模式加入白板房间，即具有读写权限。
 - `NO`：以订阅模式加入白板房间，即具有只读权限。不能操作工具、修改房间状态，当前用户也不会出现在 `roomMembers` 列表中。
 */
@property (nonatomic, assign) BOOL isWritable;

/**
 关闭/开启笔锋效果。

 @since 2.12.2

 **Note:**

  - 在 2.12.2 版本中，默认值为 `NO`，自 2.12.3 版本起，默认值改为 `YES`。
  - 为正常显示笔迹，在开启笔峰效果前，请确保该房间内的所有用户使用如下 SDK：
    - Android SDK 2.12.3 版或之后
    - iOS SDK 2.12.3 版或之后
    - Web SDK 2.12.5 版或之后

 - `YES`: （默认）关闭笔锋效果。
 - `NO`: 开启笔锋效果。
 */
@property (nonatomic, assign) BOOL disableNewPencil;


/**
 加入房间的超时时间。单位为毫秒。

 SDK 超时后会主动断连，并触发 [firePhaseChanged](firePhaseChanged:) 回调。同时触发 [fireDisconnectWithError](fireDisconnectWithError:) 回调并返回”重连时长超出 xx 毫秒”的提示。
 */
@property (nonatomic, strong) NSNumber *timeout;

///** 是否开启多窗口，默认为 false，开启后，各种 API 会进行更改。正式版该 API 已经迁移到 WhiteSDKConfiguration 中 */
//@property (nonatomic, assign) BOOL useMultiViews;

/** 多窗口用的本地参数，只影响本地客户 */
@property (nonatomic, strong, nullable) WhiteWindowParams *windowParams;

/** 是否启用可写状态监控。
 若开启，在非可写状态调用需要可写权限的房间操作会触发NSAssert，以此来强制正确的api调用。
 监控仅在开发环境生效，生产环境自动失效。
 该参数默认为`NO`
 */
@property (nonatomic, assign) BOOL enableWritableAssert;

/**
 是否只允许用ApplePencil涂鸦
 
 开启后，禁止手指涂鸦，只有ApplePencil的笔迹会被识别。
 在涂鸦时如果有手指误触，将触发 [fireRoomStateChanged](fireRoomStateChanged:) 回调，返回发生 ApplianceClickerClicker 和 ApplianceClickerPencil 教具切换。
 
 该参数仅在 iPad 设备上生效
 建议跟随`UIPencilInteraction.prefersPencilOnlyDrawing`设置
 
 该参数默认为`NO`
 */
@property (nonatomic, assign) BOOL drawOnlyApplePencil;

@end

NS_ASSUME_NONNULL_END

#if __has_include("WhiteRoomConfig+FPA.h")
#import "WhiteRoomConfig+FPA.h"
#endif
