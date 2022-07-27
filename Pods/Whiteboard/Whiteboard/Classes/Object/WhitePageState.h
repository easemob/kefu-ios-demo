//
//  WhitePageState.h
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/10.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/** 开启多窗口后，主白板的页面状态 */
@interface WhitePageState : WhiteObject

/** 当前页*/
@property (nonatomic, assign) NSInteger index;
/** 总页数*/
@property (nonatomic, assign) NSInteger length;

@end

NS_ASSUME_NONNULL_END
