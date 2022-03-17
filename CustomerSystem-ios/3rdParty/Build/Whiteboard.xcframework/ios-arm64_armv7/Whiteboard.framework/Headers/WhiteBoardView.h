//
//  WhiteBroadView.h
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import <dsbridge/dsbridge.h>

NS_ASSUME_NONNULL_BEGIN

@class WhiteRoom, WhitePlayer;

/**白板界面类。*/
@interface WhiteBoardView : DWKWebView

/**白板房间类。详见 [WhiteRoom](WhiteRoom)。*/
@property (nonatomic, strong, nullable) WhiteRoom *room;
/**白板回放类。详见 [WhitePlayer](WhitePlayer)。*/
@property (nonatomic, strong, nullable) WhitePlayer *player;

/**
 是否禁用 SDK 本身对键盘偏移的处理。

 - `YES`:禁用 SDK 本身对键盘偏移的处理。
 - `NO`:启用 SDK 本身对键盘偏移的处理。
 */
@property (nonatomic, assign) BOOL disableKeyboardHandler;

/**
 初始化白板界面。
 
 @return 初始化的 `WhiteBroadView` 对象。
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
