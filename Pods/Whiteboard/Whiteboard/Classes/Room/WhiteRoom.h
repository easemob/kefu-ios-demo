//
//  WhiteRoom.h
//  dsBridge
//
//  Created by leavesster on 2018/8/11.
//

#import <Foundation/Foundation.h>
#import "WhiteGlobalState.h"
#import "WhiteMemberState.h"
#import "WhiteImageInformation.h"
#import "WhitePptPage.h"
#import "WhiteRoomMember.h"
#import "WhiteBroadcastState.h"
#import "WhiteRoomCallbacks.h"
#import "WhiteRoomState.h"
#import "WhiteEvent.h"
#import "WhiteScene.h"
#import "WhiteSceneState.h"
#import "WhitePanEvent.h"
#import "WhiteDisplayer.h"
#import "WhiteSDK+Room.h"
#import "WhiteAppParam.h"

@class WhiteBoardView;

NS_ASSUME_NONNULL_BEGIN

@interface WhiteRoom : WhiteDisplayer

#pragma mark - 同步 API
/** 当前用户在白板上的序号 id。
 从 0 开始，与该用户在 RoomMember 中的 memberId 相同。
 */
@property (nonatomic, strong, readonly) NSNumber *observerId;
/** 房间 uuid */
@property (nonatomic, copy, readonly) NSString *uuid;
/** 房间的全局状态。详见 [WhiteGlobalState](WhiteGlobalState)。 */
@property (nonatomic, strong, readonly) WhiteGlobalState *globalState;
/** 教具信息 */
@property (nonatomic, strong, readonly) WhiteReadonlyMemberState *memberState;
/** 白板在线成员信息 */
@property (nonatomic, strong, readonly) NSArray<WhiteRoomMember *> *roomMembers;
/** 视角状态信息，用户当前场景状态，主播信息 */
@property (nonatomic, strong, readonly) WhiteBroadcastState *broadcastState;
/** 缩放比例 */
@property (nonatomic, assign, readonly) CGFloat scale;
/** 房间状态信息，继承自 WhiteDisplayerState（Room 与 Player 共同状态）*/
@property (nonatomic, strong, readonly) WhiteRoomState *state;
/** 白板页面（场景）状态，属于房间状态之一 */
@property (nonatomic, strong, readonly) WhiteSceneState *sceneState;
/** 连接状态 */
@property (nonatomic, assign, readonly) WhiteRoomPhase phase;

#pragma mark - Apple Pencil

/**
 设置是否只允许ApplePencil涂鸦
 
 详见 [drawOnlyApplePencil](drawOnlyApplePencil)
 */
- (void)setDrawOnlyApplePencil:(BOOL)drawOnlyPencil;

#pragma mark - Set API

/**
 白板所有人共享的全局状态
 1.0 迁移用户，请阅读文档站中 [页面（场景）管理] ，使用setScencePath API 进行翻页。
 */
- (void)setGlobalState:(WhiteGlobalState * )globalState;

/** 目前主要用来切换教具 */
- (void)setMemberState:(WhiteMemberState *)modifyState;

/** 切换用户视角模式 */
- (void)setViewMode:(WhiteViewMode)viewMode;


#pragma mark - Action API

/** 白板 debug 用的一些信息 */
- (void)debugInfo:(void (^ _Nullable)(NSDictionary * _Nullable dict))completionHandler;

/**
 如果白板窗口大小改变，需要重新调用该方法刷新尺寸。
 查看父类 WhiteDisplayer 类中方法
 */
//- (void)refreshViewSize;

/** 
 主动断开与互动白板实时房间的连接。 

 该方法会把与当前房间对象相关的所有资源释放掉。如果要再次加入房间，需要重新调用 [joinRoomWithConfig](joinRoomWithConfig)。

 @param completeHandler 你可以通过该接口获取 `disconnect` 的调用结果：

 - 如果方法调用成功，则返回房间的全局状态。
 - 如果方法调用失败，则返回错误信息。
 */
- (void)disconnect:(void (^ _Nullable) (void))completeHandler;

/** 用户是否主动断开与白板房间的连接。在调用 `disconnect` 主动断连时，该值会被立即赋值为 `YES`。 */
@property (nonatomic, assign, readonly) BOOL disconnectedBySelf;

/**
 设置用户在房间中是否为互动模式。
 在加入房间前，就可以在 [WhiteRoomConfig](WhiteRoomConfig) 中设置 `isWritable` ，来决定该模式。

 @param writable 用户在房间中是否为互动模式：

  - `YES`：互动模式，即具有读写权限。
  - `NO`：订阅模式，即具有只读权限。

 @param completionHandler 你可以通过该接口获取 `setWritable` 的调用结果：

 - 如果方法调用成功，则返回用户在房间中的读写状态。
 - 如果方法调用失败，则返回错误信息。
 */
- (void)setWritable:(BOOL)writable completionHandler:(void (^ _Nullable)(BOOL isWritable, NSError * _Nullable error))completionHandler;
/** 
 本地用户在当前互动白板实时房间是否为互动模式。

 - `YES`：互动模式，即具有读写权限。
 - `NO`：订阅模式，即具有只读权限。
 */
@property (nonatomic, assign, readonly, getter=isWritable) BOOL writable;


/**
 禁止/允许用户调整（移动或缩放）视角。

 @param disableCameraTransform 是否禁止用户调整视角：

  - `YES`：禁止用户调整视角。
  - `NO`：（默认）允许用户调整视角。
 */
- (void)disableCameraTransform:(BOOL)disableCameraTransform;

/**
 禁止/允许用户操作工具。

 @param disable 是否禁止用户操作工具：

  - `YES`：禁止用户操作工具操作。
  - `NO`：（默认）允许用户操作工具输入操作。
 */
- (void)disableDeviceInputs:(BOOL)disable;

/**
 发送自定义事件。

 @param eventName 自定义事件名称，详见 [WhiteEvent](WhiteEvent)。

 @param payload 自定义事件内容，详见 [WhiteEvent](WhiteEvent)。
 */
- (void)dispatchMagixEvent:(NSString *)eventName payload:(NSDictionary *)payload;

#pragma mark - PPT

/**
 播放动态 PPT 下一步。

 当前 PPT 页面的动画已全部执行完成时，SDK 会将场景切换至下一页 PPT。
 
 注意，多窗口模式下该接口不再生效
 */
- (void)pptNextStep;

/**
 返回动态 PPT 上一步。
 
 当前 PPT 页面的动画全部回退完成时，SDK 会将场景切回至上一页 PPT。
 
 注意，多窗口模式下该接口不再生效
 */
- (void)pptPreviousStep;

#pragma mark - Text API

/**
 * 在指定位置插入文字
 * @param x 第一个字的的左侧边中点，世界坐标系中的 x 坐标
 * @param y 第一个字的的左侧边中点，世界坐标系中的 y 坐标
 * @param textContent 初始化文字的内容
 * @param completionHandler 返回该文字的标识符
 */
- (void)insertText:(CGFloat)x y:(CGFloat)y textContent:(NSString *)textContent completionHandler:(void (^) (NSString * textId))completionHandler;

#pragma mark - Image API

/**
 插入图片显示区域。

 SDK 会根据你传入的 `imageInfo` 在白板上设置并插入图片的显示区域。

 **Note:** 你也可以调用 [insertImage](insertImage:src:) 方法同时传入图片信息和图片的 URL 地址，在白板中插入并展示图片。 

 @param imageInfo 图片信息，详见 [WhiteImageInformation](WhiteImageInformation)。
 @param src 图片 URL 地址，详见 [WhiteImageInformation](WhiteImageInformation)。
 */
- (void)insertImage:(WhiteImageInformation *)imageInfo src:(NSString *)src;

/**
 插入图片显示区域。

 SDK 会根据你传入的 `imageInfo` 在白板上设置并插入图片的显示区域。
 
 @param imageInfo 图片信息，详见 [WhiteImageInformation](WhiteImageInformation)。
 */
- (void)insertImage:(WhiteImageInformation *)imageInfo;

/**
 展示图片。
 
 该方法可以将指定的网络图片展示到指定的图片显示区域。

 **Note:** 调用该方法前，请确保你已经调用 [insertImage](insertImage:src:) 方法在白板上插入了图片的显示区域。

 @param uuid 图片显示区域的 UUID, 即在 [insertImage](insertImage:src:) 方法的 `imageInfo` 中传入的图片 UUID。
 @param src 图片的 URL 地址。必须确保 app 客户端能访问该 URL，否则无法正常展示图片。
 */
- (void)completeImageUploadWithUuid:(NSString *)uuid src:(NSString *)src;

/**
 关闭/开启橡皮擦擦除图片功能。 

 @param disable 是否关闭橡皮擦擦除图片功能：
 
 - `YES`：禁止橡皮擦擦除图片。
 - `NO`：（默认）允许橡皮擦擦除图片。
 */
- (void)disableEraseImage:(BOOL)disable;

#pragma mark - 延时

/** 同步 UTC 时间与本地时间。

 导入 UTC 时间戳（s）后，白板会根据用户本地时间戳，与传入的 UTC 时间戳进行强行同步。

 @since 2.12.24
 
 **Note:** 该 API 要求用户本地时间经过校准，否则可能会造成主动延时。
 */
- (void)syncBlockTimestamp:(NSTimeInterval)timestamp;

/**
 设置远端白板画面同步延时。
 
 调用该方法后，SDK 会延迟同步远端白板画面。
 
 在 CDN 直播场景，设置远端白板画面同步延时，可以防止用户感知错位。  
 **Note:** 该方法不影响本地白板画面的显示，即用户在本地白板上的操作，会立即在本地白板上显示。  

 @param delay 延时时长，单位为秒。
 */
- (void)setTimeDelay:(NSTimeInterval)delay;
@property (nonatomic, assign, readonly) NSTimeInterval delay;

@end


#pragma mark - 页面（场景）管理 API

@interface WhiteRoom (Scene)

/**
 多窗口下更新窗口颜色配置
 
 @param colorScheme (WhitePrefersColorScheme)[WhitePrefersColorScheme]
 */
- (void)setPrefersColorScheme:(WhitePrefersColorScheme)colorScheme;

/** 暗黑模式, 本地效果， 不会同步到远端， 默认Light, 设置auto只有在iOS13以上才会生效*/

/**
 多窗口下更新房间尺寸比例
 
 @param ratio 目标尺寸比例
 */
- (void)setContainerSizeRatio:(NSNumber *)ratio;

/**
 为当前的 WindowManger 直接设置attributes
 
 @param attributes 需要设置的attributes
 */
- (void)setWindowManagerWithAttributes:(NSDictionary *)attributes;

/**
 获取房间当前场景组下的场景状态。 

 @param result 回调。返回当前场景组下的场景状态，详见 [WhiteSceneState](WhiteSceneState)。
 */
- (void)getSceneStateWithResult:(void (^) (WhiteSceneState *state))result;

/**
 获取房间当前场景组下的场景列表。

 @param result 回调。返回当前场景组下的场景列表，详见 [WhiteScene](WhiteScene)。
 */
- (void)getScenesWithResult:(void (^) (NSArray<WhiteScene *> *scenes))result;

/**
 切换至指定的场景。 

 方法调用成功后，房间内的所有用户看到的白板都会切换到指定场景。 

 **Note:**

  - 该方法为同步调用。
  - 调用以下方法修改或新增场景后，无法通过 [setScenePath:](setScenePath:) 立即获取最新的场景状态。此时，如果需要立即获取最新的场景状态，可以调用 [setScenePath:completionHandler:()](setScenePath:completionHandler:)。

 场景切换失败可能有以下原因：

 - 路径不合法，请确保场景路径以 "/"，由场景组和场景名构成。
 - 场景路径对应的场景不存在。
 - 传入的路径是场景组的路径，而不是场景路径。 
 @param path 想要切换到的场景的场景路径，请确保场景路径以 "/"，由场景组和场景名构成，例如，`/math/classA`。
 */

- (void)setScenePath:(NSString *)path;
/**
 切换至指定的场景。
 
 方法调用成功后，房间内的所有用户看到的白板都会切换到指定场景。

 **Note:**

 - 该方法为异步调用。
 - 调用以下方法修改或新增场景后，你可以通过 [getSceneStateWithResult:](getSceneStateWithResult:) 立即获取最新的场景状态。
 
 场景切换失败可能有以下原因：

 - 路径不合法，请确保场景路径以 "/"，由场景组和场景名构成。
 - 场景路径对应的场景不存在。
 - 传入的路径是场景组的路径，而不是场景路径。 
 @param dirOrPath    想要切换到的场景的场景路径，请确保场景路径以 "/"，由场景组和场景名构成，例如，`/math/classA`.
 @param completionHandler 你可以通过该接口获取 `setScenePath` 的调用结果：

 - 如果方法调用成功，则返回 `YES`.
 - 如果方法调用失败，则返回错误信息。
 */
- (void)setScenePath:(NSString *)dirOrPath completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completionHandler;


/**
 切换至当前场景组下的指定场景。
 
 方法调用成功后，房间内的所有用户看到的白板都会切换到指定场景。
 
 **Note:** 指定的场景必须在当前场景组中，否则，方法调用会失败。  
 
 @param index   目标场景在当前场景组下的索引号。
 @param completionHandler 你可以通过该接口获取 `setSceneIndex` 的调用结果：
   - 如果方法调用成功，则返回 `YES`.
   - 如果方法调用失败，则返回错误信息。
 */
- (void)setSceneIndex:(NSUInteger)index completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completionHandler;

/**
 在指定场景组下插入多个场景。 
 **Note:** 调用该方法插入多个场景后不会切换到新插入的场景。如果要切换至新插入的场景，需要调用 [setScenePath](setScenePath)。 

 @param dir    场景组名称，必须以 `/` 开头。不能为场景路径。
 @param scenes 由多个场景构成的数组。单个场景的字段详见 [WhiteScene](WhiteScene)。
 @param index  待插入的多个场景中，第一个场景在该场景组的索引号。如果传入的索引号大于该场景组已有场景总数，新插入的场景会排在现有场景的最后。场景的索引号从 0 开始。 
 */
- (void)putScenes:(NSString *)dir scenes:(NSArray<WhiteScene *> *)scenes index:(NSUInteger)index;

/**
 清除当前场景的所有内容。 

 @param retainPPT 是否保留 PPT 内容：
  
  - `YES`：保留 PPT。
  - `NO`：连 PPT 一起清空。
 */
- (void)cleanScene:(BOOL)retainPPT;

/**
 删除场景或者场景组。 
 @param dirOrPath 场景组路径或者场景路径。如果传入的是场景组，则会删除该场景组下的所有场景。
 **Note:**

 - 互动白板实时房间内必须至少有一个场景。当删除所有的场景后，SDK 会自动生成一个路径为 `/init` 初始场景（房间初始化时的默认场景），并切换到 `/init` 位置。
 - 如果传入的是场景组，则该场景组下的所有场景都会被删除。
 - 如果删除白板当前所在场景，白板会展示被删除场景所在场景组的下一个场景，如果没有下一个，则会移动到上一个，如果都没有，则往上上一级查找
 - 如果删除的是当前场景所在的场景组，例如 `dirA`，SDK 会执行向上递归逻辑选择新的场景作为当前场景，规则如下：
    - 如果当前场景组路径下还有其他场景组，例如 `dirB`，排在被删除的场景组 `dirA` 后面，则将场景切换至
    `dirB` 中的第一个场景（index 为 0）。
    - 如果当前场景组路径下 `dirA` 后不存在场景组，则查看当前场景组路径下是否存在场景；
    如果存在，则将场景切换至当前场景组路径下的第一个场景（index 为 0）。
    - 如果当前场景组路径下 `dirA` 后没有场景组，也不存在任何场景，则查看 `dirA` 前面是否存在场景组 `dirC`；如果存在，则选择 `dirC` 中的第一个场景（index 为 0）。
    - 以上都不满足，则继续向上递归执行该逻辑。
 */
- (void)removeScenes:(NSString *)dirOrPath;

/**
 移动场景。
 
 成功移动场景后，场景路径也会改变。 
 **Note:**

 - 该方法只能移动场景，不能移动场景组，即 `source` 只能是场景路径，不能是场景组路径。
 - 该方法支持改变指定场景在当前所属场景组下的位置，也支持将指定场景移至其他场景组。 
 @param source 需要移动的场景原路径。必须为场景路径，不能是场景组的路径。
 @param target 目标场景组路径或目标场景路径：

  - 当 `target`设置为目标场景组时，表示将指定场景移至其他场景组中，场景路径会发生改变，但是场景名称不变。
  - 当 `target`设置为目标场景路径时，表示改变指定场景在当前场景组的位置，场景路径和场景名都会发生改变。
 */
- (void)moveScene:(NSString *)source target:(NSString *)target;

/**
 插入一个新页面
 该新页面会位于当前的页面的下一页
 */
- (void)addPage;

/**
 插入一个新页面
 该新页面会位于当前的页面的下一页
 @param completionHandler 回调
 */
- (void)addPage:(void(^ _Nullable)(BOOL success))completionHandler;

/**
 删除当前页面
 @param completionHandler 回调
 */
- (void)removePage:(void(^ _Nullable)(BOOL success))completionHandler;

/**
 删除指定页面
 @param index 页面下标
 @param completionHandler 回调
 */
- (void)removePage:(NSUInteger)index completionHandler:(void(^ _Nullable)(BOOL success))completionHandler;

/**
 插入一个新页面
 
 **Note:**
 
 @param scene 新插入的场景对象
 @param afterCurrentScene 是否在当前页面之后。YES: 插入到当前页面之后。 NO: 在插入到最后一页的后面
 */
- (void)addPageWithScene:(WhiteScene * _Nullable )scene afterCurrentScene:(BOOL)afterCurrentScene;

/**
 插入一个新页面
 
 **Note:**
 
 @param scene 新插入的场景对象
 @param afterCurrentScene 是否在当前页面之后。YES: 插入到当前页面之后。 NO: 在插入到最后一页的后面
 @param completionHandler 回调
 */
- (void)addPageWithScene:(WhiteScene * _Nullable )scene afterCurrentScene:(BOOL)afterCurrentScene completionHandler:(void(^ _Nullable)(BOOL success))completionHandler;

/**
 切换到下一页场景
 
 **Note: **
 @param completionHandler 回调，success代表切换是否成功
 */
- (void)nextPage:(void(^ _Nullable)(BOOL success))completionHandler;
/**
 切换到上一页场景
 
 **Note: **
 @param completionHandler 回调，success代表切换是否成功
 */
- (void)prevPage:(void(^ _Nullable)(BOOL success))completionHandler;

/**
 * 以下方法可以对使用【选择框】的工具进行操作。
 */
#pragma mark - 执行操作 API

/**
 复制选中内容。

 该方法会将选中的内容存储到内存中，不会粘贴到白板中。

 **Note:** 该方法仅当 [disableSerialization](disableSerialization) 设为 `NO` 时生效。
 */
- (void)copy;

/**
 粘贴复制的内容。

 该方法会将 [copy](copy) 方法复制的内容粘贴到白板中（用户当前的视角中间）。
 **Note:**

 - 该方法仅当 [disableSerialization](disableSerialization) 设为 `NO` 时生效。
 - 多次调用该方法时，不能保证粘贴的内容每次都在用户当前的视角中间，可能会出现随机偏移。
 */
- (void)paste;

/**
 复制并粘贴选中的内容。 

 该方法会将选中的内容复制并粘贴到白板中（用户当前的视角中间）。 
 **Note:**

 - 该方法仅当 [disableSerialization](disableSerialization) 设为 `NO` 时生效。
 - 多次调用该方法时，不能保证粘贴的内容每次都在用户当前的视角中间，可能会出现随机偏移。
 */
- (void)duplicate;


- (void)deleteOpertion DEPRECATED_MSG_ATTRIBUTE("use deleteOperation");
/**
 * 删除选中内容。
 */
- (void)deleteOperation;

/**
 开启/禁止本地序列化。 

 设置 `disableSerialization(true)` 后，以下方法将不生效：

 - `redo`
 - `undo`
 - `duplicate`
 - `copy`
 - `paste` 

 @warning
 如果要设置 `disableSerialization(false)`，必须确保同一房间内所有用户使用的 SDK 满足以下版本要求，否则会导致 app 客户端崩溃。

 - Web SDK 2.9.2 或之后版本
 - Android SDK 2.9.3 或之后版本
 - iOS SDK 2.9.3 或之后版本 

 @param disable 是否禁止本地序列化：

 - `YES`：（默认）禁止开启本地序列化；
 - `NO`： 开启本地序列化，即可以对本地操作进行解析。
 */
- (void)disableSerialization:(BOOL)disable;

/**
 重做，即回退撤销操作。

 **Note:** 该方法仅当 [disableSerialization](disableSerialization:) 设为 `NO` 时生效。
 */
- (void)redo;

/**
 撤销上一步操作。

 **Note:** 该方法仅当 [disableSerialization](disableSerialization:) 设为 `NO` 时生效。
 */
- (void)undo;

@end

#pragma mark - 异步 API

@interface WhiteRoom (Asynchronous)

/**
 获取房间的全局状态。
 
 **Note:**

 - 该方法为异步调用。
 - 调用 [setGlobalState](setGlobalState) 方法后，可以立刻调用该方法。
 @param result 回调。返回房间的全局状态，详见 [GlobalState](GlobalState)。 
 */
- (void)getGlobalStateWithResult:(void (^) (WhiteGlobalState *state))result;
/** 
 获取当前的工具状态。
 **Note:** 该方法为异步调用。调用 [setMemberState](setMemberState:) 方法后，可以立刻调用该方法。 
 
 @param result 回调。返回当前的工具状态，详见 [MemberState](MemberState)。 
 */
- (void)getMemberStateWithResult:(void (^) (WhiteMemberState *state))result;
/** 
 获取实时房间用户列表。

 **Note:** 
 
 - 该方法为异步调用。
 - 房间的用户列表仅包含互动模式（具有读写权限）的用户，不包含订阅模式（只读权限）的用户。

 @param result 回调。返回当前房间的用户列表，详见 [WhiteRoomMember](WhiteRoomMember)。 
 */
- (void)getRoomMembersWithResult:(void (^) (NSArray<WhiteRoomMember *> *roomMembers))result;
/** 
 获取用户视角状态。
 
 **Note:** 该方法为异步调用。

 @param result 回调。返回当前用户视角状态，详见 [WhiteBroadcastState](WhiteBroadcastState)。 
 */
- (void)getBroadcastStateWithResult:(void (^) (WhiteBroadcastState *state))result;
/** 
 获取房间连接状态。

 **Note:** 该方法为异步调用。
 
 @param result 回调。返回当前房间连接状态，详见 [WhiteRoomPhase](WhiteRoomPhase)。 
 */
- (void)getRoomPhaseWithResult:(void (^) (WhiteRoomPhase phase))result;
/** 
 获取用户当前的视角缩放比例。该方法为异步调用。

 @param result 回调。返回当前视角缩放比例。 
 */
- (void)getZoomScaleWithResult:(void (^) (CGFloat scale))result;
/** 
 获取当前房间状态。

 **Note:** 该方法为异步调用。
 
 @param result 回调。返回当前房间状态，详见 [WhiteRoomState](WhiteRoomState)。
 */
- (void)getRoomStateWithResult:(void (^) (WhiteRoomState *state))result;

@end

@interface WhiteRoom(MainView)

- (void)disableWindowOperation:(BOOL)disable;

/**
 * 添加窗口
 * @param appParams app 类型以及配置内容
 */
- (void)addApp:(WhiteAppParam *)appParams completionHandler:(void (^)(NSString *appId))completionHandler;

/**
 * 关闭窗口
 * 该方法仅在多窗口下有效, 无论appId是否有效都会触发回调
 *
 * @param appId 添加app时返回的id
 */
- (void)closeApp:(NSString *)appId completionHandler:(void (^)(void))completionHandler;

@end

#pragma mark - 弃用方法
@interface WhiteRoom (Deprecated)

/**
 @deprecated 该方法已废弃，请使用 [disableDeviceInputs](disableDeviceInputs:) 和 [disableCameraTransform](disableCameraTransform:)。

 禁止操作。
 @param disable 是否禁止操作，true 为禁止。
 */
- (void)disableOperations:(BOOL)disable DEPRECATED_MSG_ATTRIBUTE("use disableDeviceInputs and disableCameraTransform");

/**
 @deprecated 该方法已废弃，请使用 [moveCamera](moveCamera:)。

 缩小放大白板。
 @param scale 相对于原始大小的比例。
 */
- (void)zoomChange:(CGFloat)scale DEPRECATED_MSG_ATTRIBUTE("use moveCamera:");

/**
 @deprecated 该方法已废弃，请使用 [getScenesWithResult](getScenesWithResult:)。

 获取所有 ppt 图片。
 @param result 回调。返回所有 ppt 图片的地址。
 */
- (void)getPptImagesWithResult:(void (^) (NSArray<NSString *> *pptPages))result DEPRECATED_MSG_ATTRIBUTE("use getScenesWithResult:");

@end

NS_ASSUME_NONNULL_END
