//
//  WhiteSceneState.h
//  WhiteSDK
//
//  Created by yleaf on 2019/2/25.
//

#import "WhiteObject.h"
#import "WhiteScene.h"

NS_ASSUME_NONNULL_BEGIN

/** 场景状态。 */
@interface WhiteSceneState : WhiteObject

/** 当前场景组下所有场景的列表。 */
@property (nonatomic, nonnull, strong, readonly) NSArray<WhiteScene *> *scenes;
/** 当前场景的路径（场景目录+当前场景名）。 */
@property (nonatomic, nonnull, strong, readonly) NSString *scenePath;
/** 当前场景在所属场景组中的索引号。 */
@property (nonatomic, assign, readonly) NSInteger index;

@end

NS_ASSUME_NONNULL_END
