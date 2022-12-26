//
//  WhiteSceneState.h
//  WhiteSDK
//
//  Created by yleaf on 2019/2/25.
//

#import "WhiteObject.h"
#import "WhiteScene.h"

NS_ASSUME_NONNULL_BEGIN

/** 场景状态。如果开启了多窗口，需要查看主白板页面数量状态变化，该对象不再有效，需要查看 [WhitePageState](WhitePageState) */
@interface WhiteSceneState : WhiteObject

/** 当前场景组下所有场景的列表。 */
@property (nonatomic, nonnull, strong, readonly) NSArray<WhiteScene *> *scenes;
/** 当前场景的路径（场景目录+当前场景名）。 */
@property (nonatomic, nonnull, strong, readonly) NSString *scenePath;
/** 当前场景在所属场景组中的索引号。 */
@property (nonatomic, assign, readonly) NSInteger index;

@end

NS_ASSUME_NONNULL_END
